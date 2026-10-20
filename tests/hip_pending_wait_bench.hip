// Standalone diagnostic inspired by https://github.com/ROCm/TheRock/issues/9297.
// No application code, model weights, or production runtime settings are changed.
#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <algorithm>
#define CK(expr) do {hipError_t error=(expr);if(error!=hipSuccess){std::fprintf(stderr,"%s:%d %s: %s\n",__FILE__,__LINE__,#expr,hipGetErrorString(error));std::exit(2);}}while(0)
__global__ void park(unsigned long long ticks) {
 if(threadIdx.x==0){unsigned long long begin=clock64();while(clock64()-begin<ticks){}}
}
__global__ void tiny(float* x,int n){int i=blockIdx.x*blockDim.x+threadIdx.x;if(i<n)x[i]=x[i]+1.0f;}
__global__ void mark(int* x,int index){if(threadIdx.x==0)x[index]=1;}
__global__ void init_big(float*x,int n){for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<n;i+=gridDim.x*blockDim.x)x[i]=1.0f;}
__global__ void read_big(const float*x,float*y,int n){int tid=blockIdx.x*blockDim.x+threadIdx.x;float sum=0.0f;for(int i=tid;i<n;i+=gridDim.x*blockDim.x)sum+=x[i];y[tid]=sum;}
int main(int argc,char**argv){
 int device=argc>1?std::atoi(argv[1]):1,reps=argc>2?std::atoi(argv[2]):20;
 if(reps<2 || reps>1000){std::fprintf(stderr,"reps must be2..1000\n");return 2;}
 int count=0;CK(hipGetDeviceCount(&count));if(device<0 || device>=count)return 2;CK(hipSetDevice(device));
 hipDeviceProp_t props{};CK(hipGetDeviceProperties(&props,device));int driver=0,runtime=0;CK(hipDriverGetVersion(&driver));CK(hipRuntimeGetVersion(&runtime));
 const char* queues=std::getenv("GPU_MAX_HW_QUEUES");
 std::printf("{\"type\":\"environment\",\"device\":%d,\"name\":\"%s\",\"arch\":\"%s\",\"bdf\":\"%04x:%02x:%02x\",\"driver\":%d,\"runtime\":%d,\"GPU_MAX_HW_QUEUES\":\"%s\",\"clock_khz\":%d,\"reps\":%d}\n",device,props.name,props.gcnArchName,props.pciDomainID,props.pciBusID,props.pciDeviceID,driver,runtime,queues?queues:"unset",props.clockRate,reps);std::fflush(stdout);
 constexpr int big_n=64*1024*1024,big_threads=256*256;float*big=nullptr;float*big_out=nullptr;size_t free_bytes=0,total_bytes=0;CK(hipMemGetInfo(&free_bytes,&total_bytes));if(free_bytes<384ull*1024*1024){std::fprintf(stderr,"Need384MiB free for bounded256MiB control; refusing allocation\n");return 4;}CK(hipMalloc(&big,big_n*sizeof(float)));CK(hipMalloc(&big_out,big_threads*sizeof(float)));
 constexpr int n=4096,kernels=200,sides=4;float*data=nullptr;int*marks=nullptr;CK(hipMalloc(&data,n*sizeof(float)));CK(hipMalloc(&marks,sides*sizeof(int)));
 hipStream_t work{},other[sides]{};CK(hipStreamCreateWithFlags(&work,hipStreamNonBlocking));for(auto&s:other)CK(hipStreamCreateWithFlags(&s,hipStreamNonBlocking));
 hipEvent_t begin{},end{},big_end{};CK(hipEventCreate(&begin));CK(hipEventCreate(&end));CK(hipEventCreate(&big_end));
 init_big<<<256,256,0,work>>>(big,big_n);CK(hipGetLastError());CK(hipStreamSynchronize(work));
 // Compile/init before graph capture and timed repetitions.
 CK(hipMemsetAsync(data,0,n*sizeof(float),work));tiny<<<n/256,256,0,work>>>(data,n);CK(hipGetLastError());CK(hipStreamSynchronize(work));
 hipGraph_t graph{};hipGraphExec_t executable{};CK(hipStreamBeginCapture(work,hipStreamCaptureModeThreadLocal));
 for(int i=0;i<kernels;++i)tiny<<<n/256,256,0,work>>>(data,n);
 CK(hipStreamEndCapture(work,&graph));CK(hipGraphInstantiate(&executable,graph,nullptr,nullptr,0));
 std::vector<float>host(n),big_host(big_threads);int host_marks[sides];
 for(int mode=0;mode<2;++mode){
  for(int rep=-2;rep<reps;++rep){
   const int forward[4]={0,4,1,2},reverse[4]={2,1,4,0};
   for(int ordinal=0;ordinal<4;++ordinal){int waits=((rep&1)?reverse:forward)[ordinal];
    CK(hipMemsetAsync(data,0,n*sizeof(float),work));CK(hipMemsetAsync(marks,0,sides*sizeof(int),work));
    //10ms at the reported maximum shader clock; lower clocks can make this longer.
    park<<<1,32,0,work>>>(static_cast<unsigned long long>(props.clockRate)*10ull);
    CK(hipEventRecord(begin,work));
    if(mode)CK(hipGraphLaunch(executable,work));else for(int i=0;i<kernels;++i)tiny<<<n/256,256,0,work>>>(data,n);
    CK(hipGetLastError());CK(hipEventRecord(end,work));
    read_big<<<256,256,0,work>>>(big,big_out,big_n);CK(hipGetLastError());CK(hipEventRecord(big_end,work));
    for(int i=0;i<waits;++i){CK(hipStreamWaitEvent(other[i],big_end,0));mark<<<1,32,0,other[i]>>>(marks,i);CK(hipGetLastError());}
    hipError_t pending=hipEventQuery(begin);if(pending!=hipSuccess && pending!=hipErrorNotReady)CK(pending);
    bool pending_before_start=pending==hipErrorNotReady;(void)hipGetLastError();
    CK(hipStreamSynchronize(work));for(auto s:other)CK(hipStreamSynchronize(s));
    float elapsed=0,big_ms=0;CK(hipEventElapsedTime(&elapsed,begin,end));CK(hipEventElapsedTime(&big_ms,end,big_end));
    CK(hipMemcpy(host.data(),data,n*sizeof(float),hipMemcpyDeviceToHost));CK(hipMemcpy(host_marks,marks,sides*sizeof(int),hipMemcpyDeviceToHost));
    CK(hipMemcpy(big_host.data(),big_out,big_threads*sizeof(float),hipMemcpyDeviceToHost));if(!std::all_of(big_host.begin(),big_host.end(),[](float x){return x==static_cast<float>(big_n/big_threads);})){std::fprintf(stderr,"Large-read mismatch\n");return 3;}
    if(!std::all_of(host.begin(),host.end(),[](float x){return x==static_cast<float>(kernels);})){std::fprintf(stderr,"numeric mismatch\n");return 3;}
    for(int i=0;i<sides;++i)if(host_marks[i]!=(i<waits?1:0)){std::fprintf(stderr,"side completion mismatch\n");return 3;}
    std::printf("{\"type\":\"trial\",\"mode\":\"%s\",\"rep\":%d,\"warmup\":%s,\"ordinal\":%d,\"waits\":%d,\"kernels\":%d,\"total_ms\":%.9g,\"us_per_kernel\":%.9g,\"valid\":true,\"pending_before_start\":%s,\"big_mib\":256,\"big_ms\":%.9g}\n",mode?"graph":"eager",rep,rep<0?"true":"false",ordinal,waits,kernels,elapsed,elapsed*1000.0/kernels,pending_before_start?"true":"false",big_ms);std::fflush(stdout);
   }
  }
 }
 CK(hipGraphExecDestroy(executable));CK(hipGraphDestroy(graph));CK(hipEventDestroy(begin));CK(hipEventDestroy(end));CK(hipEventDestroy(big_end));for(auto s:other)CK(hipStreamDestroy(s));CK(hipStreamDestroy(work));CK(hipFree(data));CK(hipFree(marks));CK(hipFree(big));CK(hipFree(big_out));std::puts("{\"type\":\"complete\",\"valid\":true}");return 0;
}
