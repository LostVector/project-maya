// Read-only helper-input opportunity probe, not a runtime optimization.
#include "../src/ds4/ds4_kernels.cuh"
#include <hip/hip_runtime.h>
#include <algorithm>
#include <barrier>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <thread>
#include <utility>
#include <vector>
using namespace strata::ds4;
#define CK(x) do { auto e_=(x); if(e_!=hipSuccess){std::fprintf(stderr,"line%d %s: %s\n",__LINE__,#x,hipGetErrorString(e_));std::exit(2);} }while(0)
#define REQ(x) do {if(!(x)){std::fprintf(stderr,"line%d %s\n",__LINE__,#x);std::exit(3);}}while(0)
constexpr unsigned guard=0xa5a5a5a5u;
__host__ __device__ unsigned payload(unsigned i,unsigned seq) {
    const unsigned specials[]={0,0x80000000u,0x7f800000u,0xff800000u,0x7fc00123u,0x7f800123u,1,0x80000001u};
    return i%32<8?specials[i%32]:(i*2654435761u)^(seq*2246822519u);
}
__device__ bool await(const unsigned* f,unsigned seq,const unsigned* quit,unsigned long long timeout_ticks) {
    const auto begin=wall_clock64();
    for(unsigned it=0;(int)(*(volatile const unsigned*)f-seq)<0;++it) {
        if(*(volatile const unsigned*)quit || ((it&1023)==0 && wall_clock64()-begin>timeout_ticks))return false;
    }
    __threadfence_system();return true;
}
__global__ void publish(Req* r,float* px,int D,int T,unsigned seq,const unsigned* ack,unsigned* quit,
                        unsigned* errors,unsigned long long timeout_ticks) {
    __shared__ int ok;
    if(threadIdx.x==0){ok=seq<=2||await(ack,seq-2,quit,timeout_ticks);if(!ok){atomicOr(errors,1u);*(volatile unsigned*)quit=1;}}
    __syncthreads();if(!ok)return;
    for(int j=threadIdx.x;j<T*kPicks;j+=blockDim.x){int t=j/kPicks,i=j%kPicks;r->ids[t][i]=(int)((j+seq)%20)-2;r->w[t][i]=__uint_as_float(0x3d000000u+j);}
    for(int j=threadIdx.x;j<T*D;j+=blockDim.x){unsigned v=payload(j,seq);((unsigned*)&r->x[j/D][j%D])[0]=v;((unsigned*)px)[j]=v;}
    __threadfence_system();__syncthreads();
    if(threadIdx.x==0){r->T=T;__threadfence_system();*(volatile unsigned*)&r->seq=seq;}
}
// This matches helper_take's metadata/copy operations. Both diagnostic arms add the same timestamps and barrier.
template<bool Peer,bool Vector=false> __global__ void take(const Req* req,unsigned seq,int k,int D,const unsigned long long* tab,int n,
    unsigned long long* plan,float* w,float* x,unsigned* ack,unsigned* quit,const float* peer_x,
    unsigned long long* times,int at,unsigned long long timeout_ticks,unsigned* errors) {
    __shared__ int live;__shared__ unsigned long long start;
    if(threadIdx.x==0){bool ok=await(&req->seq,seq,quit,timeout_ticks);live=ok&&*(volatile const unsigned*)&req->seq==seq;if(!live){atomicOr(errors,2u);*(volatile unsigned*)quit=1;}}
    __syncthreads();
    const volatile Req* r=req;const int T=live?min(max(r->T,1),kWin):0;
    if(threadIdx.x==0)start=wall_clock64();__syncthreads();
    for(int j=threadIdx.x;j<kWin*kPicks;j+=blockDim.x){int t=j/kPicks,i=j%kPicks;unsigned long long p=0;
        if(t<T&&i<k){int e=r->ids[t][i];if(e>=0&&e<n)p=tab[e];}plan[j]=p;w[j]=p?r->w[t][i]:0.0f;}
    const float* src=Peer?peer_x:const_cast<const float*>(&r->x[0][0]);
    if(Vector&&D%4==0&&(((uintptr_t)src|(uintptr_t)x)&15)==0){
        typedef unsigned u32x4 __attribute__((ext_vector_type(4)));
        for(int j=threadIdx.x;j<T*(D/4);j+=blockDim.x){int t=j/(D/4),c=j%(D/4);int stride=Peer?D:kMaxDim;
            u32x4 v=*(const volatile u32x4*)(src+t*stride+c*4);((u32x4*)x)[j]=v;}
    }else for(int j=threadIdx.x;j<T*D;j+=blockDim.x)x[j]=Peer?((volatile const float*)peer_x)[j]:r->x[j/D][j%D];
    __syncthreads();
    if(threadIdx.x==0){times[at]=wall_clock64()-start;if(live){__threadfence_system();*(volatile unsigned*)ack=seq;}}
}
__global__ void init(unsigned* p,size_t n){for(size_t j=blockIdx.x*blockDim.x+threadIdx.x;j<n;j+=gridDim.x*blockDim.x)p[j]=guard;}
__global__ void check(const float* x,const float* w,const unsigned long long* plan,int D,int T,int k,unsigned seq,unsigned* errors){
    for(int j=blockIdx.x*blockDim.x+threadIdx.x;j<T*D;j+=gridDim.x*blockDim.x)if(((const unsigned*)x)[j]!=payload(j,seq))atomicOr(errors,4u);
    for(int j=blockIdx.x*blockDim.x+threadIdx.x;j<kWin*kPicks;j+=gridDim.x*blockDim.x){int t=j/kPicks,i=j%kPicks,e=(int)((j+seq)%20)-2;unsigned long long p=t<T&&i<k&&e>=0&&e<384&&e%3?0x100000ull+e*32:0;
        if(plan[j]!=p||((const unsigned*)w)[j]!=(p?0x3d000000u+j:0u))atomicOr(errors,8u);}
    if(blockIdx.x==0&&threadIdx.x<16){int j=threadIdx.x;if(((const unsigned*)x)[j-16]!=guard||((const unsigned*)x)[kWin*D+j]!=guard)atomicOr(errors,16u);}
}
struct Probe {
    int D,khz;hipStream_t writer{},reader{};Req* req{};void* req_base{};unsigned *ack{},*quit{},*errors{},*d_errors{},*outbase{};
    float *peer[2]{},*out{},*weights{};unsigned long long *table{},*plan{},*times{};
    Probe(int d,int source_skew=0,int output_offset=16):D(d){
        CK(hipHostMalloc(&req_base,2*sizeof(Req)+64,hipHostMallocMapped|hipHostMallocPortable));req=(Req*)((char*)req_base+source_skew);
        CK(hipHostMalloc(&ack,64*4,hipHostMallocMapped|hipHostMallocPortable));CK(hipHostMalloc(&quit,4,hipHostMallocMapped|hipHostMallocPortable));
        CK(hipHostMalloc(&errors,4,hipHostMallocMapped|hipHostMallocPortable));
        CK(hipSetDevice(0));CK(hipStreamCreateWithFlags(&writer,hipStreamNonBlocking));for(auto& p:peer)CK(hipMalloc(&p,size_t(kWin)*D*4));
        CK(hipSetDevice(1));CK(hipStreamCreateWithFlags(&reader,hipStreamNonBlocking));CK(hipDeviceGetAttribute(&khz,hipDeviceAttributeWallClockRate,1));REQ(khz>0);
        CK(hipMalloc(&outbase,(size_t(kWin)*D+64)*4));out=(float*)(outbase+output_offset);CK(hipMalloc(&weights,kWin*kPicks*4));CK(hipMalloc(&plan,kWin*kPicks*8));
        CK(hipMalloc(&times,128*8));CK(hipMalloc(&d_errors,4));CK(hipMalloc(&table,384*8));
        std::vector<unsigned long long> t(384);for(int e=0;e<384;++e)t[e]=e%3?0x100000ull+e*32:0;
        CK(hipMemcpy(table,t.data(),t.size()*8,hipMemcpyHostToDevice));
    }
    ~Probe(){CK(hipSetDevice(0));CK(hipStreamDestroy(writer));for(auto p:peer)CK(hipFree(p));CK(hipSetDevice(1));CK(hipStreamDestroy(reader));
        CK(hipFree(outbase));CK(hipFree(weights));CK(hipFree(plan));CK(hipFree(times));CK(hipFree(table));CK(hipFree(d_errors));
        CK(hipHostFree(req_base));CK(hipHostFree(ack));CK(hipHostFree(quit));CK(hipHostFree(errors));}
    void run(int mode,int rows,int count,bool exact,bool varying){
        REQ(count<=128);*quit=*errors=0;for(int i=0;i<64;++i)ack[i]=0;req[0].seq=req[1].seq=0;
        CK(hipSetDevice(1));CK(hipMemsetAsync(d_errors,0,4,reader));init<<<128,256,0,reader>>>(outbase,size_t(kWin)*D+64);CK(hipMemsetAsync(times,0,128*8,reader));CK(hipStreamSynchronize(reader));
        std::barrier start(3);auto nr=[&](int i){const int a[]={1,16,2,8,3,6,4};return varying?a[i%7]:rows;};
        unsigned long long timeout_ticks=(unsigned long long)khz*100; // 100ms, an experimental watchdog, not inference semantics
        std::thread a([&]{CK(hipSetDevice(0));start.arrive_and_wait();for(int i=0;i<count;++i){unsigned seq=i+1;int slot=seq%2;publish<<<1,256,0,writer>>>(req+slot,peer[slot],D,nr(i),seq,ack+slot*32,quit,errors,timeout_ticks);}CK(hipGetLastError());CK(hipStreamSynchronize(writer));});
        std::thread b([&]{CK(hipSetDevice(1));start.arrive_and_wait();for(int i=0;i<count;++i){unsigned seq=i+1;int slot=seq%2;
            if(mode==0)helper_take(req+slot,seq,6,D,table,384,plan,weights,out,ack+slot*32,quit,reader);
            else if(mode==1)take<false><<<1,256,0,reader>>>(req+slot,seq,6,D,table,384,plan,weights,out,ack+slot*32,quit,peer[slot],times,i,timeout_ticks,errors);
            else if(mode==2)take<true><<<1,256,0,reader>>>(req+slot,seq,6,D,table,384,plan,weights,out,ack+slot*32,quit,peer[slot],times,i,timeout_ticks,errors);
            else if(mode==3)take<false,true><<<1,256,0,reader>>>(req+slot,seq,6,D,table,384,plan,weights,out,ack+slot*32,quit,peer[slot],times,i,timeout_ticks,errors);
            else if(mode==4)take<true,true><<<1,256,0,reader>>>(req+slot,seq,6,D,table,384,plan,weights,out,ack+slot*32,quit,peer[slot],times,i,timeout_ticks,errors);
            else helper_take(req+slot,seq,6,D,table,384,plan,weights,out,ack+slot*32,quit,reader,true);
            if(exact)check<<<128,256,0,reader>>>(out,weights,plan,D,nr(i),6,seq,d_errors);
        }CK(hipGetLastError());CK(hipStreamSynchronize(reader));});
        auto begin=std::chrono::steady_clock::now();start.arrive_and_wait();a.join();b.join();double wall=std::chrono::duration<double,std::micro>(std::chrono::steady_clock::now()-begin).count()/count;
        CK(hipSetDevice(1));if(!exact)check<<<128,256,0,reader>>>(out,weights,plan,D,rows,6,count,d_errors);
        unsigned err=0;CK(hipMemcpyAsync(&err,d_errors,4,hipMemcpyDeviceToHost,reader));std::vector<unsigned long long> ticks(count);CK(hipMemcpyAsync(ticks.data(),times,count*8,hipMemcpyDeviceToHost,reader));CK(hipStreamSynchronize(reader));REQ(!err&&!*errors&&!*quit);
        double copy=0;for(auto v:ticks)copy+=double(v)*1000/khz;copy/=count;
        if(!exact)std::printf("TIME D=%d rows=%d mode=%d count=%d wall_us=%.6f ready_copy_us=%.6f\n",D,rows,mode,count,wall,copy);
    }
};
int main(int argc,char**argv){
    bool timing=argc>1&&std::string(argv[1])=="timing";int n=0;CK(hipGetDeviceCount(&n));if(n!=2)return 77;
    for(int i=0;i<2;++i){CK(hipSetDevice(i));int can=0;CK(hipDeviceCanAccessPeer(&can,i,1-i));if(!can)return 77;auto e=hipDeviceEnablePeerAccess(1-i,0);if(e!=hipErrorPeerAccessAlreadyEnabled)CK(e);(void)hipGetLastError();char pci[32];CK(hipDeviceGetPCIBusId(pci,sizeof pci,i));std::printf("DEVICE role=%s pci=%s\n",i==0?"primary":"helper",pci);}
    std::puts("MONITOR_READY");std::fflush(stdout);if(std::getchar()!='G')return 4;
    int chains=0;for(int D:timing?std::vector<int>{5120}:std::vector<int>{5120,4097,8192})
      for(auto layout:timing?std::vector<std::pair<int,int>>{{0,16}}:std::vector<std::pair<int,int>>{{0,16},{0,17},{4,16}}){Probe p(D,layout.first,layout.second);for(int mode=0;mode<6;++mode){p.run(mode,1,28,true,true);++chains;}
        if(timing)for(int rows:{1,3,6,16})for(int block=0;block<3;++block)for(int at=0;at<8;++at){int mode=at==0||at==7?0:(at-1+block)%6;p.run(mode,rows,8,false,false);p.run(mode,rows,64,false,false);}}
    std::printf("PASS dynamic_chains=%d dynamic_transfers=%d\n",chains,chains*28);
    std::puts("MONITOR_DONE");std::fflush(stdout);if(std::getchar()!='Q')return 5;
}
