#include "../src/ds4/ds4_draft_cache.hpp"

#include <cstdio>
#include <cstdlib>
#include <limits>

static void require(bool ok) {
    if (!ok) { std::fputs("draft cache policy check failed\n", stderr); std::exit(1); }
}

int main() {
    using namespace strata::ds4;
    double coverage = -1;
    std::string err;
    require(draft_cache_coverage(nullptr, coverage, err) && coverage == 0);
    for (const char* value : {"0.99", "0.999", "1", "1e-2"})
        require(draft_cache_coverage(value, coverage, err) && coverage > 0 && coverage <= 1);
    for (const char* value : {"", "0", "-1", "1.01", "nan", "inf", "1e999", "1e-999", "0.99x", " 0.99", "0.99 "})
        require(!draft_cache_coverage(value, coverage, err) && coverage == 0 && !err.empty());
    const uint32_t skewed[] = {1, 90, 0, 9};
    require(draft_cache_keep(skewed, 4, .90) == 1);
    require(draft_cache_keep(skewed, 4, .99) == 2);
    require(draft_cache_keep(skewed, 4, .999) == 3);
    require(draft_cache_keep(skewed, 4, 1) == 3);
    const uint32_t unseen[] = {0, 0, 0, 0};
    require(draft_cache_keep(unseen, 4, .99) == 4);
    const uint32_t equal[] = {1, 1, 1, 1};
    require(draft_cache_keep(equal, 4, .99) == 4);
    require(draft_cache_keep(equal, 4, .5) == 2);
    const uint32_t large[] = {std::numeric_limits<uint32_t>::max(), std::numeric_limits<uint32_t>::max()};
    require(draft_cache_keep(large, 2, .99) == 2);
    std::puts("draft cache fraction, coverage boundary, unseen-block and wide-count checks passed");
}
