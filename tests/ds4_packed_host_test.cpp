#include "../src/ds4/ds4_model.hpp"
#include <array>
#include <cmath>
#include <cstring>
#include <limits>
#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <map>
#include <fcntl.h>
#include <unistd.h>
using Clock=std::chrono::steady_clock;
static std::vector<int> ids(const std::string& path) {
    std::ifstream f(path);std::string s((std::istreambuf_iterator<char>(f)),{});
    for(auto&c:s)if(c=='['||c==']'||c==',')c=' ';
    std::istringstream in(s);std::vector<int> v;int x;while(in>>x)v.push_back(x);return v;
}
static std::map<std::string,long long> io() {
    std::ifstream f("/proc/self/io");std::string k;long long v;std::map<std::string,long long> out;while(f>>k>>v)out[k]=v;return out;
}

static bool finite_equal(const float* a, const float* b, size_t n) {
    if (std::memcmp(a, b, n * sizeof(float))) return false;
    for (size_t i = 0; i < n; ++i) if (!std::isfinite(a[i])) return false;
    return true;
}
static int check_existing(const std::string& root) {
    std::ifstream a(root+"/logits-0.f32",std::ios::binary), b(root+"/logits-1.f32",std::ios::binary), c(root+"/logits-2.f32",std::ios::binary);
    if(!a||!b||!c)return 1;
    std::array<float,16384> x,y,z;uint64_t bytes=0;
    for(;;){
        a.read((char*)x.data(),sizeof(x));b.read((char*)y.data(),sizeof(y));c.read((char*)z.data(),sizeof(z));
        const auto n=a.gcount();if(n!=b.gcount()||n!=c.gcount()||n%4)return 1;
        if(!n)break;
        if(!finite_equal(x.data(),y.data(),size_t(n)/4)||!finite_equal(x.data(),z.data(),size_t(n)/4))return 1;
        bytes+=uint64_t(n);
    }
    if(bytes!=uint64_t(2069)*129280*4)return 1;
    std::string reference;
    for(const char* name:{"primer","decode0","decode1"}){
        std::ifstream f(root+"/"+name+"-tokens.txt");if(!f)return 1;
        std::string text((std::istreambuf_iterator<char>(f)),{});
        if(std::count(text.begin(),text.end(),'\n')!=80)return 1;
        if(reference.empty())reference=text;else if(reference!=text)return 1;
    }
    std::printf("HOST_VERIFY finite=1 logits_bit_exact=1 repeat_bit_exact=1 greedy80_exact=1\n");return 0;
}
static int verifier_selftest(){
    float a[2]={0,1},b[2]={0,1};if(!finite_equal(a,b,2))return 1;
    b[1]=1.0000001f;if(finite_equal(a,b,2))return 1;
    b[1]=1;b[0]=-0.0f;if(finite_equal(a,b,2))return 1;
    a[0]=b[0]=std::numeric_limits<float>::quiet_NaN();if(finite_equal(a,b,2))return 1;
    a[0]=b[0]=std::numeric_limits<float>::infinity();if(finite_equal(a,b,2))return 1;
    std::puts("HOST_VERIFY_SELFTEST passed");return 0;
}

int main(int argc,char**argv) {
    if(argc==2 && std::string(argv[1])=="--selftest")return verifier_selftest();
    if(argc==3 && std::string(argv[1])=="--check-existing")return check_existing(argv[2]);
    setenv("DS4_EXL3_PACKED_HOST","1",1);
    setenv("DS4_EXL3_FMA16","1",1);
    setenv("DS4_SPLIT","36,4",1);
    setenv("DS4_SKIP_UNPICKED","1",1);
    if(argc!=3)return 2;const std::string root=argv[2];
    setenv("DS4_CACHE_BONUS","1e30",1);setenv("DS4_ENGRAM_THREADS","16",1);setenv("DS4_PATH_PICK","0",1);
    strata::ds4::Options o;o.pack=argv[1];o.gpus={0,1,2};o.max_context=262144;o.reserve_mib=2048;o.tp=2;o.threads=true;
    o.mmap_experts=0;o.dspark=false;o.vision=false;o.prefill_chunk=2048;o.profile=root+"/frozen-profile.bin";
    strata::ds4::Model m;std::string err;
    if(!m.load(o,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
    {std::ofstream f(root+"/allocation.txt");f<<m.describe();}
    const auto code=ids(root+"/code-ids.json"),db=ids(root+"/database-ids.json");if(code.size()!=2069||db.size()!=2048)return 2;
    auto evict=[&](){
        std::ifstream f(root+"/engram-files.txt");std::string name;int count=0;
        while(std::getline(f,name)){int fd=open(name.c_str(),O_RDONLY);if(fd<0)return false;
            int rc=posix_fadvise(fd,0,0,POSIX_FADV_DONTNEED);close(fd);if(rc)return false;++count;}
        return count==2;
    };
    std::vector<float> logits;
    auto feed=[&](const std::vector<int>& input,int rows){m.reset();if(!m.feed(input.data(),int(input.size()),rows,err)){std::fprintf(stderr,"%s\n",err.c_str());return false;}return m.logits(logits);};

    auto mode = [&](int n, bool clear) {
        setenv("DS4_EXL3_PREDECODE_TEST", n ? "1" : "0", 1);
        if (!m.benchmark_host_mode(true, clear)) std::exit(1);
    };
    mode(1, true);
    // Prime code paths; this is not a timing result.
    if(!feed(code,1)||!feed(db,1))return 1;
    int trial=0;
    for(int n:{0,1,0}) {
        mode(n,true);if(!evict()||!feed(code,int(code.size())))return 1;
        if(logits.size()!=code.size()*size_t(m.vocab()))return 1;
        const auto path=root+"/logits-"+std::to_string(trial)+".f32";FILE*f=std::fopen(path.c_str(),"wb");if(!f)return 1;
        if(std::fwrite(logits.data(),4,logits.size(),f)!=logits.size()||std::fflush(f)||fdatasync(fileno(f)))return 1;std::fclose(f);
        std::fprintf(stderr,"PARITY trial=%d predecode=%d rows=%zu finished\n",trial++,n,code.size());
    }
    for(const char* kind:{"cold-code","warm-database"}) {
        const bool cold=std::string(kind)=="cold-code";const auto&input=cold?code:db;
        if(!cold){mode(0,true);if(!feed(db,1))return 1;}
        trial=0;
        for(int n:{0,1,1,0}) {
            mode(n,cold);if(!feed(db,1))return 1;mode(n,cold);if(cold&&!evict())return 1;
            auto before=io();auto start=Clock::now();if(!feed(input,1))return 1;
            double ms=std::chrono::duration<double,std::milli>(Clock::now()-start).count();auto after=io();
            std::fprintf(stderr,"BENCH kind=%s trial=%d predecode=%d ms=%.3f read_bytes=%lld syscr=%lld\n",kind,trial++,n,ms,after["read_bytes:"]-before["read_bytes:"],after["syscr:"]-before["syscr:"]);
        }
    }
    auto generate=[&](int n,const char* label,bool timed){
        mode(n,false);if(!feed(db,1))return false;
        std::ofstream f(root+"/"+label+"-tokens.txt");Clock::time_point start;
        for(int i=0;i<80;++i){if(i==16)start=Clock::now();int y=m.sample(0,1,0,0,0,i);if(y<0)return false;f<<y<<'\n';if(!m.step(y,true,err))return false;}
        double ms=std::chrono::duration<double,std::milli>(Clock::now()-start).count();
        if(timed)std::fprintf(stderr,"DECODE predecode=%d ms=%.3f tok_s=%.3f\n",n,ms,64000/ms);return true;
    };
    if(!generate(0,"primer",false)||!generate(0,"decode0",true)||!generate(1,"decode1",true))return 1;
    std::fprintf(stderr,"CACHE swaps=%lld ram_moves=%lld\n",(long long)m.stats().swaps,(long long)m.stats().ram_moves);
    return m.stats().swaps||m.stats().ram_moves?1:check_existing(root);
}
