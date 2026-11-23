#include "../src/ds4/ds4_prefill_loan.hpp"

#include <cstdlib>

using namespace strata::ds4::prefill_loan;

static void require(bool passed) {
    if (!passed) std::abort();
}

int main() {
    require(!eligible(min_fresh - 1, true, true));
    require(!eligible(min_fresh, false, true));
    require(!eligible(min_fresh, true, false));
    require(eligible(min_fresh, true, true));

    const std::size_t reserve = std::size_t{2048} << 20;
    const std::size_t padded = reserve + reserve_padding;
    require(fits_reserve(padded, padded, reserve));
    require(!fits_reserve(padded, padded - 1, reserve));
    require(!fits_reserve(padded - 1, padded, reserve));
    require(!fits_reserve(padded, reserve - 1, reserve));

    require(steps(512, 512, 256) == 0);
    require(steps(513, 512, 256) == 1);
    require(steps(768, 512, 256) == 1);
    require(steps(769, 512, 256) == 2);
    require(steps(1536, 512, 256) == 4);
}
