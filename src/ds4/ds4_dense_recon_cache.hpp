#pragma once
#include <strata/kernels/exl3.hpp>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace strata::ds4 {
// Host metadata only. The model owns the backing allocation, and all users of
// a cache instance enqueue reconstruction/GEMM on one ordered device stream.
struct DenseReconCache {
    struct Entry {
        strata::kernels::exl3::Mat mat;
        size_t offset;
    };
    struct Result {
        uint16_t* ptr = nullptr;
        bool hit = false;
    };
    uint16_t* data = nullptr;
    size_t capacity = 0, used = 0;
    std::vector<Entry> entries;

    void begin_scope() { entries.clear(); used = 0; }
    static bool same(const strata::kernels::exl3::Mat& a, const strata::kernels::exl3::Mat& b) {
        return a.trellis == b.trellis && a.suh == b.suh && a.svh == b.svh &&
               a.k == b.k && a.n == b.n && a.K == b.K && a.cb == b.cb && a.ld == b.ld && a.fmt == b.fmt;
    }
    Result get(const strata::kernels::exl3::Mat& mat) {
        if (!data || mat.fmt != 0 || mat.k <= 0 || mat.n <= 0) return {};
        for (const Entry& e : entries)
            if (same(e.mat, mat)) return {data + e.offset / sizeof(uint16_t), true};
        const size_t bytes = size_t(mat.k) * size_t(mat.n) * sizeof(uint16_t);
        const size_t aligned = (bytes + 255) & ~size_t(255);
        if (used > capacity || aligned > capacity - used) return {};
        const size_t offset = used;
        entries.push_back({mat, offset});
        used += aligned;
        return {data + offset / sizeof(uint16_t), false};
    }
};
} // namespace strata::ds4
