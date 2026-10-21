#include "../src/ds4/ds4_kernels.cuh"
#include <hip/hip_runtime.h>
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <numeric>
#include <vector>
using namespace strata::ds4;
#define CK(x) do{auto e=(x);if(e!=hipSuccess){std::fprintf(stderr,"line%d %s\n",__LINE__,hipGetErrorString(e));return 2;}}while(0)
static unsigned rng=0x45b117u;
static unsigned next(){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static float val(){return (int(next()%65537)-32768)/32768.f;}
static unsigned bits(float x){unsigned b;std::memcpy(&b,&x,4);return b;}
__global__ void evict(const unsigned* data,size_t n,unsigned* out){unsigned x=0;const unsigned tid=blockIdx.x*blockDim.x+threadIdx.x;for(size_t i=size_t(tid)*16;i<n;i+=size_t(gridDim.x)*blockDim.x*16)x^=((const volatile unsigned*)data)[i];out[tid]=x;}
struct Case{const char*name;int T,D,k,pct,hits;bool empty=false;};
int main(int argc,char**argv){
 const int modes[3]={0,2,3};
 int gpu=argc>1?std::atoi(argv[1]):1;CK(hipSetDevice(gpu));hipDeviceProp_t prop{};CK(hipGetDeviceProperties(&prop,gpu));size_t free,total;CK(hipMemGetInfo(&free,&total));std::printf("DEVICE gpu=%d name=%s free_bytes=%zu\n",gpu,prop.name,free);std::fflush(stdout);if(free<1200ull*1024*1024)return 4;
 hipStream_t s;hipEvent_t a,b;CK(hipStreamCreateWithFlags(&s,hipStreamNonBlocking));CK(hipEventCreate(&a));CK(hipEventCreate(&b));
 unsigned *trash,*checksum;const size_t evict_bytes=256ull*1024*1024;CK(hipMalloc(&trash,evict_bytes));CK(hipMalloc(&checksum,1024*256*4));CK(hipMemsetAsync(trash,0x37,evict_bytes,s));
 const Case cases[]={{"sparse1",4096,5120,6,1,1},{"sparse10",4096,5120,6,10,1},{"half",4096,5120,6,50,1},{"full1",4096,5120,6,100,1},{"sparse10x3",4096,5120,6,10,3},{"sparse1x6",4096,5120,6,1,6},{"dense6",4096,5120,6,100,6},{"no_hits",4096,5120,6,0,1},{"ragged_cpu",73,519,6,37,3},{"ragged_one_cpu",73,519,6,37,1},{"ragged_six_cpu",73,519,6,7,6},{"other_k",31,513,3,51,2},{"empty_range",17,257,6,100,1,true}};
 bool all=true;
 for(const auto&c:cases){
  rng=0x45b117u+c.T+c.pct;const size_t N=size_t(c.T)*c.D;int active=(c.T*c.pct+99)/100,nr=active*c.hits;const int r0=13,r1=c.empty?r0:r0+std::max(1,nr);std::vector<int> tokens(c.T),pos(size_t(c.T)*8,-1);std::iota(tokens.begin(),tokens.end(),0);for(int i=c.T-1;i>0;--i)std::swap(tokens[i],tokens[next()%unsigned(i+1)]);std::vector<bool> chosen(c.T);for(int i=0;i<active;++i)chosen[tokens[i]]=true;
  std::vector<float> input(N),y(size_t(std::max(1,nr))*c.D),w(size_t(c.T)*8),reference(N),actual(N+8);for(size_t i=0;i<N;++i)input[i]=i%257==0?(i&1?-0.f:0.f):val()*.125f;for(auto&v:y)v=val()*.25f;for(size_t i=0;i<w.size();++i)w[i]=i%23==0?0.f:val();int mi=0,oi=0;
  for(int t=0;t<c.T;++t)for(int i=0;i<c.k;++i){bool hit=chosen[t]&&((i-t%c.k+c.k)%c.k)<c.hits;pos[size_t(t)*8+i]=hit?r0+mi++:r0+std::max(1,nr)+oi++;}if(mi!=nr)return 5;
  std::vector<int> permutation(std::max(1,nr));std::iota(permutation.begin(),permutation.end(),0);for(int i=nr-1;i>0;--i)std::swap(permutation[i],permutation[next()%unsigned(i+1)]);for(auto&v:pos)if(v>=r0&&v<r1)v=r0+permutation[v-r0];
  std::vector<int> rowtok(size_t(r1)+4,0);for(int t=0;t<c.T;++t)for(int i=0;i<c.k;++i){int r=pos[size_t(t)*8+i];if(r>=r0&&r<r1)rowtok[r]=t;}
  float *dy,*dw,*storage;int*dp,*drt;CK(hipMalloc(&drt,rowtok.size()*4));CK(hipMemcpy(drt,rowtok.data(),rowtok.size()*4,hipMemcpyHostToDevice));CK(hipMalloc(&dy,y.size()*4));CK(hipMalloc(&dw,w.size()*4));CK(hipMalloc(&storage,(N+8)*4));CK(hipMalloc(&dp,pos.size()*4));CK(hipMemcpy(dy,y.data(),y.size()*4,hipMemcpyHostToDevice));CK(hipMemcpy(dw,w.data(),w.size()*4,hipMemcpyHostToDevice));CK(hipMemcpy(dp,pos.data(),pos.size()*4,hipMemcpyHostToDevice));float*out=storage+4;
  auto run=[&](){moe_combine(out,dy,dp,dw,c.T,c.k,r0,r1,c.D,s,drt);};
  for(int option=0;option<3;++option){int mode=modes[option];setenv("DS4_MOE_COMBINE_MODE",mode==0?"0":mode==2?"2":"3",1);CK(hipMemsetAsync(storage,0xa5,(N+8)*4,s));CK(hipMemcpyAsync(out,input.data(),N*4,hipMemcpyHostToDevice,s));run();CK(hipGetLastError());CK(hipStreamSynchronize(s));CK(hipMemcpy(actual.data(),storage,(N+8)*4,hipMemcpyDeviceToHost));if(mode==0)std::copy(actual.begin()+4,actual.begin()+4+N,reference.begin());size_t mismatch=0,cpu_mismatch=0;bool finite=true,guards=true;
   for(size_t i=0;i<N;++i){mismatch+=bits(actual[i+4])!=bits(reference[i]);finite=finite&&std::isfinite(actual[i+4]);if(c.T<100){const int t=i/c.D,e=i%c.D;float v=input[i];for(int j=0;j<c.k;++j){int row=pos[size_t(t)*8+j];if(row>=r0&&row<r1)v=std::fma(w[size_t(t)*8+j],y[size_t(row-r0)*c.D+e],v);}cpu_mismatch+=bits(v)!=bits(actual[i+4]);}}
   for(int i=0;i<4;++i)guards=guards&&bits(actual[i])==0xa5a5a5a5u&&bits(actual[N+4+i])==0xa5a5a5a5u;all=all&&!mismatch&&!cpu_mismatch&&finite&&guards;std::printf("PARITY case=%s mode=%d floats=%zu mismatches=%zu cpu_checked=%d cpu_mismatches=%zu finite=%d guards=%d active_tokens=%d batch_rows=%d\n",c.name,mode,N,mismatch,int(c.T<100),cpu_mismatch,int(finite),int(guards),active,nr);std::fflush(stdout);
  }
  // Accumulators continue evolving during timing as they do across expert batches.
  // Eviction is outside the events and applies equally before every option.
  for(int rep=-2;rep<12;++rep)for(int j=0;j<3;++j){int mode=modes[(rep&1)?2-j:j];setenv("DS4_MOE_COMBINE_MODE",mode==0?"0":mode==2?"2":"3",1);evict<<<1024,256,0,s>>>(trash,evict_bytes/4,checksum);CK(hipGetLastError());CK(hipEventRecord(a,s));auto start=std::chrono::steady_clock::now();run();CK(hipGetLastError());CK(hipEventRecord(b,s));CK(hipEventSynchronize(b));float ms;CK(hipEventElapsedTime(&ms,a,b));double wall=std::chrono::duration<double,std::milli>(std::chrono::steady_clock::now()-start).count();std::printf("TIME case=%s rep=%d warmup=%d mode=%d gpu_ms=%.9g host_queue_wall_ms=%.9g\n",c.name,rep,int(rep<0),mode,ms,wall);std::fflush(stdout);}
  CK(hipFree(drt));CK(hipFree(dy));CK(hipFree(dw));CK(hipFree(dp));CK(hipFree(storage));
 }
 CK(hipFree(trash));CK(hipFree(checksum));CK(hipEventDestroy(a));CK(hipEventDestroy(b));CK(hipStreamDestroy(s));std::printf("COMPLETE exact=%d\n",int(all));return all?0:3;
}
