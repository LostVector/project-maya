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
    const int chunk=argc>=4?std::atoi(argv[3]):2048;
    const int steps=argc==5?std::atoi(argv[4]):16;
    if(steps<1 || steps>128)return 2;
    if(chunk!=4096 && chunk!=2048 && chunk!=1024)return 2;
    for(const char* name:{"DS4_SKIP_UNPICKED","DS4_EXL3_FMA16","DS4_EXL3_PACKED_HOST","DS4_EXL3_PREDECODE","DS4_HIP_HOST_COPY_WAIT","DS4_HIP_PEER_AR","DS4_YOCO_MULTIGPU","DS4_YOCO_STATS"})setenv(name,"1",1);
    for(const char* name:{"DS4_EXL3_MATRIX_RELAXED","DS4_EXL3_MATRIX_DECODED","DS4_YOCO_KEEP","DS4_PATH_PICK"})setenv(name,"0",1);
    const char* matrix_opt=std::getenv("DS4_YOCO_TEST_MATRIX");
    const bool matrix_enabled=matrix_opt&&std::atoi(matrix_opt)!=0;
    if(matrix_enabled){setenv("DS4_EXL3_MATRIX_RELAXED","1",1);setenv("DS4_EXL3_MATRIX_DECODED","1",1);setenv("DS4_EXL3_MATRIX_ROWS","16",1);}
    const char* perf_opt=std::getenv("DS4_YOCO_TEST_PERF");
    const bool performance=perf_opt&&std::atoi(perf_opt)!=0;
    if(performance){unsetenv("DS4_FLOW_STATS");}
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
    // interpreting any new long-prompt result. References use chunk2048; chunk4096
    // saves complete logits for an explicit cross-chunk drift report, not exact acceptance.
    if(chunk==2048 || chunk==4096){
        if(!m.benchmark_prompt_skip_mode(0))return 1;
        for(const char* kind:{"code","database"}){
            const auto input=ids(root+"/baseline-"+kind+"-ids.json");m.reset();
            if(!m.feed(input.data(),int(input.size()),int(input.size()),err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
            std::vector<float> actual;if(!m.logits(actual)||actual.size()!=input.size()*size_t(m.vocab()))return 1;
            std::ifstream expected(root+"/independent-"+kind+"-reference.f32",std::ios::binary);if(!expected)return 1;
            if(chunk==4096){
                for(float v:actual)if(!std::isfinite(v))return 1;
                if(!save(root+"/cross-chunk-"+kind+"-actual.f32",actual))return 1;
                std::fprintf(stderr,"YOCO_CROSS_CHUNK kind=%s rows=%zu finite=1 saved=1 reference_chunk=2048 actual_chunk=4096\n",kind,input.size());std::fflush(stderr);
                continue;
            }
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
    for(const auto& id:cases){
        const auto input=ids(root+"/"+id+"-ids.json"),prefix=ids(root+"/"+id+"-prefix.json");
        std::vector<int> reference_tokens;std::vector<std::vector<float>> reference_logits;
        for(int trial=0;trial<3;++trial){
            const int mode=trial==1?1:0;
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
                const std::string file=root+"/"+id+"-trial"+std::to_string(trial)+"-step"+std::to_string(step)+".f32";if(!save(file,x))return 1;
                if(trial==0)reference_logits.push_back(x);
                if(trial==2&&std::memcmp(x.data(),reference_logits[size_t(step)].data(),x.size()*sizeof(float))){std::fprintf(stderr,"BASELINE_REPEAT_MISMATCH case=%s step=%d\n",id.c_str(),step);return 1;}
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
    if(performance){
        if(!matrix_enabled||cases.size()!=3||chunk!=2048)return 2;
        {std::ofstream f(root+"/preflight-ready.txt");f<<"ready\n";if(!f)return 1;}
        std::fprintf(stderr,"YOCO_PERF_GATE_READY\n");std::fflush(stderr);
        const auto until=Clock::now()+std::chrono::seconds(600);
        for(;;){
            std::ifstream f(root+"/timing-gate.txt");std::string gate;std::getline(f,gate);
            if(gate=="APPROVED")break;
            if(gate=="REJECTED"){std::fprintf(stderr,"Timing rejected by numerical/quality gate\n");return 4;}
            if(Clock::now()>until){std::fprintf(stderr,"Timing gate expired; no measured run\n");return 4;}
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
        unsetenv("DS4_YOCO_STATS"); // Actual plans recorded during preflight; no debug logging in timed samples.
        auto proc_io=[](){std::ifstream f("/proc/self/io");std::string k;long long v;std::map<std::string,long long> out;while(f>>k>>v)out[k]=v;return out;};
        auto swap_kib=[](){std::ifstream f("/proc/self/status");std::string line;while(std::getline(f,line))if(line.rfind("VmSwap:",0)==0){std::istringstream in(line.substr(7));long long n=-1;in>>n;return n;}return -1LL;};
        std::ofstream samples(root+"/performance.jsonl");samples<<std::setprecision(17);if(!samples)return 1;
        const int visits[6][2]={{0,0},{1,0},{0,1},{1,1},{0,2},{0,3}};
        const int order[2][4]={{0,1,1,0},{1,0,0,1}};
        int sample=0;
        for(const auto& visit:visits){
            const auto& id=cases[size_t(visit[0])];const int block=visit[1];const auto input=ids(root+"/"+id+"-ids.json");
            for(int pos=0;pos<4;++pos){
                const int mode=order[block%2][pos];
                if(!m.benchmark_prompt_skip_mode(mode))return 1;m.reset();
                const auto before=m.benchmark_prompt_skip_calls();const auto swap_before=swap_kib();auto io_before=proc_io();
                std::fprintf(stderr,"YOCO_PERF_BEGIN case=%s block=%d pos=%d mode=%d\n",id.c_str(),block,pos,mode);std::fflush(stderr);
                const auto start=Clock::now();
                if(!m.feed(input.data(),int(input.size()),1,err)){std::fprintf(stderr,"%s\n",err.c_str());return 1;}
                const double ms=std::chrono::duration<double,std::milli>(Clock::now()-start).count();
                auto io_after=proc_io();const auto swap_after=swap_kib();const auto plans=m.benchmark_prompt_skip_calls()-before;
                std::vector<float> x;if(!logits(x)||plans!=uint64_t(mode)||swap_before!=0||swap_after!=0||m.stats().swaps||m.stats().ram_moves)return 1;
                std::vector<float> reference(x.size());
                std::ifstream expected(root+"/"+id+"-trial"+std::to_string(mode)+"-step0.f32",std::ios::binary);
                expected.read(reinterpret_cast<char*>(reference.data()),reference.size()*sizeof(float));
                const bool stable=expected.gcount()==std::streamsize(reference.size()*sizeof(float))&&
                                  std::memcmp(x.data(),reference.data(),x.size()*sizeof(float))==0;
                if(!stable){save(root+"/unstable-"+id+"-sample"+std::to_string(sample)+".f32",x);std::fprintf(stderr,"YOCO_PERF_STABILITY_FAIL case=%s sample=%d ms=%.9f\n",id.c_str(),sample,ms);return 1;}
                samples<<"{\"case\":\""<<id<<"\",\"block\":"<<block<<",\"position\":"<<pos<<",\"sample\":"<<sample++<<",\"mode\":"<<mode<<",\"new_tokens\":"<<input.size()<<",\"chunk\":"<<chunk<<",\"matrix\":1,\"whole_chunks\":1,\"plans\":"<<plans<<",\"prefill_ms\":"<<ms<<",\"read_bytes\":"<<io_after["read_bytes:"]-io_before["read_bytes:"]<<",\"rchar\":"<<io_after["rchar:"]-io_before["rchar:"]<<",\"swap_before_kib\":"<<swap_before<<",\"swap_after_kib\":"<<swap_after<<",\"finite\":true}\n";samples.flush();if(!samples)return 1;
                std::fprintf(stderr,"YOCO_PERF_SAMPLE case=%s block=%d pos=%d mode=%d ms=%.3f\n",id.c_str(),block,pos,mode,ms);std::fflush(stderr);
            }
        }
        std::fprintf(stderr,"YOCO_PERFORMANCE_COLLECTION_COMPLETE samples=%d\n",sample);return sample==24?0:1;
    }
    std::puts("YOCO_VALIDATION_COMPLETE finite=1 baseline_repeat_exact=1 performance_not_accepted=1");return 0;
}
