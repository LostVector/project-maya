#include "../src/ds4/ds4_math_windows.hpp"
#include <cstdio>
#include <stdexcept>
#include <tuple>
#include <vector>
using Range = std::pair<int64_t,int64_t>;
static void require(bool condition) { if (!condition) throw std::runtime_error("window schedule mismatch"); }
int main() {
    size_t cases=0;
    for (int n : {1,17,511,1034,2048,2067,4096,4160,8192,10000,16385,262143})
    for (int cap : {1024,2048,4096,8192,32768})
    for (int64_t p0 : {0,1,17,2049}) {
        const int limit=std::min(cap,2048), count=(n+limit-1)/limit;
        const int ref=(n+count-1)/count;
        require(strata::ds4::reference_math_rows(n,cap)==ref);
        const int packed=ref*std::max(1,cap/ref);
        require(packed<=cap);
        for (int divisor : {1,2,3,7,64}) {
            std::vector<Range> expected,actual;
            for(int a=0;a<n;a+=ref) {
                int64_t first=(p0+a)/divisor,last=(p0+std::min(n,a+ref))/divisor;
                if(last>first)expected.emplace_back(first,last);
            }
            for(int a=0;a<n;a+=packed) {
                const int T=std::min(packed,n-a);
                require((T+ref-1)/ref <= 2*((cap+2047)/2048));
                strata::ds4::MathWindows math{ref,p0+a};
                int64_t first=(p0+a)/divisor;
                int total=int((p0+a+T)/divisor-first);
                for(int row=0;row<total;) {
                    int end=math.end(row,total,divisor);
                    require(end>row&&end<=total);
                    actual.emplace_back(first+row,first+end);row=end;
                }
            }
            require(expected==actual);++cases;
        }
        for(int slab : {32,64,256,512}) {
            std::vector<Range> expected,actual;
            for(int a=0;a<n;a+=ref)
                for(int b=a;b<std::min(n,a+ref);b+=slab)
                    expected.emplace_back(p0+b,p0+std::min(std::min(n,a+ref),b+slab));
            for(int a=0;a<n;a+=packed) {
                int T=std::min(packed,n-a);strata::ds4::MathWindows math{ref,p0+a};
                for(int row=0;row<T;) {
                    int nr=math.slab(row,T,slab);require(nr>0&&nr<=slab&&row+nr<=T);
                    actual.emplace_back(p0+a+row,p0+a+row+nr);row+=nr;
                }
            }
            require(expected==actual);++cases;
        }
    }
    strata::ds4::MathWindows off;
    require(off.end(3,17,2)==17&&off.slab(3,17,8)==8);
    std::printf("%zu scheduling cases passed\n",cases);
}
