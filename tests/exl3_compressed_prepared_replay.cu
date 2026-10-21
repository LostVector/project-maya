// Reuse deterministic weight generation and allocation helpers, not its test entry point.
#define main exl3_reference_test_main
#include "exl3_test.cu"
#undef main
#include <fstream>
#include <numeric>

static void require_replay(bool ok, const char* what) {
    if (!ok) { std::fprintf(stderr,"COMPRESSED_REPLAY_FAIL %s\n",what); std::exit(3); }
}
static uint32_t bits_replay(float x) { uint32_t b; std::memcpy(&b,&x,4); return b; }
int main(int argc,char**argv) {
#if !defined(STRATA_USE_HIP)
    return 2;
#else
    if(argc!=2)return 2;
    std::ifstream input(argv[1]);int cases=0;input>>cases;require_replay(cases==55,"fixture count");
    test_env("DS4_EXL3_FMA16","1",1);
    const bool check_only = std::getenv("EXL3_COMPRESSED_CHECK_ONLY") != nullptr;
    for(int ci=0;ci<cases;++ci){
        int id,heldout,E,F,T,K,ne;size_t recorded_stride;
        input>>id>>heldout>>E>>F>>T>>recorded_stride>>K>>ne;
        require_replay(bool(input)&&id==ci&&E>0&&F>0&&T>0&&ne>0,"fixture header");
        std::vector<int> counts(ne),bounds(1,29);int nr=0,mr=0;
        for(int&e:counts){input>>e;require_replay(bool(input)&&e>=0,"fixture count value");nr+=e;mr=std::max(mr,e);bounds.push_back(29+nr);}
        require_replay(nr>0,"nonempty fixture");
        ex::ExpertLayout lay;lay.cb=2;size_t bytes=0;
        for(int part=0;part<3;++part){int k=part<2?E:F,n=part<2?F:E;lay.trellis[part]=bytes;bytes+=ex::trellis_bytes(k,n,K);lay.suh[part]=bytes;bytes+=size_t(k)*2;lay.svh[part]=bytes;bytes+=size_t(n)*2;lay.K[part]=K;}
        require_replay(recorded_stride>=bytes,"captured blob stride fits generated layout");
        std::vector<uint8_t> blobs(size_t(ne)*recorded_stride,0x5a);
        for(int e=0;e<ne;++e)for(int part=0;part<3;++part){auto mat=make_mat(part<2?E:F,part<2?F:E,K,2);auto*dst=blobs.data()+size_t(e)*recorded_stride;std::memcpy(dst+lay.trellis[part],mat.tr.data(),mat.tr.size()*4);std::memcpy(dst+lay.suh[part],mat.suh.data(),mat.suh.size()*2);std::memcpy(dst+lay.svh[part],mat.svh.data(),mat.svh.size()*2);}
        auto*d_blob=dev_copy(blobs);auto*d_bounds=dev_copy(bounds);uint32_t*decoded=nullptr;
        ex::SetArgs a;a.wbase=d_blob;a.stride=recorded_stride;a.lay=lay;a.n_exp=ne;a.bounds=d_bounds;a.row0=29;a.max_rows=mr;a.n_embd=E;a.n_ff=F;a.limit=1.5f;
        CK(cudaMalloc(&decoded,ex::decoded_set_bytes(a)));
        for(int padded=0;padded<2;++padded){
            const int ldx=E+(padded?12:0),ldh=F+(padded?8:0),ldy=E+(padded?12:0);
            auto x=rand_x(size_t(T)*ldx);std::vector<int> idx(nr);for(int r=0;r<nr;++r)idx[r]=(r*17+ci*7)%T;
            auto*d_x=dev_copy(x);auto*d_idx=dev_copy(idx);uint16_t*h_storage=nullptr,*ws_storage=nullptr;float*y_storage=nullptr;
            const size_t hb=size_t(nr)*ldh,yb=size_t(nr)*ldy,wsb=ex::prepared_set_input_bytes(a,nr);
            CK(cudaMalloc(&h_storage,(hb+16)*2));CK(cudaMalloc(&y_storage,(yb+8)*4));CK(cudaMalloc(&ws_storage,wsb+32));
            auto*h=h_storage+8;auto*y=y_storage+4;auto*ws=ws_storage+8;
            CK(cudaMemset(h_storage,0xa5,(hb+16)*2));CK(cudaMemset(y_storage,0xa5,(yb+8)*4));CK(cudaMemset(ws_storage,0xa5,wsb+32));
            require_replay(ex::prepared_set_input_bytes(a,0)==0 && ex::prepared_set_input_bytes(a,SIZE_MAX)==0,"scratch size rejection");
            require_replay(!ex::set_gate_up_prepared(a,decoded,d_x,E-1,d_idx,h,ldh,ws,nr,0),"bad input stride rejection");
            require_replay(!ex::set_gate_up_prepared(a,decoded,d_x,ldx,d_idx,h,F-1,ws,nr,0),"bad hidden stride rejection");
            require_replay(!ex::set_down_prepared(a,decoded,h,ldh,y,E-1,ws,nr,0),"bad output stride rejection");
            require_replay(!ex::set_down_prepared(a,decoded,h,ldh,y,ldy,nullptr,nr,0),"null workspace rejection");
            if(mr>1)require_replay(!ex::set_down_prepared(a,decoded,h,ldh,y,ldy,ws,mr-1,0),"small capacity rejection");
            require_replay(!ex::set_gate_up_compressed_prepared(a,d_x,E-1,d_idx,h,ldh,ws,nr,0),"compressed bad input stride");
            require_replay(!ex::set_gate_up_compressed_prepared(a,d_x,ldx,d_idx,h,F-1,ws,nr,0),"compressed bad hidden stride");
            require_replay(!ex::set_down_compressed_prepared(a,h,ldh,y,E-1,ws,nr,0),"compressed bad output stride");
            require_replay(!ex::set_down_compressed_prepared(a,h,ldh,y,ldy,nullptr,nr,0),"compressed null workspace");
            if(mr>1)require_replay(!ex::set_down_compressed_prepared(a,h,ldh,y,ldy,ws,mr-1,0),"compressed small capacity");
            auto invalid=a;invalid.lay.K[1]=K==3?4:3;
            require_replay(!ex::set_gate_up_compressed_prepared(invalid,d_x,ldx,d_idx,h,ldh,ws,nr,0),"compressed mixed gate/up K");
            invalid=a;invalid.lay.cb=3;
            require_replay(!ex::set_down_compressed_prepared(invalid,h,ldh,y,ldy,ws,nr,0),"compressed invalid codebook");
            invalid=a;invalid.lay.K[2]=0;
            require_replay(!ex::set_down_compressed_prepared(invalid,h,ldh,y,ldy,ws,nr,0),"compressed invalid K");
            std::printf("COMPRESSED_API_REJECTION id=%d padded=%d passed=1\n",ci,padded);
            ex::set_gate_up(a,d_x,ldx,d_idx,h,ldh,0);ex::set_down(a,h,ldh,y,ldy,0);CK(cudaDeviceSynchronize());
            const auto hr=host_copy(h_storage,hb+16);const auto yr=host_copy(y_storage,yb+8);
            auto check=[&](){
                CK(cudaDeviceSynchronize());auto hc=host_copy(h_storage,hb+16);auto yc=host_copy(y_storage,yb+8);
                require_replay(hc==hr && !std::memcmp(yc.data(),yr.data(),yc.size()*4),"bit exact outputs including padding/guards");
                for(int r=0;r<nr;++r){for(int j=F;j<ldh;++j)require_replay(hc[8+size_t(r)*ldh+j]==0xa5a5,"hidden padding");for(int j=0;j<E;++j)require_replay(std::isfinite(yc[4+size_t(r)*ldy+j]),"finite output");for(int j=E;j<ldy;++j)require_replay(bits_replay(yc[4+size_t(r)*ldy+j])==0xa5a5a5a5u,"output padding");}
                for(int j=0;j<8;++j)require_replay(hc[j]==0xa5a5&&hc[8+hb+j]==0xa5a5,"hidden boundary guards");
                for(int j=0;j<4;++j)require_replay(bits_replay(yc[j])==0xa5a5a5a5u&&bits_replay(yc[4+yb+j])==0xa5a5a5a5u,"output boundary guards");
                auto wg0=host_copy(ws_storage,size_t(8));auto wg1=host_copy(ws_storage+8+wsb/2,size_t(8));for(int j=0;j<8;++j)require_replay(wg0[j]==0xa5a5&&wg1[j]==0xa5a5,"workspace guards");
            };
            require_replay(ex::decode_set(a,decoded,0),"weight decode");
            require_replay(ex::set_gate_up_decoded(a,decoded,d_x,ldx,d_idx,h,ldh,0)&&ex::set_down_decoded(a,decoded,h,ldh,y,ldy,0),"decoded baseline");check();
            require_replay(ex::set_gate_up_prepared(a,decoded,d_x,ldx,d_idx,h,ldh,ws,nr,0)&&ex::set_down_prepared(a,decoded,h,ldh,y,ldy,ws,nr,0),"prepared path");check();
            require_replay(ex::set_gate_up_compressed_prepared(a,d_x,ldx,d_idx,h,ldh,ws,nr,0)&&ex::set_down_compressed_prepared(a,h,ldh,y,ldy,ws,nr,0),"compressed prepared path");check();
            std::printf("COMPRESSED_GROUP id=%d heldout=%d K=%d E=%d F=%d T=%d ne=%d rows=%d max_rows=%d padded=%d row0=29 exact=1 guards=1 negatives=1 workspace=%zu\n",ci,heldout,K,E,F,T,ne,nr,mr,padded,wsb);std::fflush(stdout);
            if(!padded && !check_only){
                for(int trial=0;trial<8;++trial){const int order[8]={0,1,1,0,1,0,0,1};int mode=order[trial];auto run=[&](){if(mode==0){ex::set_gate_up(a,d_x,ldx,d_idx,h,ldh,0);ex::set_down(a,h,ldh,y,ldy,0);}else require_replay(ex::set_gate_up_compressed_prepared(a,d_x,ldx,d_idx,h,ldh,ws,nr,0)&&ex::set_down_compressed_prepared(a,h,ldh,y,ldy,ws,nr,0),"timed compressed prepared");};
                    cudaEvent_t begin,end;CK(cudaEventCreate(&begin));CK(cudaEventCreate(&end));run();CK(cudaEventRecord(begin));for(int j=0;j<5;++j)run();CK(cudaEventRecord(end));CK(cudaEventSynchronize(end));float calibration;CK(cudaEventElapsedTime(&calibration,begin,end));const int reps=std::min(2000,std::max(3,int(std::ceil(100/std::max(0.001,double(calibration)/5)))));for(int j=0;j<reps;++j)run();CK(cudaEventRecord(begin));for(int j=0;j<reps;++j)run();CK(cudaEventRecord(end));CK(cudaEventSynchronize(end));float ms;CK(cudaEventElapsedTime(&ms,begin,end));check();std::printf("COMPRESSED_GROUP_BENCH id=%d heldout=%d trial=%d mode=%d reps=%d mean_ms=%.9f exact=1\n",ci,heldout,trial,mode,reps,double(ms)/reps);std::fflush(stdout);CK(cudaEventDestroy(begin));CK(cudaEventDestroy(end));}
            }
            cudaFree(d_x);cudaFree(d_idx);cudaFree(h_storage);cudaFree(y_storage);cudaFree(ws_storage);
        }
        cudaFree(decoded);cudaFree(d_bounds);cudaFree(d_blob);
    }
    std::string trailing;require_replay(!(input>>trailing),"no trailing fixture data");
    std::printf("COMPRESSED_REPLAY_COMPLETE groups=55 padded_cases=110 trials=%d launch_errors=%d\n",check_only?0:440,ex::launch_errors());return ex::launch_errors()?1:0;
#endif
}
