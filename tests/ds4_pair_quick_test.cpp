#include "../src/ds4/ds4_model.hpp"
#include <algorithm>
#include <array>
#include <map>
#include <thread>
#include <iomanip>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>
using Clock=std::chrono::steady_clock;
static std::vector<int> ids(const std::string& path) {
    std::ifstream f(path);if(!f)throw std::runtime_error("missing token input: "+path);
    std::string s((std::istreambuf_iterator<char>(f)),{});
    for(char& c:s)if(c=='['||c==']'||c==',')c=' ';
    std::istringstream in(s);std::vector<int> out;int x;while(in>>x)out.push_back(x);return out;
}
static bool save(const std::string& path,const std::vector<float>& x) {
    std::ofstream f(path,std::ios::binary);f.write(reinterpret_cast<const char*>(x.data()),x.size()*sizeof(float));return bool(f);
}
int main(int argc,char**argv) {
 if(argc!=3)return 2;const std::string root=argv[2];
 for(const char* n:{"DS4_SKIP_UNPICKED","DS4_EXL3_FMA16","DS4_EXL3_PACKED_HOST","DS4_EXL3_PREDECODE","DS4_HIP_HOST_COPY_WAIT","DS4_HIP_PEER_AR","DS4_YOCO_MULTIGPU","DS4_YOCO_STATS","DS4_EXL3_MATRIX_RELAXED","DS4_EXL3_MATRIX_DECODED","DS4_HIP_ATTN_SWIZZLE","DS4_YOCO_WHOLE_CHUNKS","DS4_TEST_FIXED_LAYER_SLOTS"})setenv(n,"1",1);
 setenv("DS4_MOE_COMBINE_MODE","3",1);setenv("DS4_EXL3_MATRIX_ROWS","16",1);setenv("DS4_CACHE_BONUS","1e30",1);setenv("DS4_ENGRAM_THREADS","16",1);setenv("DS4_SPLIT","36,4",1);setenv("DS4_PATH_PICK","0",1);
 auto input=ids(root+"/study_32k-ids.json");if(input.size()!=32768)return 2;
 strata::ds4::Options o;o.pack=argv[1];o.gpus={0,1,2};o.max_context=262144;o.reserve_mib=2048;o.tp=2;o.threads=true;o.mmap_experts=0;o.dspark=false;o.vision=false;o.prefill_chunk=4096;o.profile=root+"/frozen-profile.bin";
 strata::ds4::Model m;std::string err;if(!m.load(o,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
 {std::ofstream f(root+"/allocation.txt");f<<m.describe();}
 std::fprintf(stderr,"YOCO_LOAD_READY chunk=4096\n");std::fflush(stderr);
 std::ifstream ref(root+"/independent-reference.f32",std::ios::binary);std::vector<float> expected(129280);ref.read(reinterpret_cast<char*>(expected.data()),expected.size()*4);if(ref.gcount()!=std::streamsize(expected.size()*4)||ref.peek()!=std::char_traits<char>::eof())return 2;
 std::ofstream csv(root+"/quick-timing.csv");csv<<"index,warmup,enabled,prefill_ms,exact\n";
 const int modes[]={0,1,0,1,1,0};
 for(int i=0;i<6;++i){
  setenv("DS4_LAYER_PAIR",modes[i]?"1":"0",1);m.reset();if(!m.benchmark_prompt_skip_mode(1))return 1;
  std::fprintf(stderr,"SPEC_BEGIN index=%d enabled=%d warmup=%d\n",i,modes[i],int(i<2));std::fflush(stderr);
  const auto start=Clock::now();if(!m.feed(input.data(),int(input.size()),1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
  const double ms=std::chrono::duration<double,std::milli>(Clock::now()-start).count();std::vector<float> x;if(!m.logits(x)||x.size()!=expected.size())return 1;
  for(float v:x)if(!std::isfinite(v))return 1;
  if(std::memcmp(x.data(),expected.data(),x.size()*4)){save(root+"/failed.f32",x);std::fprintf(stderr,"SPEC_PARITY_FAILURE index=%d\n",i);return 1;}
  if(m.stats().swaps||m.stats().ram_moves)return 1;
  csv<<i<<','<<int(i<2)<<','<<modes[i]<<','<<std::setprecision(12)<<ms<<",1\n";csv.flush();
  std::fprintf(stderr,"SPEC_END index=%d ms=%.9f exact=1\n",i,ms);std::fflush(stderr);
 }
 std::puts("SPEC_QUICK_COMPLETE exact=1 samples=4 warmups=2");return 0;
}
