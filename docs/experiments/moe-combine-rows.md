# Combine only rows in the expert batch

The selected mode-2 combine kernel skips accumulator reads for absent tokens,
but launches a grid spanning every token. This prototype uses the existing
sorted token-row array already consumed by expert gate/up kernels, avoiding
empty-token work without a new preparation kernel or workspace.

HIP `DS4_MOE_COMBINE_MODE=3` enables this path when `k == 6`, the row-token
array is supplied, and the expert batch has fewer rows than tokens. Other
six-pick batches fall back to mode 2; other pick counts retain the original
kernel. Mode 0 remains the source default. The production call supplies the
existing `c.row_tok` array; no allocation, cache or chunk setting changes.

A token can occur in several rows of a batch. Each CTA reads that token's six
original positions and only the CTA associated with its first matching pick
may write the accumulator. That CTA performs all matching FMAs in the original
pick order. The first matching pick need not be the smallest sorted row.
This keeps one writer per output and preserves arithmetic across batches.

## Quick operator evidence

The GPU1 screen compares original mode 0, selected mode 2 and candidate mode 3,
with two excluded warmups and 12 samples per mode/case. A 256 MiB eviction kernel
precedes every option, outside timed events. No preparation or counter-reset
cost is omitted: this prototype needs neither. Timed accumulators evolve
across batches; exactness uses separately reset inputs.

| Case (4096 tokens, 5120 dimensions) | Mode 2 median ms | Mode 3 median ms | Lower latency |
| --- | ---: | ---: | ---: |
| 1% active, one pick | 0.131101 | 0.013100 | 90.0% |
| 10% active, one pick | 0.149182 | 0.050741 | 66.0% |
| 50% active, one pick | 0.251942 | 0.222662 | 11.6% |
| 10% active, three picks | 0.163341 | 0.092901 | 43.1% |
| 1% active, six picks | 0.133741 | 0.024520 | 81.7% |
| 100% active, six picks (fallback) | 1.118289 | 1.118689 | -0.04% |

The 13 cases also cover ragged dimensions, other pick counts, empty ranges,
and synthetic no-hit metadata. Hit positions are permuted, so ownership is
checked independently of sorted row order. Small cases compare CPU `fma` as
well as GPU baseline outputs; signed zero, zero weights, finiteness and guards
are checked. The initial 39 comparisons plus 39 on each of GPUs 1, 0 and 2
passed: **156 exact comparisons** total. Small ragged cases have microsecond
noise/regressions; all samples are retained.

These are operator results, not a full-model speedup. A strict 2/3/2 native
validation is in progress at this checkpoint: 195 candidate/repeat states,
independent prior references, resumed pruned prefix, and free answers. Mode 3
is not selected in serving. A fresh production executable and test executable
were built with freshly compiled model objects and kernel object; the internal
combine signature changed, so reusing an older model object would be invalid.
No full CMake build or full-model numerical/API acceptance is claimed here.

## Regrade

```sh
python3 docs/experiments/moe-combine-rows-checks/check.py
```

Explicit build targets are `ds4_moe_combine_rows_bench` and
`ds4_moe_combine_rows_model_test`. The standalone operator binary accepts an
optional HIP device ordinal. The native test uses the frozen fixture protocol
from the component checkpoint, with `DS4_COMBINE_TEST_PERF=0` for parity only.
