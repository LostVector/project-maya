# Optional HIP peer-VRAM prompt reductions

For an eligible tensor-parallel pair, `MAYA_DS4_HIP_PEER_AR=1` lets the two GPUs exchange their prompt-layer partial sums directly through peer VRAM. The ordinary path stages these partials in host-mapped RAM. The new path preserves member-0-plus-member-1 F32 addition order; it changes transport, not routing or weight precision.

This is disabled by default. Set `MAYA_DS4_HIP_PEER_AR` in a serving config's `env`; native engine launches can use `DS4_HIP_PEER_AR=1` (or `STRATA_DS4_HIP_PEER_AR=1`). Both ranks must support HIP peer access, fine-grained device allocations and a queryable steady wall clock. The visible GPU IDs come from the existing tensor-parallel group; no card models, bus addresses or GPU numbers are hard-coded.

Only two-member groups using the batch prompt loader are selected. Groups using the flow loader or `MAYA_DS4_AR2=1/2` keep their existing transport. Single-GPU execution, groups of three or more, decode/verification windows, logits gathering and pipeline handoffs keep their existing paths. `MAYA_DS4_AR2_DECODE` remains independent. An enabled pair logs `exact peer prefill all-reduce enabled` at load; do not infer activation from the environment flag alone.

## Memory and failure handling

Scratch is allocated after expert placement, without removing experts to make room. Each rank needs two receive slots of `prefill_chunk * model_dimension * sizeof(float)`, plus flags and error records: approximately 80 MiB at chunk 2048/dimension 5120, or 160 MiB at chunk 4096. If either rank's initialization fails, both temporary allocations are released and the group keeps its previous transport.

Calls on each rank's compute stream have matching shapes and sequence numbers. Two receive slots prevent a producer from overwriting data the other rank still needs. Per-block completion flags publish payload stores after a system fence. Every output uses the same rank-order `__fadd_rn` as the exact host transport. Host-sequence-based graph replay is not supported.

A missing peer has a two-second device deadline. It uses `wall_clock64()` calibrated by `hipDeviceAttributeWallClockRate`, rather than a GPU core-cycle counter: a previous R9700 run recorded a negative core-counter interval that became a spurious immediate timeout after unsigned conversion. An unsupported clock query leaves host transport selected.

Timeouts set a sticky error and retain the first diagnostic (rank, sequence, observed sequence, block, payload size and elapsed/budget ticks). Later queued peer calls drain. The model checks transport status after prompt workers finish, before accepting the request. A launch error, timeout or other prompt-worker failure with an active peer group invalidates the model; reset does not clear this state, and reload is required. The port uses upstream's coordinated chunk-boundary cancellation; cancellation followed by model reuse still needs current-base validation. This does not establish recovery from arbitrary GPU/driver hangs.

## Tests and historical measurements

Build a HIP/gfx1201 tree, then:

```sh
cmake --build build-hip --target maya-ds4 ds4_peer_allreduce_test -j 4
HIP_VISIBLE_DEVICES=0,1 ./build-hip/ds4_peer_allreduce_test
```

Choose the two visible IDs appropriate to the machine. The standalone test needs about 640 MiB spare VRAM per rank and 640 MiB pinned host memory. It returns 77 when the selected pair lacks peer access, a queryable clock or sufficient spare VRAM. It compares 256 chained variable-size collectives against the existing host transport, with guarded outputs, signed zero, subnormals, extreme finite values, sequence wraparound and payloads through 8192 x 5120 floats. It also checks invalid argument rejection, an absent peer with a 50 ms physical deadline, and 32 subsequent poisoned calls preserving the first error record. The test's reset helper is only for isolated cases; the runtime never resets a failed transport.

Earlier full-model tests on our experimental EXL3 stack measured **9.2332% lower warm 2048-token prefill latency**, with a 95% interval of 8.9991–9.4673% across six balanced blocks/24 trials. Median latency was 7456.793 ms with host transport versus 6758.643 ms with peer transport. Cold results were inconclusive and no decode speedup was established. Scratch stayed allocated in both arms, keeping expert placement fixed; cold/warm/repeated logits and 80 greedy tokens matched independent references exactly.

Those tests used an older experimental engine with additional scalar EXL3, host-packing, predecode, copy-wait and transfer-pruning changes. They are evidence for this technique, **not a current-upstream end-to-end measurement**. Source and raw results are recorded in [fork PR #15](https://github.com/LostVector/project-maya/pull/15), with timeout diagnostics and the steady-clock fix in [#35](https://github.com/LostVector/project-maya/pull/35) and [#38](https://github.com/LostVector/project-maya/pull/38). Current-base full-model performance, cancellation/reuse and model-level failure-injection checks remain before promoting this draft.
