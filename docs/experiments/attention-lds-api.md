# Packed-attention LDS layout: repeated API comparison

This records the end-to-end result for the default-off HIP layout from
[the kernel checkpoint](attention-lds.md), source `b49b20c`. The candidate
enables `DS4_HIP_ATTN_SWIZZLE=1` at the selected 4096-token chunk cap.

## Result

| Fresh prompt | Control | Candidate | Throughput increase |
| --- | ---: | ---: | ---: |
| 8,192 tokens | 611.5 tok/s | 724.1 tok/s | 18.41% |
| 32,768 tokens | 884.5 tok/s | 1,024.9 tok/s | 15.87% |

Rates pool latency across all four timed prompts per length per variant.
The corresponding pooled latency reductions are 15.55% and 13.69%.

The frozen order was control / candidate / candidate / control. Each arm
starts a fresh model, runs an excluded 8K and 32K warmup, then times Amber8K,
Cobalt32K, Birch8K and Dune32K. All eight warmups and sixteen timed requests
are retained, including cold-start and decode stalls; no outlier was removed.

| Load | Variant | 8K pooled rate | 32K pooled rate |
| --- | --- | ---: | ---: |
| 0 | control | 623.4 | 896.0 |
| 1 | candidate | 712.7 | 1,011.6 |
| 2 | candidate | 736.0 | 1,038.5 |
| 3 | control | 600.1 | 873.4 |

Both paired blocks improved at both lengths. There are only two independent
fresh loads per variant. The descriptive paired latency-reduction t95
intervals, with one degree of freedom, remain very wide:

| Prompt | Mean paired reduction | Descriptive interval |
| --- | ---: | ---: |
| 8K | 15.49% | [-22.15%, 53.13%] |
| 32K | 13.67% | [-14.75%, 42.08%] |

These observations support an experimental setting on this workload and
machine. They do not establish a universal gain or an optimal configuration.

## Controls and traffic

Hardware: two R9700 32 GB cards plus an RX 9070 XT 16 GB. The control uses
the selected steady-peer-clock executable at `d80bd83`; the candidate is
its attention-layout build. TP2 plus tail, layer split 36/4, chunk4096,
context limit 262144, RAM experts, matrix16 and whole-chunk pruning stay fixed.
The configured maximum context is not the tested prompt length.

Each fast GPU retains 3409/13824 expert members, and the tail retains
670/1536. The same allocations were observed on every load. All 24 responses
match the expected JSON, all prompt-cache counts are zero, request counters
prove isolation, model swap is zero at request boundaries and no peer failure
was logged. Routing, pruning and streamed-weight counters were regraded from
the raw per-request traces.

On the timed 32K requests, logical TP-deduplicated row-hit fractions average
90.13% for control and 90.16% for candidate. Physical streamed expert payload
averages 367.30 GB and 366.84 GB respectively, summing both TP members plus
the tail. This counts expert payload, not every PCIe transaction or other
traffic. A high row-weighted hit fraction can coexist with many rarely used
experts being copied. The layout change does not materially reduce those
copies.

The 27-token decode samples after 32K prompts pool to 24.76 and 24.73 tok/s.
Short 8K decode samples contain large stalls on both variants, all retained.
This experiment does not establish sustained decode performance or a decode
speedup.

## Numerical and serving scope

The preceding kernel checkpoint has 192 exact operator comparisons across
all three GPUs, plus 195 exact full-vocabulary candidate states, 195 exact
repeat states and195 matches to independently accepted 4K references. All nine
fixture responses are correct. Those frozen-profile checks hold the cap and
pruning fixed; existing matrix/cross-cap numerical limitations remain.

The separate twelve-task quality and fresh 8K/32K plus real cached-followup
serving checks are in progress. The source flag remains default off. This
checkpoint does not claim that the serving trial has passed.

## Regrade

```sh
python3 docs/experiments/attention-lds-api-checks/check.py
```

The checker independently grades saved responses against the included
payloads, verifies configurations, request isolation, pruning/routing/streamed
payload counters against raw traces, and recomputes pooled rates and paired
intervals. It needs no GPU or model. Included historical configuration paths
describe the measurement environment; regrading does not access those paths.
This is a receipt regrade, not a new model execution.
