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
int main(int argc,char** argv) {
    if(argc!=3 && argc!=4 && argc!=5)return 2;
    const std::string root=argv[2];
    setenv("DS4_HIP_ATTN_SWIZZLE","1",1);
    const int chunk=argc>=4?std::atoi(argv[3]):2048;
    const int steps=argc==5?std::atoi(argv[4]):16;
    if(steps<1 || steps>128)return 2;
    if(chunk!=4096)return 2;
    for(const char* name:{"DS4_SKIP_UNPICKED","DS4_EXL3_FMA16","DS4_EXL3_PACKED_HOST","DS4_EXL3_PREDECODE","DS4_HIP_HOST_COPY_WAIT","DS4_HIP_PEER_AR","DS4_YOCO_MULTIGPU","DS4_YOCO_STATS"})setenv(name,"1",1);
    for(const char* name:{"DS4_EXL3_MATRIX_RELAXED","DS4_EXL3_MATRIX_DECODED","DS4_YOCO_KEEP","DS4_PATH_PICK"})setenv(name,"0",1);
    const char* matrix_opt=std::getenv("DS4_YOCO_TEST_MATRIX");
    const bool matrix_enabled=matrix_opt&&std::atoi(matrix_opt)!=0;
    if(matrix_enabled){setenv("DS4_EXL3_MATRIX_RELAXED","1",1);setenv("DS4_EXL3_MATRIX_DECODED","1",1);setenv("DS4_EXL3_MATRIX_ROWS","16",1);}
    const char* perf_opt=std::getenv("DS4_YOCO_TEST_PERF");
    const bool performance=perf_opt&&std::atoi(perf_opt)!=0;
    if(performance)return 2;
    std::fprintf(stderr,"YOCO_TEST_SETTINGS matrix=%d performance=%d\n",int(matrix_enabled),int(performance));
    setenv("DS4_CACHE_BONUS","1e30",1);setenv("DS4_ENGRAM_THREADS","16",1);setenv("DS4_SPLIT","36,4",1);
    std::ifstream list(root+"/case-list.txt");if(!list)return 2;
    std::vector<std::string> cases;std::string name;while(list>>name)cases.push_back(name);if(cases.empty())return 2;
    // Validate required files before any model allocation.
    for(const auto& id:cases){if(ids(root+"/"+id+"-ids.json").empty())return 2;(void)ids(root+"/"+id+"-prefix.json");}
    strata::ds4::Options o;o.pack=argv[1];o.gpus={0,1,2};o.max_context=262144;o.reserve_mib=2048;o.tp=2;o.threads=true;
    o.mmap_experts=0;o.dspark=false;o.vision=false;o.prefill_chunk=chunk;o.profile=root+"/frozen-profile.bin";
    strata::ds4::Model m;std::string err;if(!m.load(o,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
    {std::ofstream f(root+"/allocation.txt");f<<m.describe();}
    std::fprintf(stderr,"YOCO_LOAD_READY chunk=%d\n",chunk);std::fflush(stderr);
    // With pruning off, compare independent accepted full-logit references before
    // interpreting any new long-prompt result. These references use chunk2048.
    if(chunk==2048){
        if(!m.benchmark_prompt_skip_mode(0))return 1;
        for(const char* kind:{"code","database"}){
            const auto input=ids(root+"/baseline-"+kind+"-ids.json");m.reset();
            if(!m.feed(input.data(),int(input.size()),int(input.size()),err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            std::vector<float> actual;if(!m.logits(actual)||actual.size()!=input.size()*size_t(m.vocab()))return 1;
            std::ifstream expected(root+"/independent-"+kind+"-reference.f32",std::ios::binary);if(!expected)return 1;
            std::array<float,16384> block;size_t at=0;
            while(at<actual.size()){
                const size_t n=std::min(block.size(),actual.size()-at);expected.read(reinterpret_cast<char*>(block.data()),n*sizeof(float));
                if(expected.gcount()!=std::streamsize(n*sizeof(float))||std::memcmp(block.data(),actual.data()+at,n*sizeof(float))){
                    save(root+"/failed-independent-"+kind+".f32",actual);std::fprintf(stderr,"INDEPENDENT_BASELINE_MISMATCH kind=%s offset=%zu\n",kind,at);return 1;
                }
                for(size_t i=0;i<n;++i)if(!std::isfinite(actual[at+i]))return 1;
                at+=n;
            }
            if(expected.peek()!=std::char_traits<char>::eof())return 1;
            std::fprintf(stderr,"YOCO_REFERENCE kind=%s rows=%zu finite=1 exact=1\n",kind,input.size());std::fflush(stderr);
        }
    }
    auto logits=[&](std::vector<float>& x){if(!m.logits(x)||x.size()!=size_t(m.vocab()))return false;for(float v:x)if(!std::isfinite(v))return false;return true;};
    std::vector<float> perf_reference;
    for(const auto& id:cases){
        const auto input=ids(root+"/"+id+"-ids.json"),prefix=ids(root+"/"+id+"-prefix.json");
        std::vector<int> reference_tokens;std::vector<std::vector<float>> reference_logits;
        for(int trial=0;trial<3;++trial){
            const int mode=1;
            setenv("DS4_MOE_COMBINE_MODE",trial==1?"2":"0",1);
            const char* prefix_opt=std::getenv("DS4_YOCO_TEST_PREFIX_PRUNED");
            const int prefix_mode=mode&&prefix_opt&&std::atoi(prefix_opt)!=0?1:0;
            if(!m.benchmark_prompt_skip_mode(prefix_mode))return 1;m.reset();
            if(!prefix.empty()&&!m.feed(prefix.data(),int(prefix.size()),1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            if(!m.benchmark_prompt_skip_mode(mode))return 1;
            std::fprintf(stderr,"YOCO_BEGIN case=%s trial=%d mode=%d\n",id.c_str(),trial,mode);std::fflush(stderr);
            const auto before=m.benchmark_prompt_skip_calls();const auto start=Clock::now();
            if(!m.feed(input.data(),int(input.size()),1,err)){std::fprintf(stderr,"case=%s trial=%d %s\n",id.c_str(),trial,err.c_str());return 1;}
            const double ms=std::chrono::duration<double,std::milli>(Clock::now()-start).count();
            const auto plans=m.benchmark_prompt_skip_calls()-before;
            int expected_skip=input.size()>=3692?int(input.size())-2668:0;
            const char* whole=std::getenv("DS4_YOCO_WHOLE_CHUNKS");
            if(expected_skip>0&&whole&&std::atoi(whole)!=0){
                const int nc=(int(input.size())+chunk-1)/chunk,per=(int(input.size())+nc-1)/nc;
                expected_skip=(expected_skip/per)*per;
            }
            const bool eligible=mode==1&&expected_skip>0;
            if(plans!=uint64_t(eligible)){std::fprintf(stderr,"skip-plan counter mismatch case=%s expected=%d got=%llu\n",id.c_str(),int(eligible),(unsigned long long)plans);return 1;}
            std::vector<int> trial_decisions;
            std::ofstream decisions(root+"/"+id+"-trial"+std::to_string(trial)+"-argmax.txt");
            for(int step=0;step<=steps;++step){
                std::vector<float> x;if(!logits(x))return 1;
                if(id=="study_32k"&&trial==0&&step==0)perf_reference=x;
                const std::string file=root+"/"+id+"-trial"+std::to_string(trial)+"-step"+std::to_string(step)+".f32";if(!save(file,x))return 1;
                if(trial==0)reference_logits.push_back(x);
                if(trial>0&&std::memcmp(x.data(),reference_logits[size_t(step)].data(),x.size()*sizeof(float))){std::fprintf(stderr,"ATTENTION_PARITY_MISMATCH case=%s step=%d\n",id.c_str(),step);return 1;}
                const int token=int(std::max_element(x.begin(),x.end())-x.begin());decisions<<token<<'\n';trial_decisions.push_back(token);
                if(step==steps)break;
                if(trial==0)reference_tokens.push_back(token);
                // Score identical continuation tokens; divergent decisions are preserved in files.
                if(!m.step(reference_tokens[size_t(step)],true,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            }
            if(!decisions)return 1;
            const auto eos=std::find(reference_tokens.begin(),reference_tokens.end(),1);
            const size_t stop=std::min(size_t(steps),size_t(eos-reference_tokens.begin())+(eos!=reference_tokens.end()));
            bool same=true;
            for(size_t i=0;i<stop;++i)same=same&&trial_decisions[i]==reference_tokens[i];
            std::vector<int> free_tokens;std::string free_source;
            const char* force_free=std::getenv("DS4_YOCO_TEST_FORCE_FREE");
            if(trial!=1 || (same && !(force_free && std::atoi(force_free)!=0))){
                free_tokens.assign(trial_decisions.begin(),trial_decisions.begin()+stop);
                free_source=trial==1?"matching_decisions_through_EOS":"baseline_greedy_path";
            } else {
                // Divergent teacher-forced decisions do not establish the candidate's
                // free response. Rebuild its own state and generate independently.
                std::fprintf(stderr,"YOCO_FREE_BEGIN case=%s trial=%d\n",id.c_str(),trial);std::fflush(stderr);
                if(!m.benchmark_prompt_skip_mode(prefix_mode))return 1;m.reset();
                if(!prefix.empty()&&!m.feed(prefix.data(),int(prefix.size()),1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
                if(!m.benchmark_prompt_skip_mode(mode)||!m.feed(input.data(),int(input.size()),1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
                for(int i=0;i<steps;++i){
                    std::vector<float> x;if(!logits(x))return 1;
                    const int token=int(std::max_element(x.begin(),x.end())-x.begin());free_tokens.push_back(token);
                    if(token==1)break;
                    if(!m.step(token,true,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
                }
                free_source="independent_free_generation";
            }
            std::ofstream free_file(root+"/"+id+"-trial"+std::to_string(trial)+"-free-tokens.txt");
            for(int token:free_tokens)free_file<<token<<'\n';if(!free_file)return 1;
            std::ofstream source_file(root+"/"+id+"-trial"+std::to_string(trial)+"-free-source.txt");source_file<<free_source<<'\n';if(!source_file)return 1;
            std::fprintf(stderr,"YOCO_CASE case=%s chunk=%d trial=%d mode=%d new_tokens=%zu prefix_tokens=%zu plans=%llu prefill_ms=%.3f teacher_forced_steps=%d finite=1 baseline_repeat_checked=%d\n",id.c_str(),chunk,trial,mode,input.size(),prefix.size(),(unsigned long long)plans,ms,steps,int(trial==2));std::fflush(stderr);
            if(m.stats().swaps||m.stats().ram_moves)return 1;
        }
    }
    const char* perf_flag=std::getenv("DS4_COMBINE_TEST_PERF");
    if(perf_flag&&std::atoi(perf_flag)==1){
        if(steps!=64||perf_reference.empty())return 2;
        std::fprintf(stderr,"COMBINE_PREFLIGHT_READY\n");std::fflush(stderr);
        const auto deadline=Clock::now()+std::chrono::seconds(600);
        for(;;){
            std::ifstream f(root+"/timing-gate.txt");std::string gate;std::getline(f,gate);
            if(gate=="APPROVED")break;
            if(gate=="REJECTED"||Clock::now()>deadline)return 4;
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
        const auto input=ids(root+"/study_32k-ids.json");
        std::ofstream samples(root+"/native-timing.csv");samples<<"rep,warmup,mode,feed_ms,exact\n";
        for(int rep=-1;rep<4;++rep)for(int j=0;j<2;++j){
            const int mode=rep>=0&&(rep&1)?(j==0?2:0):(j==0?0:2);
            setenv("DS4_MOE_COMBINE_MODE",mode==2?"2":"0",1);
            if(!m.benchmark_prompt_skip_mode(1))return 1;m.reset();
            std::fprintf(stderr,"COMBINE_PERF_BEGIN rep=%d mode=%d\n",rep,mode);std::fflush(stderr);
            const auto start=Clock::now();
            if(!m.feed(input.data(),int(input.size()),1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            const double ms=std::chrono::duration<double,std::milli>(Clock::now()-start).count();
            std::vector<float> x;if(!logits(x)||std::memcmp(x.data(),perf_reference.data(),x.size()*sizeof(float)))return 1;
            if(m.stats().swaps||m.stats().ram_moves)return 1;
            samples<<rep<<','<<int(rep<0)<<','<<mode<<','<<std::setprecision(12)<<ms<<",1\n";samples.flush();
            std::fprintf(stderr,"COMBINE_PERF_END rep=%d mode=%d ms=%.9f exact=1\n",rep,mode,ms);std::fflush(stderr);
        }
        if(!samples)return 1;
        std::fprintf(stderr,"COMBINE_PERF_COMPLETE samples=10\n");std::fflush(stderr);
    }
    std::puts("COMBINE_VALIDATION_COMPLETE finite=1 candidate_and_repeat_exact=1");return 0;
}
