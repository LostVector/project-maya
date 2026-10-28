// Sparse sorted-row dispatch against today's token-grid/early-exit combine, including null-row fallback.
#include "../src/ds4/ds4_kernels.cuh"
#include <hip/hip_runtime.h>
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <numeric>
#include <vector>
using namespace strata::ds4;
#define CK(x) do { auto e = (x); if (e != hipSuccess) { \
    std::fprintf(stderr, "line%d: %s\n", __LINE__, hipGetErrorString(e)); return 2; } } while (0)
unsigned rng = 0x45b117u;
unsigned next() { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }
float value() { return (int(next() % 65537) - 32768) / 32768.f; }
unsigned bits(float x) { unsigned u; std::memcpy(&u, &x, 4); return u; }
__global__ void evict(const unsigned* data, size_t n, unsigned* out) {
    unsigned x = 0;
    const unsigned tid = blockIdx.x * blockDim.x + threadIdx.x;
    for (size_t i = size_t(tid) * 16; i < n; i += size_t(gridDim.x) * blockDim.x * 16)
        x ^= ((const volatile unsigned*) data)[i];
    out[tid] = x;
}
void set_policy(bool enabled) {
#if defined(_WIN32)
    _putenv_s("STRATA_DS4_SPARSE_COMBINE", enabled ? "1" : "0");
#else
    setenv("STRATA_DS4_SPARSE_COMBINE", enabled ? "1" : "0", 1);
#endif
}
struct Case { const char* name; int T, D, k, pct, hits; bool empty = false; };
int main(int argc, char** argv) {
    const bool parity_only = argc > 1 && std::strcmp(argv[1], "--parity-only") == 0;
    size_t free = 0, total = 0;
    CK(hipMemGetInfo(&free, &total));
    if (free < 1100ull * 1024 * 1024) { std::puts("SKIP: need 1100 MiB spare VRAM"); return 77; }
    hipStream_t stream{};
    hipEvent_t begin{}, end{};
    CK(hipStreamCreateWithFlags(&stream, hipStreamNonBlocking));
    CK(hipEventCreate(&begin)); CK(hipEventCreate(&end));
    unsigned *trash = nullptr, *checksum = nullptr;
    constexpr size_t evict_bytes = 256ull << 20;
    if (!parity_only) {
        CK(hipMalloc(&trash, evict_bytes)); CK(hipMalloc(&checksum, 1024 * 256 * 4));
        CK(hipMemsetAsync(trash, 0x37, evict_bytes, stream));
    }
    const Case cases[] = {
        {"sparse1",4096,5120,6,1,1}, {"sparse10",4096,5120,6,10,1},
        {"half",4096,5120,6,50,1}, {"full1",4096,5120,6,100,1},
        {"sparse10x3",4096,5120,6,10,3}, {"sparse1x6",4096,5120,6,1,6},
        {"dense6",4096,5120,6,100,6}, {"no_hits",4096,5120,6,0,1},
        {"ragged",73,519,6,37,3}, {"ragged_one",73,519,6,37,1},
        {"ragged_six",73,519,6,7,6}, {"k3",31,513,3,20,2},
        {"k1",73,519,1,37,1}, {"k8",73,519,8,7,8},
        {"dense8",73,519,8,100,8}, {"empty",17,257,6,100,1,true}
    };
    bool all = true;
    for (const auto& c : cases) {
        rng = 0x45b117u + c.T + c.pct;
        const size_t N = size_t(c.T) * c.D;
        const int active = (c.T * c.pct + 99) / 100, nr = active * c.hits;
        const int r0 = 13, r1 = c.empty ? r0 : r0 + std::max(1, nr);
        std::vector<int> tokens(c.T), pos(size_t(c.T) * kPicks, -1);
        std::iota(tokens.begin(), tokens.end(), 0);
        for (int i = c.T - 1; i > 0; --i) std::swap(tokens[i], tokens[next() % unsigned(i + 1)]);
        std::vector<bool> chosen(c.T);
        for (int i = 0; i < active; ++i) chosen[tokens[i]] = true;
        std::vector<float> input(N), y(size_t(std::max(1,nr)) * c.D), w(size_t(c.T) * kPicks);
        std::vector<float> reference(N), actual(N + 8);
        for (size_t i = 0; i < N; ++i) input[i] = i % 257 == 0 ? (i & 1 ? -0.f : 0.f) : value() * .125f;
        for (auto& v : y) v = value() * .25f;
        for (size_t i = 0; i < w.size(); ++i) w[i] = i % 23 == 0 ? 0.f : value();
        int mi = 0, oi = 0;
        for (int t = 0; t < c.T; ++t)
            for (int i = 0; i < c.k; ++i) {
                const bool hit = chosen[t] && ((i - t % c.k + c.k) % c.k) < c.hits;
                pos[size_t(t) * kPicks + i] = hit ? r0 + mi++ : r0 + std::max(1,nr) + oi++;
            }
        if (mi != nr) return 5;
        // Ownership must follow original pick order, not the lowest row number.
        std::vector<int> permutation(std::max(1,nr));
        std::iota(permutation.begin(), permutation.end(), 0);
        for (int i = nr - 1; i > 0; --i) std::swap(permutation[i], permutation[next() % unsigned(i + 1)]);
        for (auto& v : pos) if (v >= r0 && v < r1) v = r0 + permutation[v - r0];
        std::vector<int> rowtok(size_t(r1) + 4, 0);
        for (int t = 0; t < c.T; ++t)
            for (int i = 0; i < c.k; ++i) {
                const int r = pos[size_t(t) * kPicks + i];
                if (r >= r0 && r < r1) rowtok[r] = t;
            }
        float *dy = nullptr, *dw = nullptr, *storage = nullptr;
        int *dp = nullptr, *drt = nullptr;
        CK(hipMalloc(&drt, rowtok.size() * 4)); CK(hipMalloc(&dy, y.size() * 4));
        CK(hipMalloc(&dw, w.size() * 4)); CK(hipMalloc(&storage, (N + 8) * 4));
        CK(hipMalloc(&dp, pos.size() * 4));
        CK(hipMemcpy(drt, rowtok.data(), rowtok.size() * 4, hipMemcpyHostToDevice));
        CK(hipMemcpy(dy, y.data(), y.size() * 4, hipMemcpyHostToDevice));
        CK(hipMemcpy(dw, w.data(), w.size() * 4, hipMemcpyHostToDevice));
        CK(hipMemcpy(dp, pos.data(), pos.size() * 4, hipMemcpyHostToDevice));
        float* out = storage + 4;
        auto run = [&](int mode) {
            set_policy(mode != 0);
            moe_combine(out, dy, dp, dw, c.T, c.k, r0, r1, c.D, stream, mode == 2 ? nullptr : drt);
        };
        for (int mode : {0,1,2}) {
            CK(hipMemsetAsync(storage, 0xa5, (N + 8) * 4, stream));
            CK(hipMemcpyAsync(out, input.data(), N * 4, hipMemcpyHostToDevice, stream));
            run(mode); CK(hipGetLastError()); CK(hipStreamSynchronize(stream));
            CK(hipMemcpy(actual.data(), storage, (N + 8) * 4, hipMemcpyDeviceToHost));
            if (mode == 0) std::copy(actual.begin() + 4, actual.begin() + 4 + N, reference.begin());
            size_t mismatch = 0, cpu_mismatch = 0;
            bool finite = true, guards = true;
            for (size_t i = 0; i < N; ++i) {
                mismatch += bits(actual[i + 4]) != bits(reference[i]);
                finite = finite && std::isfinite(actual[i + 4]);
                if (c.T < 100) {
                    const int t = i / c.D, e = i % c.D;
                    float v = input[i];
                    for (int j = 0; j < c.k; ++j) {
                        const int row = pos[size_t(t) * kPicks + j];
                        if (row >= r0 && row < r1)
                            v = std::fma(w[size_t(t) * kPicks + j], y[size_t(row-r0) * c.D + e], v);
                    }
                    cpu_mismatch += bits(v) != bits(actual[i + 4]);
                }
            }
            for (int i = 0; i < 4; ++i)
                guards = guards && bits(actual[i]) == 0xa5a5a5a5u && bits(actual[N + 4 + i]) == 0xa5a5a5a5u;
            all = all && !mismatch && !cpu_mismatch && finite && guards;
            std::printf("PARITY case=%s mode=%d mismatch=%zu cpu_mismatch=%zu finite=%d guards=%d\n",
                        c.name, mode, mismatch, cpu_mismatch, int(finite), int(guards));
        }
        if (!parity_only)
            for (int rep = -2; rep < 12; ++rep)
                for (int pos = 0; pos < 2; ++pos) {
                    const int mode = (pos + (rep & 1)) & 1;
                    evict<<<1024,256,0,stream>>>(trash, evict_bytes / 4, checksum);
                    CK(hipGetLastError()); CK(hipEventRecord(begin,stream));
                    run(mode); CK(hipGetLastError());
                    CK(hipEventRecord(end,stream)); CK(hipEventSynchronize(end));
                    float ms = 0; CK(hipEventElapsedTime(&ms,begin,end));
                    std::printf("TIME case=%s rep=%d mode=%d gpu_ms=%.9g\n", c.name, rep, mode, ms);
                }
        CK(hipFree(drt)); CK(hipFree(dy)); CK(hipFree(dw)); CK(hipFree(dp)); CK(hipFree(storage));
        std::fflush(stdout);
    }
    if (trash) CK(hipFree(trash));
    if (checksum) CK(hipFree(checksum));
    CK(hipEventDestroy(begin)); CK(hipEventDestroy(end)); CK(hipStreamDestroy(stream));
    std::printf("COMPLETE exact=%d\n", int(all));
    return all ? 0 : 3;
}
