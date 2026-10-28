The existing host-mailbox activation copy is a better candidate than peer reads on this helper link. Four-float reads reduced the diagnostic ready-copy stage from about 39 to 14 us for one 5,120-float row and from 204 to 57 us for six rows. The actual production vector API reduced synthetic transfer/ack chain latency from about 45 to 22 us and 211 to 64 us respectively. These are operator measurements, not inference speedups.

`MAYA_DS4_HELPER_INPUT_VEC=1` opts into aligned float4 mailbox loads; other dimensions or alignments retain scalar reads. No extra VRAM, added transfers, new lifetime protocol, altered expert arithmetic or changed CPU/helper addition order. Default remains off.

The probe passed 3,360 dynamic transfers and 12,288 timed transfers across primary0→helper2 and primary1→helper2. Checks cover raw NaN/infinity/subnormal payloads, routing metadata, pointer plans, guards, changing row counts, slot reuse, dimensions 5120/4097/8192, and independently misaligned host input and device output. Both timed processes had no KFD eviction or memory-pressure counter changes; no serving requests ran. The current-main Release HIP production build passed.

Direct peer reads were slower than host reads for both scalar and vector variants. They are retained as negative evidence, not integrated into serving. The diagnostic clones add identical device clocks/barriers after request readiness; the existing and new production API calls are separately checked. Wall timing includes the synthetic publisher and host launch gaps, so it is not pure copy latency.

The prior model profile measured 0.577 ms/output of post-CPU helper waiting, which includes expert computation, and 0.026 ms/output of host helper merging. Removing both perfectly would have bounded ideal speedup at 2.52% on those older workloads; it is not a current universal ceiling. Copy savings must not be extrapolated directly to decode gains.

Next validation belongs to canonical work item `p2p-helper-exchange`: matched-residency full-vocabulary comparison and a bounded balanced MTP decode screen on the optimized serving backport. Public-current-base model startup, CUDA behavior and full-model throughput remain unvalidated. Normal serving was never restarted or modified during these probes. Permanent raw traces, build commands, source hashes and the model-validation design are in the adjacent JSON's artifact root and linked from the single canonical plan.

The optional HIP CMake target `ds4_helper_input_probe` is excluded from default builds. Its G/Q handshakes let the controller snapshot KFD/PSI while the process is alive. For a manual correctness run on an idle, peer-capable pair, use the ROCm runtime environment of the build:

```sh
cmake --build build-hip --target ds4_helper_input_probe -j4
printf GQ | env HIP_VISIBLE_DEVICES=0,2 build-hip/ds4_helper_input_probe
printf GQ | env HIP_VISIBLE_DEVICES=0,2 build-hip/ds4_helper_input_probe timing
```
