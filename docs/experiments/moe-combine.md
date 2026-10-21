# Exact sparse expert combination: native checkpoint

Default off, based on `b49b20c`. `DS4_MOE_COMBINE_MODE=2` selects a fixed
six-pick kernel; other pick counts retain the original kernel. Mode 1 is the
smaller lazy-read candidate retained for comparison. Selected serving does
not enable either mode at this checkpoint; fresh-load API validation is pending.

## Why this kernel

The accepted swizzled-attention profile shows 9499 combine launches per fast
GPU for the Cobalt 32K fixture, each with 4096 tokens ×5120 output dimensions,
totalling about 2.03s per GPU. Source and ISA show an unconditional accumulator
load before testing whether any pick belongs to the current expert batch.
That represents 796.83GB of nominal accumulator-load payload per GPU, not a
measurement of physical HBM traffic. Many streamed batches touch few tokens.

Mode 2 loads the six positions at fixed offsets, forms a membership mask, and
returns for tokens with no contribution before reading the accumulator.
It executes the same conditional `__fmaf_rn` operations in the original pick
order. It keeps batch order, weights, output indexing, precision, workspace,
cache placement, chunk size and synchronization unchanged. Zero weights are
not skipped, and untouched accumulators retain their exact bits.

LLVM combines the fixed position reads into 128-bit plus 64-bit scalar loads.
The accumulator load follows the no-hit guard in the emitted ISA. Mode 2
object metadata reports 7 VGPR, 28 SGPR, no LDS/private storage or spills;
the original reports 7 VGPR, 20 SGPR. Lazy mode 1 reports 9 VGPR, 20 SGPR.
Object counts do not establish runtime occupancy.

## Quick screen before model work

Ten cases exercise 1/10/50/100% token participation, one/three/six matching
picks, no hits, ragged dimensions, a non-six-pick fallback and empty ranges.
All 120 operator comparisons pass exactly across three GPUs, with GPU1
repeated. Small cases also match a CPU fused-FMA reference. Finite outputs,
signed-zero inputs, untouched values and both output guards are checked.

On dedicated R9700 GPU1, initial mode 2 median latency reductions were:

| Case | Original | Mode 2 | Reduction |
| --- | ---: | ---: | ---: |
| 1% participation, one pick | 0.19844ms | 0.13202ms | 33.47% |
| 10%, one pick | 0.21120ms | 0.14936ms | 29.28% |
| 50%, one pick | 0.29408ms | 0.25330ms | 13.87% |
| 100%, one pick | 0.42076ms | 0.42764ms | -1.64% |
| 10%, three picks | 0.22690ms | 0.16392ms | 27.76% |
| 100%, six picks | 1.10751ms | 1.10833ms | -0.07% |

Each option has two excluded warmups and twelve timed samples, with reversed
ordering. A 256 MiB cache-line sweep precedes every option outside GPU events.
Only the combine kernel is timed. Accumulators evolve across timed launches;
correctness uses separate reset inputs. Host queue-wall time includes pending
eviction and is not a kernel-only metric. No-hit/empty cases are correctness
stress cases rather than representative model batches. Repeated screens on
GPUs 1/0/2 retain all results; desktop activity can affect GPU0 timing.

## Native numerical gate and feed screen

With layout/pruning on and the selected 4096 cap fixed, combine 0/2/0 passed
195/195 candidate full-vocabulary states and 195/195 repeat states exactly.
All 195 also match independently accepted selected-runtime reference hashes.
The cases are 8K, 32K and a pruned 8K prefix plus 512-token append, each followed
by 64 teacher-forced steps. All nine decoded responses match their expected
JSON, with no model swap observed. This is limited fixture evidence.

After the external numerical/answer gate passed, the same resident model
ran one excluded 32K warmup per mode and four timed pairs in alternating
AB/BA order. Expert profile/residency stayed frozen; all ten final logits
were checked exactly at runtime and all routing/copy counters match.

The timed native feed latency reductions were 1.666%, 1.634%, 1.681%, 1.563%;
pooled reduction **1.636%**. These are temporally correlated pairs in one
frozen-profile model. They exclude HTTP/tokenization/decode and are a screen,
not production throughput acceptance. The separate API comparison is pending.

## Reproduce and regrade

```sh
cmake --build build-hip --target ds4_moe_combine_bench ds4_moe_combine_model_test -j4
./build-hip/ds4_moe_combine_bench 1
python3 docs/experiments/moe-combine-checks/check.py
```

The operator/model binaries were directly compiled and linked with recorded
SDK flags and SHA-verified archived dependencies; CMake targets follow the
existing explicit-test recipes. To repeat native parity, copy the fixtures
from `docs/experiments/attention-lds-checks/` to a writable output directory:

```sh
DS4_YOCO_TEST_MATRIX=1 DS4_YOCO_WHOLE_CHUNKS=1 \
DS4_YOCO_TEST_PREFIX_PRUNED=1 HIP_VISIBLE_DEVICES=0,1,2 \
./build-hip/ds4_moe_combine_model_test /path/to/maya-pack /path/to/output 4096 64
python3 docs/experiments/moe-combine-checks/check.py --raw-dir /path/to/output
```

The raw option verifies all 585 snapshots against independent selected-state
SHA256 references, finite values and recorded free-response token paths.
Default regrading only checks included receipts. Timed last-logit vectors
were compared in the running C++ test but not individually dumped. The
optional `DS4_COMBINE_TEST_PERF=1` timing phase waits for an external numerical
gate in `timing-gate.txt`; it is not a substitute for fresh-load API checks.
