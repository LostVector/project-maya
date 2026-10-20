#include "../src/ds4/ds4_kernels.cuh"
#include <hip/hip_runtime.h>
#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <thread>
using namespace strata::ds4;
#define CK(x) do {auto peer_status_=(x);if(peer_status_!=hipSuccess){std::fprintf(stderr,"line%d %s: %s\n",__LINE__,#x,hipGetErrorString(peer_status_));std::exit(2);}}while(0)
#define REQUIRE(x) do {if(!(x)){std::fprintf(stderr,"line%d failed: %s\n",__LINE__,#x);std::exit(3);}}while(0)
constexpr int kCapacity=2048*5120;
constexpr unsigned kGuard=0xdeadbeefu;
__device__ uint32_t input_bits(int i,int rank,unsigned seed) {
    const unsigned special[2][10]={{0,0x80000000u,0x7f7fffffu,0x7f7fffffu,0x00800000u,1,0x007fffffu,0x3f800000u,0x3f800001u,0xff7fffffu},
                                  {0x80000000u,0x80000000u,0xff7fffffu,0x3f800000u,0x00800000u,1,0x80000001u,0xbf800000u,0xb3800000u,0x3f800000u}};
    if(i%32<10)return special[rank][i%32];
    unsigned h=unsigned(i)*2654435761u^(seed*2246822519u+unsigned(rank)*3266489917u);
    return (h&0x807fffffu)|(((h>>23)%240+1)<<23);
}
__global__ void init_input(float*x,int n,int rank,unsigned seed) {
    for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<n;i+=gridDim.x*blockDim.x)x[i]=__uint_as_float(input_bits(i,rank,seed));
    if(blockIdx.x==0 && threadIdx.x==0)for(int j=0;j<4;++j){((unsigned*)x)[j-4]=kGuard;((unsigned*)x)[n+j]=kGuard;}
}
__global__ void expected_values(float*x,int n,unsigned seed) {
    for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<n;i+=gridDim.x*blockDim.x)x[i]=__fadd_rn(__uint_as_float(input_bits(i,0,seed)),__uint_as_float(input_bits(i,1,seed)));
}
__global__ void init_flags(unsigned*x,int n,unsigned value) {
    for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<n;i+=gridDim.x*blockDim.x)x[i]=value;
}
__global__ void check_values(const float*x,const float*ref,int n,unsigned*error) {
    for(int i=blockIdx.x*blockDim.x+threadIdx.x;i<n;i+=gridDim.x*blockDim.x){
        unsigned actual=__float_as_uint(x[i]),expected=__float_as_uint(ref[i]);
        if(actual!=expected){atomicOr(error,2u);if(atomicCAS(error+1,~0u,unsigned(i))==~0u){error[2]=actual;error[3]=expected;}}
        if(!isfinite(x[i]))atomicOr(error,8u);
    }
    if(blockIdx.x==0 && threadIdx.x==0)for(int j=0;j<4;++j)if(((const unsigned*)x)[j-4]!=kGuard || ((const unsigned*)x)[n+j]!=kGuard)atomicOr(error,4u);
}
struct Rank {
    float*storage=nullptr,*x=nullptr,*reference=nullptr;
    PeerAr peer;
    unsigned*counter=nullptr;
    hipStream_t stream{};
    hipEvent_t begin{},end{};
    hipDeviceProp_t props{};
};
int main(){
    int count=0;CK(hipGetDeviceCount(&count));REQUIRE(count==2);
    std::array<Rank,2> ranks;
    constexpr int flag_count=2*kPeerArBlocks*kPeerArFlagStride;
    ArGroup old;old.nm=2;old.slots=2;old.stride=kCapacity;
    CK(hipHostMalloc(&old.data,4ull*kCapacity*sizeof(float),hipHostMallocMapped|hipHostMallocPortable));
    CK(hipHostMalloc(&old.flags,2*2*32*sizeof(unsigned),hipHostMallocMapped|hipHostMallocPortable));
    for(int i=0;i<2;++i){auto&r=ranks[i];CK(hipSetDevice(i));CK(hipGetDeviceProperties(&r.props,i));int supported=0;CK(hipDeviceCanAccessPeer(&supported,i,1-i));REQUIRE(supported);CK(hipDeviceEnablePeerAccess(1-i,0));size_t available,total;CK(hipMemGetInfo(&available,&total));REQUIRE(available>256ull*1024*1024);
        CK(hipStreamCreateWithFlags(&r.stream,hipStreamNonBlocking));CK(hipEventCreate(&r.begin));CK(hipEventCreate(&r.end));
        CK(hipMalloc(&r.storage,(kCapacity+8ull)*sizeof(float)));r.x=r.storage+4;CK(hipMalloc(&r.reference,kCapacity*sizeof(float)));CK(hipMalloc(&r.counter,sizeof(unsigned)));CK(hipMalloc(&r.peer.error,4*sizeof(unsigned)));
        CK(hipExtMallocWithFlags((void**)&r.peer.recv,2ull*kCapacity*sizeof(float),hipDeviceMallocFinegrained));
        CK(hipExtMallocWithFlags((void**)&r.peer.flags,flag_count*sizeof(unsigned),hipDeviceMallocFinegrained));r.peer.stride=kCapacity;r.peer.timeout_ticks=uint64_t(r.props.clockRate)*2000;
        hipPointerAttribute_t attr{};CK(hipPointerGetAttributes(&attr,r.peer.recv));REQUIRE(attr.type==hipMemoryTypeDevice && attr.device==i && !attr.isManaged && (attr.allocationFlags&hipDeviceMallocFinegrained));
        std::printf("PEER_DEVICE rank=%d name=%s bdf=%04x:%02x:%02x fine_flags=%u timeout_ticks=%llu\n",i,r.props.name,r.props.pciDomainID,r.props.pciBusID,r.props.pciDeviceID,attr.allocationFlags,(unsigned long long)r.peer.timeout_ticks);
    }
    for(int i=0;i<2;++i){ranks[i].peer.peer_recv=ranks[1-i].peer.recv;ranks[i].peer.peer_flags=ranks[1-i].peer.flags;}
    auto sync=[&](){for(int i=0;i<2;++i){CK(hipSetDevice(i));CK(hipStreamSynchronize(ranks[i].stream));}};
    auto reset=[&](unsigned first){sync();std::fill(old.flags,old.flags+128,first-1);for(int i=0;i<2;++i){CK(hipSetDevice(i));auto&r=ranks[i];init_flags<<<32,256,0,r.stream>>>(r.peer.flags,flag_count,first-1);CK(hipMemsetAsync(r.counter,0,sizeof(unsigned),r.stream));CK(hipMemsetAsync(r.peer.error,0,4*sizeof(unsigned),r.stream));CK(hipMemsetAsync(r.peer.error+1,0xff,sizeof(unsigned),r.stream));CK(hipGetLastError());}sync();};
    auto errors=[&](){sync();for(int i=0;i<2;++i){unsigned e[4];CK(hipSetDevice(i));CK(hipMemcpy(e,ranks[i].peer.error,sizeof(e),hipMemcpyDeviceToHost));if(e[0]){std::fprintf(stderr,"PEER_ERROR rank=%d flags=%u index=%u actual=%08x expected=%08x\n",i,e[0],e[1],e[2],e[3]);return false;}}return true;};
    reset(1);
    REQUIRE(!allreduce_peer(ranks[0].x,3,ranks[0].peer,0,1,ranks[0].stream));
    REQUIRE(!allreduce_peer(ranks[0].x+1,4,ranks[0].peer,0,1,ranks[0].stream));
    REQUIRE(!allreduce_peer(ranks[0].x,kCapacity+4,ranks[0].peer,0,1,ranks[0].stream));
    REQUIRE(!allreduce_peer(ranks[0].x,4,ranks[0].peer,2,1,ranks[0].stream));
    const int sizes[]={4,12,256,5120,8192,8196,kCapacity,kCapacity-4};
    for(unsigned first:{1u,0xffffffe0u}){
        reset(first);
        // No host barrier between collective calls. Different lengths, guards and sequences exercise slot reuse.
        for(int trial=0;trial<128;++trial){unsigned seq=first+unsigned(trial),seed=unsigned(trial)+first;int n=sizes[trial%8];
            for(int i=0;i<2;++i){CK(hipSetDevice(i));auto&r=ranks[i];init_input<<<256,256,0,r.stream>>>(r.x,n,i,seed);allreduce(r.x,n,old,i,seq,r.counter,r.stream);CK(hipMemcpyAsync(r.reference,r.x,size_t(n)*4,hipMemcpyDeviceToDevice,r.stream));init_input<<<256,256,0,r.stream>>>(r.x,n,i,seed);REQUIRE(allreduce_peer(r.x,n,r.peer,i,seq,r.stream));check_values<<<256,256,0,r.stream>>>(r.x,r.reference,n,r.peer.error);CK(hipGetLastError());
                if(i==0 && trial%17==0)std::this_thread::sleep_for(std::chrono::milliseconds(2));
            }
        }
        REQUIRE(errors());std::printf("PEER_CHAIN first=%u calls=128 variable_sizes=1 signed_zero_extreme_subnormal=1 guards=1 exact=1\n",first);std::fflush(stdout);
    }
    // Missing peer is a deliberate bounded failure, checked independently from successful collective trials.
    reset(1);CK(hipSetDevice(0));auto timeout=ranks[0].peer;timeout.timeout_ticks=uint64_t(ranks[0].props.clockRate)*50;REQUIRE(allreduce_peer(ranks[0].x,4,timeout,0,1,ranks[0].stream));sync();unsigned failure=0;CK(hipSetDevice(0));CK(hipMemcpy(&failure,ranks[0].peer.error,sizeof(failure),hipMemcpyDeviceToHost));REQUIRE(failure==1);std::puts("PEER_TIMEOUT detected=1 bounded=1");
    reset(1);unsigned sequence[2]={0,0};
    for(int n:{5120,16*5120,kCapacity})for(int rep=-2;rep<20;++rep)for(int pos=0;pos<2;++pos){
        int mode=(pos+(rep&1))&1;unsigned seed=unsigned(rep+3)*100+unsigned(pos)+unsigned(n);unsigned seq=++sequence[mode];
        for(int i=0;i<2;++i){CK(hipSetDevice(i));auto&r=ranks[i];init_input<<<256,256,0,r.stream>>>(r.x,n,i,seed);expected_values<<<256,256,0,r.stream>>>(r.reference,n,seed);CK(hipGetLastError());}sync();
        auto begin=std::chrono::steady_clock::now();for(int i=0;i<2;++i){CK(hipSetDevice(i));auto&r=ranks[i];CK(hipEventRecord(r.begin,r.stream));if(mode)REQUIRE(allreduce_peer(r.x,n,r.peer,i,seq,r.stream));else allreduce(r.x,n,old,i,seq,r.counter,r.stream);CK(hipEventRecord(r.end,r.stream));}sync();double wall=std::chrono::duration<double,std::milli>(std::chrono::steady_clock::now()-begin).count();float gpu[2];for(int i=0;i<2;++i){CK(hipSetDevice(i));auto&r=ranks[i];CK(hipEventElapsedTime(&gpu[i],r.begin,r.end));check_values<<<256,256,0,r.stream>>>(r.x,r.reference,n,r.peer.error);CK(hipGetLastError());}REQUIRE(errors());
        std::printf("PEER_BENCH n=%d rep=%d mode=%d warmup=%d wall_ms=%.9g gpu0_ms=%.9g gpu1_ms=%.9g exact=1\n",n,rep,mode,rep<0,wall,gpu[0],gpu[1]);std::fflush(stdout);
    }
    for(int i=0;i<2;++i){CK(hipSetDevice(i));auto&r=ranks[i];CK(hipFree(r.peer.recv));CK(hipFree(r.peer.flags));CK(hipFree(r.peer.error));CK(hipFree(r.counter));CK(hipFree(r.reference));CK(hipFree(r.storage));CK(hipEventDestroy(r.begin));CK(hipEventDestroy(r.end));CK(hipStreamDestroy(r.stream));}CK(hipHostFree(old.data));CK(hipHostFree(old.flags));std::puts("PEER_COMPLETE exact=1");return 0;
}
