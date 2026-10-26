#pragma once

#include <algorithm>
#include <cerrno>
#include <cctype>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <functional>
#include <string>
#include <vector>

namespace strata::ds4 {

// Zero is the internal sentinel for the unchanged placement policy; it is not a valid setting.
inline bool draft_cache_coverage(const char* value, double& coverage, std::string& err) {
    coverage = 0;
    if (value == nullptr) return true;
    char* end = nullptr;
    errno = 0;
    const double parsed = std::strtod(value, &end);
    if (*value == '\0' || std::isspace((unsigned char) *value) || end == value || *end != '\0' || errno == ERANGE ||
        !std::isfinite(parsed) || parsed <= 0 || parsed > 1) {
        err = "DS4_DRAFT_CACHE_COVERAGE must be a finite fraction greater than 0 and at most 1";
        return false;
    }
    coverage = parsed;
    return true;
}

// Counts are historical hints. An unseen block keeps all experts; misses still use the ordinary CPU lane.
inline int draft_cache_keep(const uint32_t* counts, int n, double coverage) {
    std::vector<uint32_t> sorted(counts, counts + n);
    uint64_t total = 0, cumulative = 0;
    for (uint32_t count : sorted) total += count;
    if (total == 0) return n;
    std::sort(sorted.begin(), sorted.end(), std::greater<uint32_t>());
    int keep = 0;
    while (keep < n && (double) cumulative < coverage * (double) total) cumulative += sorted[(size_t) keep++];
    return keep;
}

}  // namespace strata::ds4
