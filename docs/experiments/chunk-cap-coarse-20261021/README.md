# Six-cap prefill screening after the steady peer-clock fix

The screen compares distinct balanced chunk partitions on the three-GPU EXL3 setup. The previous single-point quick screen favored 4688, but that ordering did not repeat here. 4096 leads the 32K screen; 3648 is essentially tied at 32K and faster at 8K. These are candidate-selection results, not a default change or an established throughput gain.

| Configured cap | 8K tok/s | 32K tok/s | 32K expert-transfer GB | 32K logical row hit |
|---|---:|---:|---:|---:|
| 3648 | 649.6 | 885.6 | 398.22 | 89.58% |
| 4096 | 610.8 | 888.9 | 370.48 | 88.98% |
| 4688 | 619.7 | 798.9 | 339.59 | 89.51% |
| 5472 | 619.3 | 852.5 | 308.87 | 89.27% |
| 6560 | 604.0 | 856.9 | 276.83 | 89.27% |
| 8192 | 404.1 | 676.2 | 243.97 | 89.00% |

Each rate is tokens divided by the mean prompt latency of two distinct timed prompts. Do not average displayed rounded rates. Each fresh load runs excluded Warm8K/Warm32K, then timed Amber8K/Cobalt32K/Birch8K/Dune32K. All 36 requests and their responses/timings/counters are included in measurements.json; 12 warmups remain visible but excluded from the table. All 36 synthetic retrieval answers regrade correctly, prefix reuse and swap are zero, expected routing work and expert-transfer byte bounds pass, and no peer failure was recorded. One load per cap in frozen order 4096,5472,3648,6560,4688,8192; no confidence interval or broad quality conclusion is justified.

Controls: DeepSeek-V4.1-Flash-1017 EXL3 3.5bpw; RAM-resident host experts, disk engrams; two 32 GB R9700 cards in TP2 plus 16 GB RX 9070 XT tail, split 36/4; max context 262144; whole-chunk dependency pruning, relaxed wide WMMA 16, normal cache admission bonus 1, no expert-profile seed. Runtime commit d80bd83 (own-fork PR #38), built for gfx1201. Workspace size and expert residency vary with cap and are recorded rather than equated. Counts are executed logical routing picks and expert H2D payload bytes, not hardware-wide PCIe measurements; TP duplicate physical bytes are summed while logical hits count each logical route once.

Larger caps reduce transfers but retain more late-layer work; source inspection also shows that cap sets c.C, which changes expert grouping and can cross predecode dispatch thresholds. These data do not isolate the contribution of those effects. 8K cap transfers about 244 GB at 32K versus 370 GB for 4K, yet is slower. 4K versus 3648 differs by less than 0.5% at 32K, too little to call from this screen. The old quick screen had a different warmup protocol and is not pooled with these data.

Next: within the leading eight-chunk partition, freshly compare 4096/4384/4672; then repeat the three strongest distinct caps in reverse and forward screening rank. That refinement was added after source review and before any refinement measurements. Confirmation estimates will exclude both screening stages. Numerical validation and serving activation remain separate review gates. The selected 2K fallback configuration is unchanged by this checkpoint.

Reanalysis (Python standard library only):

```sh
python3 docs/experiments/chunk-cap-coarse-20261021/summarize.py
```

The script independently regrades every response against the included small fixture expectations, checks cache/swap flags, expected per-GPU routing work and physical expert-byte bounds, and recomputes the table and decode rates. This is a portable reanalysis artifact, not a model rerun package. Full prompts and engine logs remain in the durable local phase directory, with their SHA-256 identities recorded here. Raw 27-token decode timings are retained as a limited generation check, not a comprehensive decode benchmark.

Durable local receipts: /home/rkuo/research/llm-weight-compression/_meta/maya-steady-chunk-sweep-20261021. Prior failed 5472 quick-screen warmup remains preserved under maya-chunk-quick-screen-20261021; it is not relabeled as successful or included in this table.
