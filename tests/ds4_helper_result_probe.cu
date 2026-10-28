// Isolated helper weighted-result store/flush screen; no inference-runtime changes.
#include <hip/hip_runtime.h>
#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#define CK(x) do{auto e_=(x);if(e_!=hipSuccess){std::fprintf(stderr,"line%d %s: %s\n",__LINE__,#x,hipGetErrorString(e_));std::exit(2);}}while(0)
#define REQ(x) do{if(!(x)){std::fprintf(stderr,"line%d %s\n",__LINE__,#x);std::exit(3);}}while(0)
constexpr int D=5120, maxT=16, guard=16;
constexpr unsigned sentinel=0xa5a5a5a5u;
__global__ void inputs(float* part,float* weights,unsigned long long* plan,unsigned seed){
    for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<maxT*8*D;i+=gridDim.x*blockDim.x)
        part[i]=float(int((unsigned(i)*131+seed)%31)-15)*0.001f;
    for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<maxT*8;i+=gridDim.x*blockDim.x){weights[i]=float(i%8+1)*.03125f;plan[i]=((i+seed)%3)?1:0;}
}
// Same six ordered FMA contributions and final +0 as the helper's win_combine with no CPU/shared contribution.
__global__ __launch_bounds__(128) void combine(const float* part,const float* weights,const unsigned long long* plan,float* out){
    int t=blockIdx.y,r=blockIdx.x*128+threadIdx.x;float m=0;
    for(int i=0;i<6;++i){int e=t*8+i;float p=plan[e]?part[size_t(e)*D+r]:0.0f;m=__fmaf_rn(weights[e],p,m);}
    out[size_t(t)*D+r]=__fadd_rn(m,0.0f);
}
__global__ void signal(unsigned* flag,unsigned value){__threadfence_system();*(volatile unsigned*)flag=value;}
struct Probe{
    float *parts{},*weights{},*reference{};unsigned long long* plan{};unsigned* flags{};
    float *host_base[2]{},*host[2]{},*local_base[2]{},*local[2]{},*fine_base[2]{},*fine[2]{},*ordinary_base[2]{},*ordinary[2]{};
    hipStream_t stream{};hipEvent_t begin{},end{};
    Probe(){
        CK(hipHostMalloc(&flags,64*4,hipHostMallocPortable|hipHostMallocMapped));
        for(int i=0;i<2;++i){
            CK(hipHostMalloc(&host_base[i],(size_t(maxT)*D+2*guard)*4,hipHostMallocPortable|hipHostMallocMapped));host[i]=host_base[i]+guard;
            CK(hipSetDevice(0));CK(hipExtMallocWithFlags((void**)&fine_base[i],(size_t(maxT)*D+2*guard)*4,hipDeviceMallocFinegrained));fine[i]=fine_base[i]+guard;
            CK(hipMalloc(&ordinary_base[i],(size_t(maxT)*D+2*guard)*4));ordinary[i]=ordinary_base[i]+guard;
            CK(hipSetDevice(1));CK(hipMalloc(&local_base[i],(size_t(maxT)*D+2*guard)*4));local[i]=local_base[i]+guard;
        }
        CK(hipMalloc(&parts,size_t(maxT)*8*D*4));CK(hipMalloc(&weights,maxT*8*4));CK(hipMalloc(&plan,maxT*8*8));CK(hipMalloc(&reference,size_t(maxT)*D*4));
        CK(hipStreamCreateWithFlags(&stream,hipStreamNonBlocking));CK(hipEventCreate(&begin));CK(hipEventCreate(&end));
    }
    ~Probe(){CK(hipSetDevice(1));CK(hipStreamDestroy(stream));CK(hipEventDestroy(begin));CK(hipEventDestroy(end));CK(hipFree(parts));CK(hipFree(weights));CK(hipFree(plan));CK(hipFree(reference));
        for(int i=0;i<2;++i){CK(hipSetDevice(1));CK(hipFree(local_base[i]));CK(hipSetDevice(0));CK(hipFree(fine_base[i]));CK(hipFree(ordinary_base[i]));CK(hipHostFree(host_base[i]));}CK(hipHostFree(flags));}
    void reset(){
        for(int i=0;i<64;++i)flags[i]=0;
        for(int i=0;i<2;++i){std::memset(host_base[i],0xa5,(size_t(maxT)*D+2*guard)*4);CK(hipSetDevice(0));CK(hipMemset(fine_base[i],0xa5,(size_t(maxT)*D+2*guard)*4));CK(hipMemset(ordinary_base[i],0xa5,(size_t(maxT)*D+2*guard)*4));CK(hipSetDevice(1));CK(hipMemset(local_base[i],0xa5,(size_t(maxT)*D+2*guard)*4));}
        // All initialization is complete before using either GPU's buffers on the nonblocking helper stream.
        CK(hipSetDevice(0));CK(hipDeviceSynchronize());CK(hipSetDevice(1));CK(hipDeviceSynchronize());
    }
    void enqueue(int mode,int rows,int i){
        int slot=i%2;float* dst=mode==0?host[slot]:mode==1||mode==3?local[slot]:mode==2?fine[slot]:ordinary[slot];
        combine<<<dim3(D/128,rows),128,0,stream>>>(parts,weights,plan,dst);
        if(mode==3)CK(hipMemcpyPeerAsync(ordinary[slot],0,local[slot],1,size_t(rows)*D*4,stream));
        signal<<<1,1,0,stream>>>(flags+slot*32,i+1);
    }
    void check(int mode,int rows,int i){
        int slot=i%2;CK(hipSetDevice(1));combine<<<dim3(D/128,rows),128,0,stream>>>(parts,weights,plan,reference);CK(hipGetLastError());CK(hipStreamSynchronize(stream));
        std::vector<unsigned> expected(size_t(rows)*D),got(size_t(maxT)*D+2*guard);
        CK(hipMemcpy(expected.data(),reference,expected.size()*4,hipMemcpyDeviceToHost));
        if(mode==0)std::memcpy(got.data(),host_base[slot],got.size()*4);
        else {int dev=mode==1?1:0;CK(hipSetDevice(dev));const float* p=mode==1?local_base[slot]:mode==2?fine_base[slot]:ordinary_base[slot];CK(hipMemcpy(got.data(),p,got.size()*4,hipMemcpyDeviceToHost));}
        REQ(flags[slot*32]==unsigned(i+1));
        if(std::memcmp(expected.data(),got.data()+guard,expected.size()*4)){
            for(size_t j=0;j<expected.size();++j)if(expected[j]!=got[guard+j]){
                std::fprintf(stderr,"MISMATCH mode=%d rows=%d iteration=%d slot=%d index=%zu expected=%08x got=%08x\n",mode,rows,i,slot,j,expected[j],got[guard+j]);break;}
            std::exit(3);
        }
        for(int j=0;j<guard;++j)REQ(got[j]==sentinel&&got[guard+size_t(maxT)*D+j]==sentinel);
        CK(hipSetDevice(1));
    }
    void run(int mode,int rows,int count,bool exact){
        reset();CK(hipSetDevice(1));inputs<<<128,256,0,stream>>>(parts,weights,plan,17);CK(hipStreamSynchronize(stream));
        if(exact){for(int i=0;i<count;++i){inputs<<<128,256,0,stream>>>(parts,weights,plan,19+i);enqueue(mode,rows,i);check(mode,rows,i);}return;}
        auto t0=std::chrono::steady_clock::now();CK(hipEventRecord(begin,stream));
        for(int i=0;i<count;++i)enqueue(mode,rows,i);
        CK(hipEventRecord(end,stream));CK(hipGetLastError());CK(hipStreamSynchronize(stream));
        double wall=std::chrono::duration<double,std::micro>(std::chrono::steady_clock::now()-t0).count()/count;float ms=0;CK(hipEventElapsedTime(&ms,begin,end));check(mode,rows,count-1);
        std::printf("TIME rows=%d mode=%d count=%d wall_us=%.6f device_us=%.6f\n",rows,mode,count,wall,ms*1000/count);
    }
};
int main(int argc,char**argv){
    bool timing=argc>1&&std::string(argv[1])=="timing";int n=0;CK(hipGetDeviceCount(&n));if(n!=2)return 77;
    for(int i=0;i<2;++i){CK(hipSetDevice(i));int can=0;CK(hipDeviceCanAccessPeer(&can,i,1-i));if(!can)return 77;auto e=hipDeviceEnablePeerAccess(1-i,0);if(e!=hipErrorPeerAccessAlreadyEnabled)CK(e);(void)hipGetLastError();char pci[32];CK(hipDeviceGetPCIBusId(pci,sizeof pci,i));std::printf("DEVICE role=%s pci=%s\n",i==0?"primary":"helper",pci);}
    Probe p;std::puts("MONITOR_READY");std::fflush(stdout);if(std::getchar()!='G')return 4;int checked=0;
    for(int rows:{1,2,3,4,6,8,16}){
        for(int m=0;m<5;++m){p.run(m,rows,5,true);checked+=5;}
        if(timing)for(int b=0;b<3;++b)for(int at=0;at<7;++at){int m=at==0||at==6?0:(at-1+b)%5;p.run(m,rows,8,false);p.run(m,rows,64,false);}
    }
    std::printf("PASS dynamic_result_checks=%d\n",checked);std::puts("MONITOR_DONE");std::fflush(stdout);if(std::getchar()!='Q')return 5;
}
