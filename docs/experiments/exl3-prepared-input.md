# Experimental exact EXL3 prepared inputs

Adds HIP-only wrappers that prepare rotated FP16 activations once per expert set, then reuse their exact bits across predecoded output tiles. Input preparation calls the existing scaling/Hadamard/FP16 helpers. The accumulation and output reduction arithmetic remain unchanged. There is no Model dispatch or serving flag; this is an isolated kernel checkpoint.

Gate/up require separate prepared arrays because suh differs. Down preparation follows gate/up consumption on the same stream, so one workspace can be reused. `prepared_set_input_bytes(a, capacity)` reserves max(2*capacity*n_embd,capacity*n_ff) FP16 values. At D5120/FF1152/capacity2048 this is40MiB. Capacity counts sorted routed rows across the entire set, which can exceed prompt length. Bounds minus row0 must fit capacity, with nonoverlapping row intervals. Workspace lifetime/ownership belongs to one ordered stream.

## Validation

The identical public kernel/header/test sources were executed on the dedicated R9700 with the accepted three-GPU model resident and idle. GPU_MAX_HW_QUEUES was unset. HTTP activity counters verified no overlapping inference.

33 correctness cases passed bit-exact gate/up and down comparisons across K1..8/codebooks0..2, empty/ragged experts, gathered inputs, nonzero row0=13, finite outputs and scratch guards. Another12 D5120/FF1152 synthetic shapes passed. Timings include two input preparation launches, weight decoding and matrix operations. Four interleaved observations per mode/shape; descriptive medians only.

For905 routed rows, latency reduction versus weight predecode plus GEMMs was8.16%/8.57% forK3/K4. For2048 rows it was9.12%/9.13% (K3 medians7.3584→6.6870ms). Small sets still lose to the compressed path, so this is not a universal dispatch rule. Full raw timing observations are included.

These are isolated synthetic kernel results, not full-model or additional serving gains. Before model integration: captured55-group train/held-out coverage, padded-stride/guard tests, capacity/negative API cases, actual shape dispatch decisions, then finite full cold/warm/repeat independent accepted logits and80 greedy tokens, followed by balanced end-to-end timings. Existing serving remains on the peer-prefill build fromPR15.

## Captured-group shape replay

All55 captured groups passed contiguous and padded stride variants (110 cases), with bit-exact gate/up and down outputs compared against compressed FMA16 and the decoded path. Hidden/output padding, boundary/workspace guards, finite outputs, nonzero row0=29, gathered input and invalid API arguments were checked. Replay uses captured shapes/blob strides/counts with synthetic deterministic weights and activations, not captured model weights. The 27train/28held-out partition remains fixed.

440 interleaved timing observations include weight decoding and preparation. With the existing selector unchanged, only three captured groups are predecode-eligible: training group4 improved8.97%; held-out groups3/8 improved8.47%/8.97%. These are descriptive kernel medians, not full-model gains or independent-trial confidence intervals.

Build excluded HIP target `exl3_prepared_replay`, then run it with `docs/experiments/exl3-prepared-groups.txt` while inference is idle. The raw fixture and replay observations are included. Actual Maya run_set caps submitted pieces to C sorted routed rows; C2048 bounds the added input workspace to40MiB/main GPU. Full-model integration/parity/timing validation is a separate gate.
