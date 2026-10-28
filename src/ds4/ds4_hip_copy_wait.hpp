// An expert part may be reused only after its previous consumer's event was submitted.
#pragma once
#include <cuda_runtime.h>
#if defined(STRATA_USE_HIP)
namespace strata::ds4 {
inline cudaError_t expert_copy_reuse_wait(cudaStream_t copy, cudaEvent_t freed, bool host_wait) {
    return host_wait ? cudaEventSynchronize(freed) : cudaStreamWaitEvent(copy, freed, 0);
}
} // namespace strata::ds4
#endif
