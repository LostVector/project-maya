#include "../src/ds4/ds4_prefill_stats.hpp"
#include <cstdio>

int main() {
    strata::ds4::PrefillCounts c;
    // A hot resident expert serves 100 rows; one nonresident expert serves one.
    // The row hit rate must be 100/101, while unique-use hit rate is 1/2.
    const int a[] = {0, 100, 100, 101};
    if (!c.add_bounds(a, 3, 2) || c.picks != 101 || c.vram_picks != 100 ||
        c.unique_uses != 2 || c.vram_unique_uses != 1) return 1;
    // A second chunk reuses a fetched expert: count it again, not as a global
    // distinct expert. Prefix offsets need not start at zero.
    const int b[] = {7, 7, 7, 12};
    if (!c.add_bounds(b, 3, 2) || c.picks != 106 || c.vram_picks != 100 ||
        c.unique_uses != 3 || c.vram_unique_uses != 1) return 1;
    const int invalid[] = {0, 5, 4};
    if (c.add_bounds(invalid, 2, 1) || c.add_bounds(a, 3, 4) ||
        c.picks != 106 || c.unique_uses != 3) return 1;
    std::puts("prefill row-hit, repeated-use, empty-slot and invalid-bound semantics passed");
}
