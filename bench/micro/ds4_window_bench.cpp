#include "ds4_model.hpp"
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>
#include <unistd.h>
using Clock=std::chrono::steady_clock;
static std::vector<int> read_ids(const std::string& path) {
    std::ifstream f(path);std::string s((std::istreambuf_iterator<char>(f)),{});
    for(auto& c:s)if(c=='['||c==']'||c==',')c=' ';
    std::istringstream in(s);std::vector<int> out;int t;while(in>>t)out.push_back(t);return out;
}
int main(int argc,char** argv) {
    if(argc!=4)return 2;
    const std::string root=argv[2];const int cap=std::atoi(argv[3]);
    if(cap!=2048&&cap!=8192)return 2;
    setenv("DS4_CACHE_BONUS","1e30",1);setenv("DS4_PATH_PICK","0",1);
    strata::ds4::Options o;o.pack=argv[1];o.gpus={0,1,2};o.max_context=262144;o.reserve_mib=2048;
    o.tp=2;o.threads=true;o.mmap_experts=0;o.dspark=false;o.vision=false;o.prefill_chunk=cap;
    o.profile=root+"/"+std::to_string(cap)+"/frozen-profile.bin";
    strata::ds4::Model m;std::string err;
    if(!m.load(o,err)){std::fprintf(stderr,"load: %s\n",err.c_str());return 1;}
    {std::ofstream f(root+"/"+std::to_string(cap)+"/allocation.txt");f<<m.describe();}
    auto db=read_ids(root+"/8k-ids.json");auto code=read_ids(root+"/ragged-offset-ids.json");
    if(db.size()!=8192||code.size()!=2084)return 2;
    auto feed=[&](int count,int mode,int rows,std::vector<float>& logits)->bool {
        setenv("DS4_GEMM_TILE_2K",mode?"1":"0",1);m.reset();
        const int nwin=(count+2047)/2048,step=(cap==8192&&mode==0)?(count+nwin-1)/nwin:count;
        const auto& ids=count==2067?code:db;
        for(int p=0;p<count;p+=step){int nr=std::min(step,count-p);
            if(!m.feed(ids.data()+p,nr,p+nr==count?rows:0,err)){std::fprintf(stderr,"%s\n",err.c_str());return false;}}
        return m.logits(logits);
    };
    // Capture endpoints and warm all paths before timing. Flush raw output first.
    std::vector<float> logits;
    for(int mode=0;mode<(cap==8192?2:1);++mode) {
        for(int count:{8192,2067,1024}) {
            if(!feed(count,mode,16,logits)||logits.size()!=size_t(16)*m.vocab())return 1;
            auto path=root+"/"+std::to_string(cap)+"/endpoint-"+std::to_string(count)+"-"+std::to_string(mode)+".f32";
            FILE* f=std::fopen(path.c_str(),"wb");if(!f)return 1;
            if(std::fwrite(logits.data(),4,logits.size(),f)!=logits.size())return 1;
            if(std::fflush(f)||fdatasync(fileno(f)))return 1;std::fclose(f);
            if(count==8192) {
                std::ofstream tokens(root+"/"+std::to_string(cap)+"/greedy-"+std::to_string(mode)+".txt");
                for(int i=0;i<16;++i){int y=m.sample(0,1,0,0,0,i);if(y<0)return 1;tokens<<y<<'\n';
                    if(!m.step(y,true,err))return 1;}
                auto before=m.stats();const auto t0=Clock::now();
                for(int i=16;i<80;++i){int y=m.sample(0,1,0,0,0,i);if(y<0)return 1;tokens<<y<<'\n';
                    if(!m.step(y,true,err))return 1;}
                double ms=std::chrono::duration<double,std::milli>(Clock::now()-t0).count();auto after=m.stats();
                std::fprintf(stderr,"DECODE cap=%d mode=%d count=64 ms=%.3f tok_s=%.3f experts=%lld cpu_experts=%lld\n",cap,mode,ms,64000/ms,(long long)(after.experts-before.experts),(long long)(after.cpu_experts-before.cpu_experts));
            }
        }
    }
    for(int count:{8192,1024})for(int arm:{0,1,1,0}){
        const int mode=cap==8192?arm:0;const auto t0=Clock::now();
        if(!feed(count,mode,1,logits))return 1;
        double ms=std::chrono::duration<double,std::milli>(Clock::now()-t0).count();
        std::fprintf(stderr,"BENCH cap=%d count=%d mode=%d ms=%.3f\n",cap,count,mode,ms);
    }
    if(m.stats().swaps||m.stats().ram_moves)return 1;
    std::fprintf(stderr,"CACHE swaps=0 ram_moves=0\n");
}
