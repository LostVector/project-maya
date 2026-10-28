#pragma once

namespace strata::ds4 {
// Largest original balanced-chunk boundary not past cut. The prompt planner has n>0, cap>0, 0<=cut<n.
// The actual balanced width can be smaller than cap (10,000 rows at cap4096 have width3334).
inline int whole_chunk_skip_cut(int n, int cap, int cut) {
    if (n <= 0 || cap <= 0 || cut <= 0 || cut >= n) return 0;
    const int chunks = 1 + (n - 1) / cap;
    const int rows = 1 + (n - 1) / chunks;
    return cut / rows * rows;
}
}  // namespace strata::ds4
