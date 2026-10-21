#include "../src/ds4/ds4_prefetch_history.hpp"
#include <cassert>
#include <array>
int main() {
    strata::ds4::PrefetchHistory h;
    assert(h.predict(2, 0, 0, 4).empty());
    h.remember(2, 0, {0, 1, 1, 2, 2});
    assert(h.predict(2, 0, 0, 4).empty()); // same-chunk information is not a prediction
    assert(h.predict(2, 2, 0, 4).empty()); // stale chunk
    assert(h.predict(1, 1, 0, 4).empty()); // another layer
    assert(h.predict(2, 1, 1, 4).empty()); // invalid virtual-slot range
    auto pred=h.predict(2, 1, 0, 4);
    assert((pred==std::vector<uint8_t>{1,0,1,0}));
    // A false positive may be copied, but every false negative must be repaired.
    const std::array<int,4> weights={11,22,33,44};
    const std::array<bool,4> actual={false,true,true,false};
    std::array<int,4> ring={-1,-1,-1,-1};
    int used=0,wasted=0,repaired=0;
    for(int i=0;i<4;++i)if(pred[i])ring[i]=weights[i];
    assert(ring[1]!=weights[1]); // skipping repairs would consume stale data
    for(int i=0;i<4;++i){
        if(pred[i]){if(actual[i])++used;else ++wasted;}
        else if(actual[i]){ring[i]=weights[i];++repaired;}
    }
    for(int i=0;i<4;++i)if(actual[i])assert(ring[i]==weights[i]);
    assert(used==1 && wasted==1 && repaired==1);
    h.remember(2, 1, {0,0,0,0,0});
    assert((h.predict(2,2,0,4)==std::vector<uint8_t>{0,0,0,0}));
}
