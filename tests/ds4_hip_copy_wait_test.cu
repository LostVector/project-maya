// Reuse a four-part expert ring with different producer/consumer streams. Exercise the production wait helper.
#include "../src/ds4/ds4_hip_copy_wait.hpp"
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#define CK(x) do { auto e = (x); if (e != cudaSuccess) { \
    std::fprintf(stderr, "line%d %s: %s\n", __LINE__, #x, cudaGetErrorString(e)); std::exit(2); } } while (0)
constexpr int kParts = 4, kBatches = 64, kCapacity = 16384, kStride = kCapacity + 8, kRepeats = 64;
constexpr uint32_t kGuard = 0xa5a5a5a5;
__global__ void consume(const volatile uint32_t* input, uint32_t* output, int n) {
    const int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    uint32_t sum = 0;
    for (int j = 0; j < kRepeats; ++j) sum += input[i] ^ (uint32_t(j) * 2654435761u);
    output[i] = sum;
}
uint32_t word(int batch, int i) { return uint32_t(batch + 1) * 2246822519u + uint32_t(i) * 3266489917u; }
std::vector<uint32_t> run(bool host_wait) {
    cudaStream_t copy{}, compute{};
    CK(cudaStreamCreateWithFlags(&copy, cudaStreamNonBlocking));
    CK(cudaStreamCreateWithFlags(&compute, cudaStreamNonBlocking));
    cudaEvent_t filled[kParts]{}, freed[kParts]{};
    uint32_t* staging = nullptr;
    uint32_t* ring = nullptr;
    uint32_t* output = nullptr;
    CK(cudaHostAlloc(&staging, size_t(kParts) * kCapacity * 4, cudaHostAllocMapped | cudaHostAllocPortable));
    CK(cudaMalloc(&ring, size_t(kParts) * kCapacity * 4));
    CK(cudaMalloc(&output, size_t(kBatches) * kStride * 4));
    CK(cudaMemset(output, 0xa5, size_t(kBatches) * kStride * 4));
    for (int i = 0; i < kParts; ++i) {
        CK(cudaEventCreateWithFlags(&filled[i], cudaEventDisableTiming));
        CK(cudaEventCreateWithFlags(&freed[i], cudaEventDisableTiming));
    }
    const int sizes[] = {4, 7, 31, 256, 1024, 4093, kCapacity};
    std::vector<uint32_t> expected(size_t(kBatches) * kStride, kGuard);
    for (int b = 0; b < kBatches; ++b) {
        const int slot = b % kParts, n = sizes[b % 7];
        if (b >= kParts) {
            // As in copy_ahead: this event was submitted by the previous consumer before the reuse.
            CK(strata::ds4::expert_copy_reuse_wait(copy, freed[slot], host_wait));
            // Host staging cannot be rewritten while its previous DMA still reads it.
            CK(cudaEventSynchronize(filled[slot]));
        }
        uint32_t* src = staging + slot * kCapacity;
        for (int i = 0; i < n; ++i) {
            src[i] = word(b, i);
            uint32_t sum = 0;
            for (int j = 0; j < kRepeats; ++j) sum += src[i] ^ (uint32_t(j) * 2654435761u);
            expected[size_t(b) * kStride + 4 + i] = sum;
        }
        CK(cudaMemcpyAsync(ring + slot * kCapacity, src, size_t(n) * 4, cudaMemcpyHostToDevice, copy));
        CK(cudaEventRecord(filled[slot], copy));
        CK(cudaStreamWaitEvent(compute, filled[slot], 0));
        consume<<<(n + 255) / 256, 256, 0, compute>>>(ring + slot * kCapacity, output + size_t(b) * kStride + 4, n);
        CK(cudaGetLastError());
        CK(cudaEventRecord(freed[slot], compute));
    }
    CK(cudaStreamSynchronize(copy)); CK(cudaStreamSynchronize(compute));
    std::vector<uint32_t> actual(expected.size());
    CK(cudaMemcpy(actual.data(), output, actual.size() * 4, cudaMemcpyDeviceToHost));
    if (actual != expected) {
        auto at = std::mismatch(actual.begin(), actual.end(), expected.begin()).first - actual.begin();
        std::fprintf(stderr, "mode=%d mismatch at%zu\n", int(host_wait), size_t(at)); std::exit(3);
    }
    for (int i = 0; i < kParts; ++i) { CK(cudaEventDestroy(filled[i])); CK(cudaEventDestroy(freed[i])); }
    CK(cudaFreeHost(staging)); CK(cudaFree(ring)); CK(cudaFree(output));
    CK(cudaStreamDestroy(copy)); CK(cudaStreamDestroy(compute));
    std::printf("COPY_WAIT host=%d batches=%d parts=%d exact=1 guards=1\n", int(host_wait), kBatches, kParts);
    return actual;
}
int main() {
    int n = 0; CK(cudaGetDeviceCount(&n));
    if (n < 1) { std::puts("SKIP: no HIP device"); return 77; }
    // Both orders exercise fresh event state; compare each mode against an independent CPU reference too.
    auto a = run(false), b = run(true), c = run(true), d = run(false);
    if (a != b || a != c || a != d) return 4;
    std::puts("COPY_WAIT_COMPLETE exact=1");
}
