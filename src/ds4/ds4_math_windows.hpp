#pragma once
#include <algorithm>
#include <cstdint>

namespace strata::ds4 {
// Preserve the original balanced <=2K math windows, coalescing them only for expert streaming.
inline int reference_math_rows(int n, int capacity) {
    const int limit = std::min(2048, capacity);
    const int count = (n + limit - 1) / limit;
    return (n + count - 1) / count;
}
struct MathWindows {
    int rows = 0; // zero: original unrestricted math
    int64_t p0 = 0;
    int end(int row, int total, int divisor = 1) const {
        if (rows <= 0) return total;
        const int64_t first = p0 / divisor;
        int64_t window = 1;
        int64_t next = (p0 + window * rows) / divisor - first;
        while (next <= row) next = (p0 + ++window * rows) / divisor - first;
        return (int) std::min<int64_t>(total, next);
    }
    int slab(int row, int total, int limit) const {
        return std::min(limit, end(row, total) - row);
    }
};
} // namespace strata::ds4
