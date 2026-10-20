#include "ds4_model.hpp"
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
int main(int argc, char** argv) {
    if (argc != 3) return 2;
    strata::ds4::Options o;
    o.pack=argv[1]; o.gpus={0,1,2}; o.max_context=262144;
    o.reserve_mib=2048; o.tp=2; o.threads=true; o.mmap_experts=0;
    o.dspark=false; o.vision=false; o.prefill_chunk=8192;
    o.profile=std::string(argv[2])+"/frozen-profile.bin";
    setenv("DS4_CACHE_BONUS","1e30",1);
    strata::ds4::Model m; std::string err;
    if(!m.load(o,err)){std::fprintf(stderr,"load: %s\n",err.c_str());return 1;}

    struct Case { int count, prefix; const char* name; };
    for (const Case c : {Case{8192,0,"8k"},Case{2067,17,"ragged-offset"},Case{4160,1,"odd-window"},Case{10000,0,"multi-chunk"}}) {
        std::ifstream fids(std::string(argv[2])+"/"+c.name+"-ids.json");
        std::string text((std::istreambuf_iterator<char>(fids)),{});
        for(auto& ch:text)if(ch=='['||ch==']'||ch==',')ch=' ';
        std::istringstream parsed(text);std::vector<int> prompt;int tid;
        while(parsed>>tid)prompt.push_back(tid);
        if(prompt.size()!=size_t(c.count+c.prefix))return 2;
        const int windows=(c.count+2047)/2048,ref=(c.count+windows-1)/windows;
        for (int arm=0;arm<3;++arm) {
            setenv("DS4_GEMM_TILE_2K",arm==1?"1":"0",1);m.reset();
            if(c.prefix&&!m.feed(prompt.data(),c.prefix,1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            const auto path=std::string(argv[2])+"/"+c.name+"-"+std::to_string(arm)+".f32";
            FILE* out=std::fopen(path.c_str(),"wb");if(!out)return 1;
            const int per=arm==1?c.count:ref;
            for(int pos=0;pos<c.count;pos+=per){
                int nr=std::min(per,c.count-pos);
                if(!m.feed(prompt.data()+c.prefix+pos,nr,nr,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
                std::vector<float> logits;
                if(!m.logits(logits)||logits.size()!=size_t(nr)*m.vocab())return 1;
                if(std::fwrite(logits.data(),sizeof(float),logits.size(),out)!=logits.size())return 1;
            }
            std::fclose(out);std::fprintf(stderr,"COMPARE case=%s arm=%d rows=%d prefix=%d finished\n",c.name,arm,c.count,c.prefix);
        }
    }
    std::fprintf(stderr,"CACHE swaps=%lld ram_moves=%lld\n",(long long)m.stats().swaps,(long long)m.stats().ram_moves);
    if(m.stats().swaps!=0||m.stats().ram_moves!=0)return 1;
}
