#pragma once
#include <vector>
#include <cstddef>
#include <cstdint>
namespace strata::ds4 {
// Host-only history. Only the immediately preceding chunk can predict a layer.
struct PrefetchHistory {
    struct Entry { int chunk = -2; std::vector<int> bounds; };
    std::vector<Entry> layers;
    void remember(int layer, int chunk, const std::vector<int>& bounds) {
        if (layer < 0) return;
        if (layers.size() <= std::size_t(layer)) layers.resize(std::size_t(layer) + 1);
        layers[std::size_t(layer)] = {chunk, bounds};
    }
    std::vector<uint8_t> predict(int layer, int chunk, int v0, int count) const {
        if (layer < 0 || std::size_t(layer) >= layers.size() || v0 < 0 || count <= 0) return {};
        const auto& e = layers[std::size_t(layer)];
        if (e.chunk + 1 != chunk || std::size_t(v0) + std::size_t(count) >= e.bounds.size()) return {};
        std::vector<uint8_t> out(std::size_t(count), 0);
        for (int i = 0; i < count; ++i) out[std::size_t(i)] = e.bounds[std::size_t(v0+i+1)] > e.bounds[std::size_t(v0+i)];
        return out;
    }
};
}
