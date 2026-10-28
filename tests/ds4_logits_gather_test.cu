// Standalone TP2 vocabulary gather screen. Does not change model execution.
// Host and peer variants retain the existing two-slot flag/ack protocol and scatter.
#include "../src/ds4/ds4_kernels.cuh"
#include <hip/hip_runtime.h>
#include <array>
#include <barrier>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <thread>
#include <string>
#include <vector>
using namespace strata::ds4;
#define CK(x) do { auto e_=(x); if(e_!=hipSuccess) { std::fprintf(stderr,"line %d: %s: %s\n",__LINE__,#x,hipGetErrorString(e_)); std::exit(2); } } while(0)
#define REQ(x) do { if(!(x)) { std::fprintf(stderr,"line %d: %s\n",__LINE__,#x); std::exit(3); } } while(0)
constexpr unsigned sentinel=0xa5a5a5a5u;
constexpr int maxrows=16, guard=16;
__host__ __device__ unsigned bits(unsigned i,unsigned seed) {
    const unsigned special[]={0,0x80000000u,0x7f800000u,0xff800000u,0x7fc01234u,0x7f801234u,1,0x80000001u};
    return i%32<8 ? special[i%32] : (i*2654435761u)^(seed*2246822519u);
}
__global__ void init(unsigned* p,size_t n,unsigned seed,bool pattern) {
    for(size_t i=blockIdx.x*blockDim.x+threadIdx.x;i<n;i+=gridDim.x*blockDim.x) p[i]=pattern?bits(i,seed):sentinel;
}
__global__ void check(const unsigned* out,int V,int v0,int vn,int rows,unsigned seed,
                      const unsigned* input,const unsigned* stage0,const unsigned* stage1,size_t cap,unsigned* errors) {
    for(size_t i=blockIdx.x*blockDim.x+threadIdx.x;i<size_t(maxrows)*V;i+=gridDim.x*blockDim.x) {
        int row=i/V,col=i%V;
        unsigned want=(row<rows&&col>=v0&&col<v0+vn)?bits(size_t(row)*vn+col-v0,seed):sentinel;
        if(out[i]!=want) atomicAdd(errors,1u);
    }
    if(blockIdx.x==0&&threadIdx.x<guard) {
        int j=threadIdx.x;
        if(out[j-guard]!=sentinel||out[size_t(maxrows)*V+j]!=sentinel) atomicAdd(errors,1u);
        if(input[j-guard]!=sentinel||input[cap+j]!=sentinel) atomicAdd(errors,1u);
        if(stage0[j-guard]!=sentinel||stage0[cap+j]!=sentinel||stage1[j-guard]!=sentinel||stage1[cap+j]!=sentinel) atomicAdd(errors,1u);
    }
}
struct GatherProbe {
    int lead,other,V,v0,vn; size_t cap;
    unsigned *input_base{},*input{},*output_base{},*output{},*tmp{},*cnt{},*errors{};
    unsigned *host_base[2]{},*host[2]{},*peer_base[2]{},*peer[2]{},*copy_base[2]{},*copy[2]{};
    unsigned *flags{},*acks{}; hipStream_t producer{},consumer{}; hipEvent_t begin{},end{};
    GatherProbe(int l,int vocab):lead(l),other(1-l),V(vocab) {
        REQ(V%128==0); const int chunks=V/128, first=(chunks+1)/2;
        v0=first*128; vn=V-v0; cap=size_t(maxrows)*vn;
        CK(hipHostMalloc(&flags,64*sizeof(unsigned),hipHostMallocMapped|hipHostMallocPortable));
        CK(hipHostMalloc(&acks,64*sizeof(unsigned),hipHostMallocMapped|hipHostMallocPortable));
        for(int j=0;j<2;++j) {
            CK(hipHostMalloc(&host_base[j],(cap+2*guard)*4,hipHostMallocMapped|hipHostMallocPortable)); host[j]=host_base[j]+guard;
        }
        CK(hipSetDevice(other)); CK(hipStreamCreateWithFlags(&producer,hipStreamNonBlocking));
        CK(hipMalloc(&input_base,(cap+2*guard)*4)); input=input_base+guard;
        CK(hipMalloc(&cnt,4));
        CK(hipSetDevice(lead)); CK(hipStreamCreateWithFlags(&consumer,hipStreamNonBlocking));
        CK(hipEventCreate(&begin)); CK(hipEventCreate(&end));
        CK(hipMalloc(&output_base,(size_t(maxrows)*V+2*guard)*4)); output=output_base+guard;
        CK(hipMalloc(&tmp,cap*4)); CK(hipMalloc(&errors,4));
        for(int j=0;j<2;++j) {
            CK(hipExtMallocWithFlags((void**)&peer_base[j],(cap+2*guard)*4,hipDeviceMallocFinegrained)); peer[j]=peer_base[j]+guard;
            CK(hipMalloc(&copy_base[j],(cap+2*guard)*4)); copy[j]=copy_base[j]+guard;
        }
    }
    ~GatherProbe() {
        CK(hipSetDevice(other)); CK(hipStreamDestroy(producer)); CK(hipFree(input_base)); CK(hipFree(cnt));
        CK(hipSetDevice(lead)); CK(hipStreamDestroy(consumer)); CK(hipEventDestroy(begin)); CK(hipEventDestroy(end));
        CK(hipFree(output_base)); CK(hipFree(tmp)); CK(hipFree(errors));
        for(int j=0;j<2;++j) { CK(hipFree(peer_base[j])); CK(hipFree(copy_base[j])); CK(hipHostFree(host_base[j])); }
        CK(hipHostFree(flags)); CK(hipHostFree(acks));
    }
    // mode0: unchanged host-mapped path; mode1: same kernels, fine-grained peer stage;
    // mode2: peer copy engine plus publication, same receive/scatter/ack.
    double run(int mode,int rows,int count,bool exact,bool varying) {
        for(int j=0;j<64;++j) flags[j]=acks[j]=0;
        CK(hipSetDevice(other)); CK(hipMemset(cnt,0,4));
        init<<<128,256,0,producer>>>(input_base,cap+2*guard,0,false);
        init<<<128,256,0,producer>>>(input,cap,17,true); CK(hipStreamSynchronize(producer));
        CK(hipSetDevice(lead)); CK(hipMemset(errors,0,4));
        init<<<128,256,0,consumer>>>(output_base,size_t(maxrows)*V+2*guard,0,false);
        for(int j=0;j<2;++j) {
            init<<<128,256,0,consumer>>>(peer_base[j],cap+2*guard,0,false);
            init<<<128,256,0,consumer>>>(copy_base[j],cap+2*guard,0,false);
            for(size_t k=0;k<cap+2*guard;++k) host_base[j][k]=sentinel;
        }
        CK(hipStreamSynchronize(consumer));
        std::barrier start(3);
        auto nrows=[&](int i) { constexpr int shapes[]={1,16,2,8,3,6,4}; return varying?shapes[i%7]:rows; };
        std::thread writer([&] {
            CK(hipSetDevice(other)); start.arrive_and_wait();
            for(int i=0;i<count;++i) {
                unsigned seq=i+1; int slot=seq%2, nr=nrows(i);
                if(seq>2) wait_flags(acks+slot*32,1,32,seq-2,producer);
                if(exact) init<<<128,256,0,producer>>>(input,size_t(nr)*vn,i+19,true);
                unsigned* stage=mode==0?host[slot]:(mode==1?peer[slot]:copy[slot]);
                size_t bytes=size_t(nr)*vn*4;
                if(mode==2) {
                    CK(hipMemcpyPeerAsync(stage,lead,input,other,bytes,producer));
                    set_flag(flags+slot*32,seq,producer);
                } else {
                    Xfer x; x.n=1; x.src[0]=input; x.dst[0]=stage; x.bytes[0]=bytes;
                    xfer_put(x,flags+slot*32,seq,cnt,producer);
                }
            }
            CK(hipGetLastError()); CK(hipStreamSynchronize(producer));
        });
        std::thread reader([&] {
            CK(hipSetDevice(lead)); start.arrive_and_wait(); CK(hipEventRecord(begin,consumer));
            for(int i=0;i<count;++i) {
                unsigned seq=i+1; int slot=seq%2, nr=nrows(i);
                if(exact) init<<<128,256,0,consumer>>>(output,size_t(maxrows)*V,0,false);
                Xfer x; x.n=1; x.src[0]=mode==0?host[slot]:(mode==1?peer[slot]:copy[slot]); x.dst[0]=tmp; x.bytes[0]=size_t(nr)*vn*4;
                xfer_get(x,flags+slot*32,seq,consumer);
                CK(hipMemcpy2DAsync(output+v0,size_t(V)*4,tmp,size_t(vn)*4,size_t(vn)*4,nr,hipMemcpyDeviceToDevice,consumer));
                // Input may be overwritten for another slot, so only input's guards are read here.
                if(exact) check<<<128,256,0,consumer>>>(output,V,v0,vn,nr,i+19,input,mode==0?host[0]:(mode==1?peer[0]:copy[0]),mode==0?host[1]:(mode==1?peer[1]:copy[1]),cap,errors);
                set_flag(acks+slot*32,seq,consumer);
            }
            CK(hipEventRecord(end,consumer)); CK(hipGetLastError()); CK(hipStreamSynchronize(consumer));
        });
        auto t0=std::chrono::steady_clock::now(); start.arrive_and_wait(); writer.join(); reader.join();
        double wall=std::chrono::duration<double,std::micro>(std::chrono::steady_clock::now()-t0).count()/count;
        CK(hipSetDevice(lead));
        if(!exact) check<<<128,256,0,consumer>>>(output,V,v0,vn,rows,17,input,mode==0?host[0]:(mode==1?peer[0]:copy[0]),mode==0?host[1]:(mode==1?peer[1]:copy[1]),cap,errors);
        unsigned err=0; CK(hipMemcpyAsync(&err,errors,4,hipMemcpyDeviceToHost,consumer)); CK(hipStreamSynchronize(consumer)); REQ(err==0);
        float ms=0; CK(hipEventElapsedTime(&ms,begin,end));
        if(!exact) std::printf("TIME lead=%d V=%d rows=%d mode=%d count=%d wall_us=%.6f device_us=%.6f\n",lead,V,rows,mode,count,wall,ms*1000/count);
        return wall;
    }
};
int main(int argc,char**argv) {
    bool timing=argc>1&&std::string(argv[1])=="timing";
    int n=0; CK(hipGetDeviceCount(&n)); if(n!=2) return 77;
    for(int i=0;i<2;++i) {
        CK(hipSetDevice(i)); int can=0; CK(hipDeviceCanAccessPeer(&can,i,1-i)); if(!can) return 77;
        auto e=hipDeviceEnablePeerAccess(1-i,0); if(e!=hipErrorPeerAccessAlreadyEnabled) CK(e); (void)hipGetLastError();
        char pci[32]; CK(hipDeviceGetPCIBusId(pci,sizeof pci,i)); size_t free=0,total=0; CK(hipMemGetInfo(&free,&total));
        std::printf("DEVICE rank=%d pci=%s free=%zu\n",i,pci,free); if(free<(128ull<<20)) return 77;
    }
    int passed=0;
    for(int lead=0;lead<2;++lead) for(int V:timing?std::vector<int>{129280}:std::vector<int>{129280,129152,129408}) {
        GatherProbe g(lead,V);
        for(int mode=0;mode<3;++mode) { g.run(mode,1,28,true,true); ++passed; }
        if(timing) for(int rows:{1,2,3,4,6,8,16}) {
            // Predeclared Latin order with a host control bracketing each block.
            for(int block=0;block<3;++block) for(int at=0;at<5;++at) {
                int mode=at==0||at==4?0:(at-1+block)%3;
                g.run(mode,rows,8,false,false); g.run(mode,rows,64,false,false);
            }
        }
    }
    std::printf("PASS dynamic_chains=%d dynamic_transfers=%d\n",passed,passed*28);
}
