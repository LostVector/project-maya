In the bounded matched-placement MTP decode screen, peer logits staging improved throughput by **0.24% coding, 0.40% async, and 0.42% long context**. These are small positive observations, not a general serving/default speedup claim.

| Fixture | Host tok/s | Peer tok/s | Gain | Host tail drift |
|---|---:|---:|---:|---:|
| code | 39.530 | 39.626 | +0.24% | -0.71% |
| async_workers | 38.278 | 38.432 | +0.40% | +0.11% |
| long | 28.778 | 28.898 | +0.42% | -0.46% |

All 21 timed requests had no observed KFD eviction or memory-pressure events. Tokens, accepted/offered drafts, expert hit/lookup counts and gather work matched across modes. Eight of nine pairwise blocks were positive; the coding block0 was −0.04%, and long-context blocks ranged +0.07% to +1.05%. Three time blocks in a single load do not establish an independent-load confidence interval.

The change sends each nonlead vocabulary share GPU-to-GPU, instead of writing it to host RAM and reading it back. It keeps the existing two staging slots, ready flags, acknowledgement and exact scatter. The extra7.89 MiB/peer is tracked as lead scratch. Unsupported peer links or allocation failure retain host staging. Single-GPU and gather-bypassing drafter paths keep their existing behavior. No router shortcut, weight format change or new reduction kernel is involved.

Standalone copy-engine staging saved38–41 µs for one row and250–251 µs for six rows on the tested pair, with both directions exercised. All 31,027,200 full-vocabulary values matched exactly in host/peer/host replay at identical state/residency, over 1/2/3/4/6/8/16 rows and three fixtures. The optional direct-SM peer variant is a benchmark comparison only; production uses the copy engine.

The additional allocation reduced one observed startup map from 3,295 to 3,294 primary experts and increased helper experts 1,197→1,198. Two fixtures then differed from older saved logits (including an argmax difference in the 4K fixture). Those historical references do not establish parity across different placements. The current host/peer comparison deliberately reserves the same staging in both modes. A normal adaptive-cache on/off comparison including capacity cost remains unmeasured.

Current-main Release HIP production build passed. Model timings and31M-value parity came from a separate private backport onto the optimized serving snapshot, with TP2, helper/DSpark, actual 5-token MTP, fixed startup placements, CPU 8 and 262,144 context. They are not current-base production model measurements. Temperature1/sampled-drafter and other hardware/startup/failure validation remain open. Normal serving was independently restored with its original binary hash, environment and health.

Build the optional probe in an existing HIP build with `STRATA_BUILD_TESTS=ON`:

```sh
cmake --build build-hip --target ds4_logits_gather_test -j4
HIP_VISIBLE_DEVICES=0,1 ./build-hip/ds4_logits_gather_test
HIP_VISIBLE_DEVICES=0,1 ./build-hip/ds4_logits_gather_test timing
```

Use the ROCm runtime library environment required by the existing build. The standalone benchmark requires exactly two idle peer-capable GPUs, and its direct-SM comparison uses fine-grained peer memory. The serving option uses ordinary device memory. The adjacent JSON includes per-block results, request fingerprints, counters and limitations; full source/raw receipts live under its permanent artifact path and are referenced by the canonical plan.
