#include "../src/ds4/ds4_dense_recon_cache.hpp"
#include <hip/hip_runtime.h>
#include <hip/hip_fp16.h>
#include <cublas_v2.h>
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
namespace x3 = strata::kernels::exl3;
using strata::ds4::DenseReconCache;
#define CK(x) do { auto e=(x); if(e!=hipSuccess){std::fprintf(stderr,"HIP line%d %s\n",__LINE__,hipGetErrorString(e));std::exit(2);} } while(0)
#define BL(x) do { auto e=(x); if(e!=CUBLAS_STATUS_SUCCESS){std::fprintf(stderr,"BLAS line%d %d\n",__LINE__,int(e));std::exit(2);} } while(0)
static unsigned seed=0x43128u;
static unsigned random_bits(){seed^=seed<<13;seed^=seed>>17;seed^=seed<<5;return seed;}
__global__ void evict(const unsigned* data,size_t n,unsigned* out){unsigned x=0;unsigned tid=blockIdx.x*blockDim.x+threadIdx.x;for(size_t i=size_t(tid)*16;i<n;i+=size_t(gridDim.x)*blockDim.x*16)x^=((const volatile unsigned*)data)[i];out[tid]=x;}
struct Owner { uint32_t* tr=nullptr;uint16_t* su=nullptr;uint16_t* sv=nullptr; };
struct Matrix { std::string name;x3::Mat m;int ldx,ldy,xoff=0,yoff=0;std::vector<uint16_t> expected_weights;std::vector<float> expected_output; };
struct Phase { const char* name;int rows,repetitions;std::vector<Owner> owners;std::vector<Matrix> mats; };
struct Counts { size_t calls=0,hits=0,decoded=0; };
static x3::Mat create(Phase& p,int k,int n,int K=6){
 Owner a;size_t bytes=x3::trellis_bytes(k,n,K);std::vector<unsigned> tr(bytes/4);for(auto&v:tr)v=random_bits();std::vector<uint16_t> su(k),sv(n);for(auto&v:su)v=(random_bits()&1)?0x3000:0xb000;for(auto&v:sv)v=(random_bits()&1)?0x3000:0xb000;
 CK(hipMalloc(&a.tr,bytes));CK(hipMalloc(&a.su,k*2));CK(hipMalloc(&a.sv,n*2));CK(hipMemcpy(a.tr,tr.data(),bytes,hipMemcpyHostToDevice));CK(hipMemcpy(a.su,su.data(),k*2,hipMemcpyHostToDevice));CK(hipMemcpy(a.sv,sv.data(),n*2,hipMemcpyHostToDevice));p.owners.push_back(a);x3::Mat m;m.trellis=a.tr;m.suh=a.su;m.svh=a.sv;m.k=k;m.n=n;m.K=K;m.cb=2;m.ld=n/16;return m;
}
int main(int argc,char**argv){
 const int gpu=argc>1?std::atoi(argv[1]):1;CK(hipSetDevice(gpu));hipDeviceProp_t prop{};CK(hipGetDeviceProperties(&prop,gpu));size_t free,total;CK(hipMemGetInfo(&free,&total));std::printf("DEVICE gpu=%d name=%s free_bytes=%zu\n",gpu,prop.name,free);std::fflush(stdout);if(free<1300ull*1024*1024)return 4;
 hipStream_t stream;hipEvent_t begin,end;CK(hipStreamCreateWithFlags(&stream,hipStreamNonBlocking));CK(hipEventCreate(&begin));CK(hipEventCreate(&end));cublasHandle_t blas;BL(cublasCreate(&blas));BL(cublasSetStream(blas,stream));
 uint16_t *scratch,*pool;CK(hipMalloc(&scratch,16*1024*1024));CK(hipMalloc(&pool,384*1024*1024));unsigned *trash,*checksum;const size_t evict_bytes=256ull*1024*1024;CK(hipMalloc(&trash,evict_bytes));CK(hipMalloc(&checksum,1024*256*4));CK(hipMemsetAsync(trash,0x37,evict_bytes,stream));
 bool all=true;
 for(int kind=0;kind<4;++kind){
  Phase p;p.name=kind==0?"attention_tp2":kind==1?"indexer":kind==2?"engram":"view_aliases";p.rows=kind==0?512:kind==1?32:kind==2?256:17;p.repetitions=kind==0?8:kind==1?128:kind==2?16:8;
  auto add=[&](std::string name,x3::Mat m,int ldx,int ldy,int xoff=0,int yoff=0){p.mats.push_back({name,m,ldx,ldy,xoff,yoff,{},{}});};
  if(kind==0){add("wq_b",create(p,1280,16384),1280,16384);for(int i=0;i<4;++i)add("wo_a"+std::to_string(i),create(p,4096,1024),16384,4096,i*4096,i*1024);add("wo_b",create(p,4096,5120),4096,5120);}
  else if(kind==1)add("i_wq_b",create(p,1280,4096),1280,4096);
  else if(kind==2)add("eg_wkv",create(p,6144,25600),6144,25600);
  else {auto m=create(p,256,512,8);add("prefix128",x3::view(m,0,128),512,512);add("prefix256",x3::view(m,0,256),512,512);add("offset128",x3::view(m,128,128),512,512);for(int cb=0;cb<3;++cb){auto v=x3::view(m,0,128);v.cb=cb;add("codebook"+std::to_string(cb),v,512,512);}auto v=x3::view(m,0,128);v.K=6;add("bits6",v,512,512);v=x3::view(m,0,128);v.ld=16;add("stride16",v,512,512);}
  int max_ldx=0,max_ldy=0;for(auto&m:p.mats){max_ldx=std::max(max_ldx,m.ldx);max_ldy=std::max(max_ldy,m.ldy);}const size_t input_n=size_t(p.rows)*max_ldx,output_n=size_t(p.rows)*max_ldy;std::vector<uint16_t> hx(input_n);for(auto&v:hx){__half h=__float2half((int(random_bits()%8193)-4096)/65536.f);std::memcpy(&v,&h,2);}uint16_t*dx;float*storage;CK(hipMalloc(&dx,input_n*2));CK(hipMalloc(&storage,(output_n+8)*4));CK(hipMemcpy(dx,hx.data(),input_n*2,hipMemcpyHostToDevice));DenseReconCache cache;
  auto matmul=[&](Matrix& a,Counts& cnt,bool capture,bool check){
   const int cols=std::max(128,int(std::min<size_t>(a.m.n,(8ull<<20)/a.m.k))/128*128);
   for(int c0=0;c0<a.m.n;c0+=cols){int nc=std::min(cols,a.m.n-c0);auto tile=nc==a.m.n?a.m:x3::view(a.m,c0,nc);auto found=cache.get(tile);uint16_t*weights=found.ptr?found.ptr:scratch;++cnt.calls;cnt.hits+=found.hit;
    if(!found.hit){x3::reconstruct_rows(tile,weights,false,stream);++cnt.decoded;}
    if(capture||check){std::vector<uint16_t> actual(size_t(a.m.k)*nc);CK(hipMemcpyAsync(actual.data(),weights,actual.size()*2,hipMemcpyDeviceToHost,stream));CK(hipStreamSynchronize(stream));if(capture)std::copy(actual.begin(),actual.end(),a.expected_weights.begin()+size_t(c0)*a.m.k);else if(!std::equal(actual.begin(),actual.end(),a.expected_weights.begin()+size_t(c0)*a.m.k)){std::fprintf(stderr,"Weight mismatch %s/%s\n",p.name,a.name.c_str());std::exit(3);}}
    const float one=1,zero=0;BL(cublasGemmEx(blas,CUBLAS_OP_T,CUBLAS_OP_N,nc,p.rows,a.m.k,&one,weights,CUDA_R_16F,a.m.k,dx+a.xoff,CUDA_R_16F,a.ldx,&zero,storage+4+a.yoff+c0,CUDA_R_32F,a.ldy,CUBLAS_COMPUTE_32F,CUBLAS_GEMM_DEFAULT_TENSOR_OP));
   }
  };
  // Save the uncached GPU reference, including every FP16 reconstructed tile.
  for(auto&a:p.mats){a.expected_weights.resize(size_t(a.m.k)*a.m.n);CK(hipMemsetAsync(storage,0xa5,(output_n+8)*4,stream));Counts cnt;matmul(a,cnt,true,false);CK(hipStreamSynchronize(stream));a.expected_output.resize(output_n+8);CK(hipMemcpy(a.expected_output.data(),storage,(output_n+8)*4,hipMemcpyDeviceToHost));}
  for(int mib:{256,320,384}){cache.data=pool;cache.capacity=size_t(mib)<<20;cache.begin_scope();Counts cnt;bool finite=true,guards=true;
   for(int rep=0;rep<3;++rep)for(auto&a:p.mats){CK(hipMemsetAsync(storage,0xa5,(output_n+8)*4,stream));matmul(a,cnt,false,true);CK(hipStreamSynchronize(stream));std::vector<float> actual(output_n+8);CK(hipMemcpy(actual.data(),storage,(output_n+8)*4,hipMemcpyDeviceToHost));if(std::memcmp(actual.data(),a.expected_output.data(),(output_n+8)*4)){std::fprintf(stderr,"GEMM/guard mismatch %s/%s capacity%d rep%d\n",p.name,a.name.c_str(),mib,rep);return 3;}for(int row=0;row<p.rows;++row)for(int col=0;col<a.m.n;++col)finite=finite&&std::isfinite(actual[4+size_t(row)*a.ldy+a.yoff+col]);for(int i=0;i<4;++i){unsigned l,u;std::memcpy(&l,&actual[i],4);std::memcpy(&u,&actual[output_n+4+i],4);guards=guards&&l==0xa5a5a5a5u&&u==0xa5a5a5a5u;}}
   all=all&&finite&&guards;std::printf("PARITY phase=%s capacity_mib=%d fp16_weights_exact=1 f32_outputs_exact=1 finite=%d guards=%d calls=%zu hits=%zu decoded=%zu\n",p.name,mib,int(finite),int(guards),cnt.calls,cnt.hits,cnt.decoded);std::fflush(stdout);
  }
  // Each timed phase starts empty; first fill and all original GEMM calls are timed.
  for(int rep=-1;rep<6;++rep)for(int j=0;j<4;++j){const int options[4]={0,256,320,384};const int mib=options[(rep&1)?3-j:j];cache.data=mib?pool:nullptr;cache.capacity=size_t(mib)<<20;evict<<<1024,256,0,stream>>>(trash,evict_bytes/4,checksum);CK(hipGetLastError());CK(hipStreamSynchronize(stream));Counts cnt;CK(hipEventRecord(begin,stream));auto start=std::chrono::steady_clock::now();cache.begin_scope();for(int unit=0;unit<p.repetitions;++unit)for(auto&a:p.mats)matmul(a,cnt,false,false);CK(hipEventRecord(end,stream));CK(hipEventSynchronize(end));float ms;CK(hipEventElapsedTime(&ms,begin,end));double wall=std::chrono::duration<double,std::milli>(std::chrono::steady_clock::now()-start).count();std::printf("TIME phase=%s rep=%d warmup=%d capacity_mib=%d gpu_ms=%.9g host_wall_ms=%.9g calls=%zu hits=%zu decoded=%zu\n",p.name,rep,int(rep<0),mib,ms,wall,cnt.calls,cnt.hits,cnt.decoded);std::fflush(stdout);}
  CK(hipFree(dx));CK(hipFree(storage));for(auto&a:p.owners){CK(hipFree(a.tr));CK(hipFree(a.su));CK(hipFree(a.sv));}
 }
 CK(hipFree(trash));CK(hipFree(checksum));CK(hipFree(pool));CK(hipFree(scratch));BL(cublasDestroy(blas));CK(hipEventDestroy(begin));CK(hipEventDestroy(end));CK(hipStreamDestroy(stream));std::printf("COMPLETE exact=%d\n",int(all));return all?0:3;
}
