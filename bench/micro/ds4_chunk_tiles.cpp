#include "ds4_model.hpp"
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
int main(int argc, char** argv) {
    if (argc != 4) return 2;
    strata::ds4::Options o;
    o.pack=argv[1]; o.gpus={0,1,2}; o.max_context=262144;
    o.reserve_mib=2048; o.tp=2; o.threads=true; o.mmap_experts=0;
    o.dspark=false; o.vision=false; o.prefill_chunk=8192;
    o.profile=std::string(argv[3])+"/frozen-profile.bin";
    std::ifstream input(argv[2]); std::string text((std::istreambuf_iterator<char>(input)),{});
    for(auto& c:text) if(c=='['||c==']'||c==',') c=' ';
    std::istringstream in(text); std::vector<int> seed; int token;
    while(in>>token) seed.push_back(token);
    if(seed.size()!=512) return 2;
    strata::ds4::Model m; std::string err;
    if(!m.load(o,err)){std::fprintf(stderr,"load: %s\n",err.c_str());return 1;}
    for(int arm=0;arm<3;++arm){
        const int step=arm==1?4096:2048;
        setenv("DS4_GEMM_TILE_2K",arm==1?"1":"0",1);
        m.reset(); std::vector<int> prompt(4096);
        for(size_t i=0;i<prompt.size();++i)prompt[i]=seed[i%seed.size()];
        const auto path=std::string(argv[3])+"/"+(arm==0?"split":arm==1?"whole":"split-repeat")+".f32";
        FILE* f=std::fopen(path.c_str(),"wb"); if(!f)return 1;
        for(int pos=0;pos<4096;pos+=step){
            if(!m.feed(prompt.data()+pos,step,step,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            std::vector<float> logits;
            if(!m.logits(logits)||logits.size()!=size_t(step)*m.vocab())return 1;
            if(std::fwrite(logits.data(),sizeof(float),logits.size(),f)!=logits.size())return 1;
        }
        std::fclose(f);std::fprintf(stderr,"COMPARE arm=%d finished\n",arm);
    }
    for(int count:{4096,8192}){
        std::vector<int> prompt(count);for(int i=0;i<count;++i)prompt[i]=seed[size_t(i)%seed.size()];
        for(int step:{2048,count,count,2048}){
            setenv("DS4_GEMM_TILE_2K",step==2048?"0":"1",1);
            m.reset();const auto t0=std::chrono::steady_clock::now();
            for(int pos=0;pos<count;pos+=step){
                const int rows=pos+step==count?1:0;
                if(!m.feed(prompt.data()+pos,step,rows,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            }
            std::vector<float> logits;if(!m.logits(logits))return 1;
            const auto ms=std::chrono::duration<double,std::milli>(std::chrono::steady_clock::now()-t0).count();
            std::fprintf(stderr,"BENCH step=%d tokens=%d ms=%.3f\n",step,count,ms);
        }
    }
}
