The helper-input vector copy retained small positive pooled decode observations: **+0.31% coding, +0.15% async and +0.24% long context**. Control drift is comparable to some gains, so this does not establish a general decode speedup. The much larger standalone copy improvement remains separate evidence.

| Fixture | Scalar tok/s | Vector tok/s | Pooled gain | Scalar tail drift |
|---|---:|---:|---:|---:|
| code | 39.710 | 39.832 | +0.31% | +0.36% |
| async_workers | 36.428 | 36.481 | +0.15% | +0.92% |
| long | 29.001 | 29.070 | +0.24% | +0.08% |

All 21 timed 128-output-token requests were clean under observed KFD/PSI counters. Tokens, accepted/offered drafts, cache hits/lookups and helper calls/rows matched across modes. Seven of nine pairwise blocks were positive; the two negatives were −0.32% async and −0.06% long. These are three blocks in one initialized model, not independent-load confidence intervals.

All 31,027,200 full-vocabulary values matched in scalar/vector/scalar replay at the same state/residency, over 1/2/3/4/6/8/16 rows and three fixtures. The additional 1,551,360 saved canonical-reference values also matched. Private mode switches first drain queued/enqueuing helper jobs and wait the helper stream idle, so previous jobs do not change mode mid-request. No new VRAM is allocated.

The model tests use a private backport onto the optimized serving snapshot, with static startup placements, TP2, shared helper/DSpark, MTP 5/confidence 0.65, CPU 8 and 262144 context. They are not measurements from a fresh startup of this public current-base engine. Normal adaptive-cache, temperature 1/sampled drafting and broader hardware comparisons remain open. The current-upstream Release HIP production build passed in the operator phase; the public CMake probe built here and passed 1,512 dynamic checks. Normal serving was independently restored with its original binary/environment/health.

Keep `MAYA_DS4_HELPER_INPUT_VEC=1` opt-in. Standalone four-float host input reads were much faster; direct peer reads were slower. The flag changes only how the existing helper mailbox's activation payload is loaded, preserving its acknowledgement, metadata, arithmetic and fallback. No extended runtime replay or default promotion is proposed from this small screen alone.
