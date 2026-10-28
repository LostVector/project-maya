# Optional temporary EXL3 fragment reuse on HIP

Busy expert batches repeatedly unpack the same compressed weight tiles. This path first expands their exact FP16 codebook fragments into temporary VRAM, then reuses those fragments in 16-row scalar gate/up and down kernels. It preserves the current DOT2 arithmetic order, four-lane reduction, rotations, scales and output rounding. It does not use matrix instructions or alter routing or quantization.

It is off by default. Serving-config `env` accepts:

| Setting | Default | Meaning |
| --- | --- | --- |
| `MAYA_DS4_EXL3_PREDECODE` | `0` | `1`: enable on eligible gfx12 prompt batches |
| `MAYA_DS4_EXL3_PREDECODE_MIB` | `128` | maximum workspace per eligible device, reserved at startup after expert placement; `0` disables it; at most 4096 MiB |
| `MAYA_DS4_EXL3_PREDECODE_MIN_ROWS` | `512` | minimum maximum routed rows in an expert batch |
| `MAYA_DS4_EXL3_PREDECODE_MIN_TOTAL_ROWS` | `768` | minimum total routed rows in that batch |

Native launches accept `STRATA_DS4_*` and `DS4_*` aliases. Row thresholds accept nonnegative integers through INT_MAX; malformed/overflowing limits retain their documented defaults. Settings are read at load and require reload to change. No FFN width, expert-slot count, visible GPU ID or TP arrangement is hard-coded.

The startup scan selects only devices holding eligible uniform EXL3 trunk layers. It allocates after the expert cache, without removing experts to make room. Unsupported devices, matrix-selected devices, zero budgets and allocation failure keep the existing compressed path. Each batch must fit the workspace and satisfy both row thresholds. Mixed layouts and unsupported formats retain their existing path. Groups below the thresholds are deliberately excluded: expansion is more expensive than repeated decoding there. Decode and MTP verification keep their existing kernels.

The fragment array needs `6 * n_exp * n_embd * n_ff` bytes: 101.25 MiB for 3 slots at D=5120/F=1152. With the default budget, each selected GPU reserves 128 MiB, so four such slots do not fit and use compressed tiles. The source and scratch remain valid through their compute-stream work. Every selected batch is expanded anew; this is temporary workspace, not a persistent expert cache. Allocation is not performed during a request.

## APIs and tests

`decoded_set_bytes`, `decode_set`, `set_gate_up_decoded` and `set_down_decoded` expose the fragment path. They use the existing `SetArgs` contract. Sizing rejects mixed/unsupported layouts and overflow; execution requires valid source/bounds/buffers and stream lifetime, and returns false on non-HIP backends. The model integration is restricted to gfx12; other HIP architectures have not been hardware-validated.

```sh
cmake --build build-hip --target exl3_test maya-ds4 -j 4
HIP_VISIBLE_DEVICES=0 EXL3_WMMA=0 ./build-hip/exl3_test --hip-predecode
HIP_VISIBLE_DEVICES=0 EXL3_WMMA=0 ./build-hip/exl3_test --hip-predecode-bench
```

The GPU test keeps the existing CPU-reference tolerances and compares FP16 intermediate and FP32 output bytes, including guards, to the current compressed path. It covers all integer bitrates/codebooks, supported half-integer codes, different gate/up and down formats, empty experts, nonzero row bases, tails, null scratch, mixed rejection and size overflow. The optional benchmark times expansion plus both computations together. It uses generated weights, three slots (one empty), D=5120/F=1152 and balanced ABBA/BAAB order; these are operator results, not full-model throughput.

## Evidence and limitations

On the current v1.1.34 kernel base (`249f9a8`), the large synthetic batches (512/0/1024 rows) took 21–26% less time including expansion, against the current compressed eight-row implementation. Small batches (32/0/64) took 28–44% more time. The comparison also changes the compute tile width to 16; it does not isolate decompression savings alone, and it has not been compared against the separate configurable scalar-tile PR. Public operator parity passed on two R9700s.

Earlier full-model tests of the old FMA implementation on two R9700s plus a 9070 XT measured **1.447% lower warm 2048-token prefill latency**, all six balanced blocks positive, 95% interval 1.313–1.581%. Cold performance was effectively tied and no decode gain was established. Those tests used fixed residency, an FF1152/three-slot selector, and 101.25 MiB scratch per main GPU. Cold/warm/repeated logits and 80 greedy tokens were exact. That historical result does not establish the effect of this new DOT2 port or its general selector/startup-allocation policy. See the archived [fork PR #9](https://github.com/LostVector/project-maya/pull/9) and [serving integration #10](https://github.com/LostVector/project-maya/pull/10).

Before a default recommendation: measure actual selector coverage and expansion-inclusive full-model time on current upstream, test startup allocation failure/budget paths with real packs, verify request-level parity with fixed placement, and compare interactions with scalar tiles, normal adaptive caching and MTP. Defaults remain off; the current serving engine has not been replaced.
