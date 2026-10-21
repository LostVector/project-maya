# Prefill cap refinement and independent confirmation

Repeated fresh-load measurements favor cap 4096 for the primary 32K prefill objective. Cap 3648 is faster at 8K, with a small 32K tradeoff. These are the best observed settings in this tested range, not a global optimum or a guarantee of first-request speed.

| Cap | 8K tok/s | 32K tok/s | 32K expert-transfer GB |
|---|---:|---:|---:|
| 3648 | 647.6 | 882.3 | 398.55 |
| 4096 | 613.2 | 890.5 | 367.76 |
| 6560 | 603.9 | 856.2 | 276.88 |

Each cap has two independent fresh model loads. Each load runs excluded Warm8K and Warm32K, then timed Amber8K, Cobalt32K, Birch8K and Dune32K. Rates are tokens divided by mean prompt latency, not averages of rounded displayed rates. All 36 confirmation responses are retained and independently regrade correctly. Prefix reuse is zero; VmSwap was zero at request boundaries. There were no recorded peer failures, all six arms shut down cleanly, and fallback restoration completed. Swap checks are not a continuous swap trace.

Frozen order: 6560, 4096, 3648, 3648, 4096, 6560. Both prior screening stages are excluded from confirmation estimates. Controls remain the three-GPU EXL3 RAM path, TP2 plus tail split 36/4, context 262144, wide relaxed WMMA16, whole-chunk dependency pruning, normal cache bonus 1, no expert-profile seed, and runtime d80bd83 from PR38. Workspace and residency differ with cap and are recorded. Hardware and model match the preceding coarse checkpoint.

4K's load means were 890.66 and 890.37 tok/s at 32K; 3648's were 881.89 and 882.77. Paired latency reductions favor 4K by 0.85–0.99%, averaging 0.92%. The descriptive unadjusted paired t interval is 0.08–1.76% (two blocks, df 1). At 8K, 3648 reduces latency by 5.31% on average, with a descriptive interval of 1.98–8.65%. These intervals are not adjusted for observed winner selection. The 4K/6560 comparison has a wide interval crossing zero; the observed pooled mean favors 4K, but two loads do not establish a precise population effect.

The main objective is warmed-model throughput on uncached prompts. Warmups remain in the raw data, including the 72-second 8K warmup in the first 6560 load. They are excluded only under the previously frozen rule. Cold delays remain a profiling question. Short deterministic decode timings are retained and summarized; they do not establish sustained decode performance.

Refinement is included separately: the fresh 4096/4384/4672 screen averaged 871.47/716.83/838.36 tok/s at 32K. All 18 responses regrade correctly. The intermediate caps preserve the same token partitions at 8K and 32K, but change workspace limits and expert grouping. Neither improved throughput. The 4384 Cobalt outlier (54.0 s) is preserved alongside Dune (37.4 s). Source inspection is not a causal attribution of that variation.

The preceding six-cap coarse screen remains in its own checkpoint. It selected the leading partition. Refinement was added after source review, before any refinement measurements. Fresh refinement remeasurement superseded the coarse measurement of the same cap for finalist selection; no unequal-count pooling was used. The three strongest distinct candidates then received this independent confirmation. All selection inputs and SHA-256 identities are included in the protocol metadata.

Reanalysis requires only Python's standard library:

```sh
python3 docs/experiments/chunk-cap-confirmation-20261021/confirm.py
python3 docs/experiments/chunk-cap-confirmation-20261021/summarize.py refinement.json
```

The scripts regrade every answer, validate expected routing work and expert-copy byte bounds, then recompute load means, pooled rates and paired intervals. This is a portable reanalysis package, not a model rerun package. Full prompts and engine logs remain in the durable local phase directories with recorded hashes. Expert-transfer bytes are physical weight payloads, not hardware-wide PCIe traffic.

4K has separate native numerical evidence from PR37: 195 candidate and 195 repeat full-vocabulary states exact within the same 4K configuration, with three retrieval answers correct. Its matrix source matches the current runtime; the production delta is the steady peer-clock fix. Cross-cap 2K/4K logits are not bit exact (code/database mean KL about 0.01371/0.00632). This configuration drift remains documented under the authorized matrix experiment. Those native checks do not cover cap 3648; its current evidence here is the limited API retrieval set. No broad quality claim is made.

Serving promotion is tracked separately under maya-prefill-cap-serving-20261021 and requires held-out quality, fresh 8K/32K retrieval and cached-conversation checks. The rollback keeps the steady-clock fix at cap 2048; the original pre-fix configuration remains preserved. This PR changes documentation and data only.
