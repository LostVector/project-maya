# Exact compressed-input reuse in Model dispatch

Default-off `DS4_EXL3_COMPRESSED_PREPARED=1` reuses rotated FP16 activations across compressed FMA16 output tiles. Existing predecoded dispatch retains priority. The frozen training-only selector admits remaining D=5120, FF=1152/2304, cb=2, equal K=3/4 groups with at least 256 gathered rows. Weight decoding and accumulation order are unchanged. Scratch is 40 MiB per exercised GPU at chunk capacity 2048, allocated after expert-cache placement.

## Full-model validation

DeepSeek-V4.1-Flash-1017 EXL3 3.5bpw; two R9700 32GB and one RX9070XT 16GB; TP2, layer split 36/4; context 262144; RAM expert weights and disk engrams. Both arms enable accepted FMA16, packed host, predecode, host-copy wait and peer all-reduce; only compressed input preparation changes.

Cold 2069-token, warm 2048-token, repeat full logits are finite and bit-exact against independent accepted references. All 80 greedy tokens match. Candidate dispatch counters are 857 cold / 763 warm; baseline zero. All three GPUs allocate scratch. Expert cache stays 3469/3469/695; cache moves and model swap are zero.

Warm: 24 balanced trials in six blocks; mean paired block latency reduction 0.54046%, 95% Student-t interval [0.35188%, 0.72905%], all six blocks positive. Trial medians 6759.943 vs 6716.7375 ms. This is a small end-to-end improvement, not the larger isolated kernel speedups.

Cold: eight trials in two blocks; confidence interval crosses zero widely, so no cold-prefill improvement claim. Decode: one 64-token pair 12.183 vs 12.235 tokens/s, insufficient to establish a change.

The selected server remains the accepted peer-prefill build. This checkpoint does not enable the new flag. Independent confirmation and updated critical-path profiling are next. Results are hardware/model specific.

Local executed integration commit 8d6d92e and public integration 76a2a54 have identical changed Model/kernel/header/test sources; the local baseline contains preexisting RAM-slice support. Durable receipts, binaries, full logits and scripts: `/home/rkuo/research/llm-weight-compression/_meta/maya-compressed-serving-20261020`.
