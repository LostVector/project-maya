// Compare rounded cuts with independently enumerated original prompt chunks; no GPU/model required.
#include "../src/ds4/ds4_prompt_skip.hpp"
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <climits>
#include <vector>
using strata::ds4::whole_chunk_skip_cut;
void check(bool ok) { if (!ok) { std::fputs("prompt skip invariant failed\n", stderr); std::exit(1); } }
int main() {
    check(whole_chunk_skip_cut(8192,4096,5524)==4096);
    check(whole_chunk_skip_cut(32768,4096,30100)==28672);
    check(whole_chunk_skip_cut(10000,4096,7332)==6668);  // Balanced width3334, not cap4096.
    check(whole_chunk_skip_cut(8192,4096,1000)==0);     // No complete chunk can be pruned.
    check(whole_chunk_skip_cut(0,4096,0)==0);
    check(whole_chunk_skip_cut(8192,0,1)==0);
    check(whole_chunk_skip_cut(8192,4096,8192)==0);
    check(whole_chunk_skip_cut(INT_MAX,INT_MAX,INT_MAX-1)==0);
    size_t cases=0;
    const int caps[]={1,127,128,511,1000,1024,1536,2048,3000,4096,6144,8192,32768};
    for (int cap:caps)
        for (int n=1;n<=40000;n+=37) {
            // Find the number of chunks without the helper's division formula, then enumerate the no-skip schedule.
            int count=1;
            while ((long long)count*cap<n) ++count;
            int width=n/count+(n%count!=0);
            std::vector<int> boundary;
            for (int x=0;x<n;x+=width) boundary.push_back(x);
            for (int keep:{1,127,128,2668,4096,8192}) {
                const int cut=std::max(0,n-keep);
                int expected=0;
                for (int x:boundary) if (x<=cut) expected=x;
                const int got=whole_chunk_skip_cut(n,cap,cut);
                check(got==expected && got<=cut && n-got>=std::min(n,keep));
                check(cut-got<width);
                // The resulting cut names an original chunk, with no partial rows; all retained shapes stay original.
                check(std::find(boundary.begin(),boundary.end(),got)!=boundary.end());
                ++cases;
            }
        }
    std::printf("PASS: %zu balanced-schedule/retained-suffix cases and explicit edge cases\n",cases);
}
