#pragma once

#include <cstddef>

namespace strata::ds4::prefill_loan {

inline constexpr int normal_rows = 8192;
inline constexpr int wide_rows = 12288;
inline constexpr std::size_t min_fresh = 128000;

// Keep the short-text path in private scratch. Making some of the ordinary
// arena loanable pays for the wider collective and leaves room for late allocations.
inline constexpr std::size_t private_reduction = std::size_t{768} << 20;
inline constexpr std::size_t reserve_padding = std::size_t{64} << 20;

inline bool eligible(std::size_t fresh, bool idle, bool supported) {
    return supported && idle && fresh >= min_fresh;
}

inline bool fits_reserve(std::size_t runtime_free, std::size_t driver_free, std::size_t reserve) {
    return runtime_free >= reserve && runtime_free - reserve >= reserve_padding &&
           driver_free >= reserve && driver_free - reserve >= reserve_padding;
}

// A set of tail slots is slot-major, with one expert per layer in each step.
inline std::size_t steps(std::size_t bytes, std::size_t private_bytes, std::size_t step_bytes) {
    if (bytes <= private_bytes) return 0;
    const auto extra = bytes - private_bytes;
    return extra / step_bytes + (extra % step_bytes != 0);
}

}  // namespace strata::ds4::prefill_loan
