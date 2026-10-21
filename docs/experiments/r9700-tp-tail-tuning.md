# TP2 tail split and expert reuse on R9700 + RX 9070 XT

This is a hardware-specific benchmark checkpoint on the experimental sorted-row combine branch. Two 32 GB R9700s form the TP2 first stage; one 16 GB RX 9070 XT on a slower PCIe 4 x4 link runs the remaining tail layers. Expert weights within TP2 are sharded, rather than stored as complete duplicate copies. This checkpoint changes no defaults.

## Tail split: useful candidate

`DS4_SPLIT=38,2` moves two layers from the tail onto the TP2 pair. The executable and all other selected settings stayed fixed: EXL3 3.5 bpw, 262144 context, 4096-token chunks, 240 W on all three GPUs, RAM experts, whole-chunk pruning, matrix16, attention swizzle, combine mode 3, and peer all-reduce. This requires the experimental feature stack on the PR base branch; equivalent upstream behavior has not been established.

Fresh model loads ran in **36/4 → 38/2 → 36/4** order. Each load received one excluded 32K warm-up, then an uncached 8K and 32K prompt. All nine structured answers were correct, with `cache_n=0`, isolated request counts, and model `VmSwap=0`.

| Prompt | 36/4 first | 38/2 | 36/4 repeat | Throughput gain vs mean baseline |
|---|---:|---:|---:|---:|
| 8K | 735.6 tok/s | 829.9 tok/s | 735.1 tok/s | 12.9% |
| 32K | 1062.3 tok/s | 1115.0 tok/s | 1063.5 tok/s | 4.9% |

The 38/2 layout slightly reduced expert-cache capacity on the R9700s. The 9070 XT held 691 of 768 resident expert slots across its two layers, versus 670 of 1536 in the four-layer tail. On the 32K prompt, its expert streaming fell from **6.705 GB to 0.0177 GB**, while total expert payload across all GPUs increased from 357.945 GB to 376.543 GB.

Faster execution therefore did not require fewer total bytes. Removing most expert transfers from the slow tail link is a plausible explanation, though this is not a kernel or PCIe timing profile. Pruning bounds the tail's active rows, which is consistent with the similar absolute latency saving at 8K and 32K. Payload counters exclude Engram, activation, collective, and PCIe protocol traffic.

For an otherwise identical configuration, the candidate delta is:

```json
{"env": {"DS4_SPLIT": "38,2"}}
```

One candidate load and two synthetic timed prompts do not establish broad quality or workload performance. Moving layers between TP2 and TP1 changes floating-point reduction order; no bit-exact topology parity is claimed. **36/4 was restored and remains selected.** Perform broader quality and usage validation before promotion.

The bounded screen did not test 37/3, 39/1, a TP1 pipeline, or TP3. The current pruning implementation does not support the proposed TP1 pipeline or TP3 layouts; they require a fair pruning port before comparison.

## Expert speculation and paired reuse: negative gates

These separate native experiments used fixed expert placement and an independent accepted full-vocabulary reference. Their timings cannot be directly substituted for the serving measurements above. Both stayed disabled. Neither received a broader decode, KV, snapshot, or API quality campaign after failing its speed gate.

- **Previous-chunk speculative prefetch:** all six prefill states were exact, with zero swap, useful predictions on both TP ranks, and no pending work. Paired latency reductions of 0.170% and 0.416% failed the predefined 1% improvement gate. Useful predictions covered about 2.15% of baseline streaming bytes and introduced false-positive traffic.
- **Layer-paired expert reuse:** all six prefill states were exact, with zero swap, identical routing counts, and exact byte conservation. A 512 MiB temporary cache per GPU avoided 37.759 GB of H2D payload per R9700 (17.5%), while adding 80.437 GB of D2D payload per R9700. Latency regressed 3.592% and 4.715%. An initial guard error and a 768 MiB allocation rejection occurred before paired arithmetic; separate receipts retain those attempts.

The prototypes are available on the fork's `experiment/ds4-speculative-prefetch` and `experiment/ds4-layer-paired-reuse` branches. A future paired variant could batch or defer cache admission, or first measure schedule-only overhead. These are unprofiled hypotheses. The requested complementary expert-execution role for the 9070 XT remains a future routing-trace screen.

Raw timings, counters, and gate results are in the accompanying JSON files. Durable local receipts live under `/home/rkuo/research/llm-weight-compression/_meta/` in:

- `maya-tp-cache-topology-20261021`
- `maya-speculative-prefetch-20261021`
- `maya-layer-paired-reuse-20261021`

Disposable experiment checkouts were removed after verifying complete-history source bundles and SHA-256 readback. Source branches remain available for review.
