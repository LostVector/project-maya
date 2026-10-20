# Experimental twelve-token HIP FMA tile

This is a disabled research checkpoint for adaptive expert-kernel dispatch. It is not a global replacement for the accepted sixteen-token path, and no full-model speedup or logit-parity result is claimed here.

`DS4_EXL3_FMA_TILE=12` explicitly selects the new twelve-token HIP grouped-expert gate/up and down kernels. Only value12 is recognized; other values retain the existing `DS4_EXL3_FMA16` eight/sixteen-token selection. Default behavior is unchanged. The twelve-token implementation preserves each output's FMA order, reductions, Hadamard transforms and rounding.

## Correctness and resources

All33 standalone CPU-reference cases passed on the R9700/gfx1201: all24 K/codebook combinations, empty groups, a nonzero routing offset and ragged tails. Intermediate FP16 gate values and final FP32 outputs match the original eight-token implementation bit-for-bit. Each timed benchmark arm also compares its output to that reference; all192 broader-screen arms passed.

For K3/cb2 gate/up, twelve tokens uses186 VGPRs and19200 bytes LDS versus195 VGPRs and25344 bytes for sixteen. Down uses180 versus190 VGPRs. These kernels have no spills. Lower resource usage alone does not predict which tile is faster.

## Group-size sweep

Model-shaped matrices E5120/F1152; two active experts with row counts n/n+1 and one empty expert; K3/4, cb2. Each arm uses2000 warmups and200 timed repetitions. Four repetitions per tile, balanced across8/12/16. Figures below are median time reductions of twelve versus sixteen tokens; negative values are regressions.

| Rows per active expert | K3 | K4 | Fastest tile |
| --- | ---: | ---: | --- |
| 8/9 | 3.6% | 4.2% | 12 |
| 12/13 | -9.7% | -13.1% | 8 |
| 16/17 | 18.9% | 20.8% | 8 |
| 24/25 | 15.8% | 15.6% | 12 |
| 32/33 | 14.5% | 15.4% | 12 |
| 48/49 | 6.0% | 7.3% | 12 |
| 64/65 | -8.1% | 1.8% | 16 /12 |
| 96/97 | 6.7% | -5.9% | 12 /16 |

One K3/96-row sixteen-token arm was3.005ms while the other arms were about1.1ms. It remains in the archived means; this table uses medians. No concurrent serving request was recorded. These are isolated kernel measurements with only two active experts, not a model's heterogeneous batches or whole-model performance.

## Actual-model group capture

A subsequent diagnostic capture preserved full logit parity against logged/unlogged controls, repeat and the accepted packed-host+FMA16 engine. All expected380 case/GPU/layer/chunk combinations were covered, with six routed rows per token. The20973 recorded groups reveal substantial heterogeneity:

* On the TP pair, cached groups typically have four expert slots; streamed groups have eleven. These differ from the two-active-expert microbenchmark.
* Database cached experts have median50 rows and p90 of284; streamed experts have median8 and p90 of48. For code these are8/84 and7/45.
* The largest expert receives1865 database rows or869 code rows. Experts with more than128 rows account for64.4% and37.0% of TP-pair routed rows respectively. These are row shares, not measured time shares.

`tests/fixtures/exl3_group_replay/groups.json` publishes55 representative groups (27 training,28 held out), with exact counts including zero slots and dimensions/quantization/source metadata. See its README for provenance, sampling and limitations. No model speedup is claimed from this diagnostic capture. The next gate is to replay these heterogeneous groups; amortizing repeated decompression for very hot experts is another untested candidate.

## Reproduction and next gate

Build `exl3_test`. `EXL3_SET_ONLY=1` runs the33 correctness cases. `EXL3_SET_BENCH=1 EXL3_SET_BROAD=1` runs the shape sweep, with bitwise checks on every arm. The initial37/0/70-row screen is available with `EXL3_SET_BENCH=1` alone.

Actual heterogeneous groups are now captured in the replay fixture. Before model integration, benchmark those groups and batch sizes. The model already has their host-side bounds in `run_set`; do not add GPU readbacks just to select a tile. Benchmark representative mixed groups before choosing a policy. Then require the existing finite, strict full-model logit gate and controlled prefill/decode comparisons. Keep the accepted packed-host+FMA16 server as the baseline.

All raw timings, source, binary, metadata and receipts are retained under `/home/rkuo/research/llm-weight-compression/_meta/maya-fma12-20261020` on the test host. Nothing from this checkpoint is deployed.
