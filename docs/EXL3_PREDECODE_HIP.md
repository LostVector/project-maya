# Temporary exact EXL3 fragments on HIP

Large expert groups repeatedly decode the same trellis fragments in each 16-row CTA. The experimental `decode_set` API expands those exact FP16 fragment words once per expert set. `set_gate_up_decoded` and `set_down_decoded` reuse them with the existing Hadamard transforms, scales, ordered FP32 FMAs, and reductions. This is an arithmetic-preserving alternative to repeated trellis decoding; it does not introduce matrix instructions.

Set `DS4_EXL3_PREDECODE=1` to enable the same selector in serving. The default remains disabled. The dedicated `ds4_predecode_test` target toggles this production flag for comparisons. Its selector uses FF=1152, at most three slots, at least 768 total rows, and at least 512 rows in the largest expert. Other groups use the accepted compressed FMA16 kernels. This selector leaves GPU2 on the compressed path for the tested TP2/split36/4 setup.

## API and memory

Allocate `decoded_set_bytes(args)` bytes and call, in the same stream:

1. `decode_set(args, scratch, stream)`;
2. `set_gate_up_decoded(args, scratch, x, ldx, row_idx, h, ldh, stream)`;
3. `set_down_decoded(args, scratch, h, ldh, y, ldy, stream)`.

The scratch and source blobs/bounds must remain valid until the stream finishes. Recreate the fragments when the source set changes. Empty slots are skipped by the decoder and output kernels, but still count toward allocation size. The scratch stores decoded codebook fragments before transforms/scales, not fully reconstructed model weights.

Scratch size is `6 * n_exp * n_embd * n_ff` bytes. Three slots at D=5120/F=1152 require 106,168,320 bytes (101.25 MiB) per TP device. This is temporary workspace, not a persistent expanded-weight cache. The experiment allocates it after the expert cache so that both timing modes retain identical cache placement. Allow sufficient reserved VRAM.

Execution requires HIP and native EXL3 format with dimensions divisible by 128. The execution APIs return false on other backends. Caller-provided offsets, strides, bounds, and allocation sizes follow the existing expert-set contract.

## Reproduce

With HIP and tests enabled:

```sh
cmake --build build-hip --target exl3_test ds4_predecode_test
EXL3_SET_ONLY=1 HIP_VISIBLE_DEVICES=0 ./build-hip/exl3_test
EXL3_PREDECODE_BENCH=1 HIP_VISIBLE_DEVICES=0 ./build-hip/exl3_test
```

The set tests cover all 24 K/codebook combinations and 33 total CPU-reference/ragged/empty/nonzero-row0 cases, comparing both gate output and final output bitwise to the original eight-row path. The synthetic benchmark compares compressed FMA16, expansion plus decoded math, and math-only with expansion excluded. Only the expansion-inclusive mode represents a usable speedup. Small groups regress and must retain compressed dispatch.

The full-model test takes `PACK_DIR OUTPUT_DIR`. Copy `code-ids.json`, `database-ids.json`, and `frozen-profile.bin` from `tests/fixtures/ds4_packed_host` to the output directory. Supply `engram-files.txt` containing the two absolute native Engram file paths. This test needs the full model, three gfx1201 GPUs, sufficient CPU RAM for experts, and local Engram files. It is excluded from default builds and CTest.

The test fixes TP2, split 36/4, context 262144, explicit expert RAM, packed host slots, FMA16, a 16-reader Engram pool, and frozen expert placement. Local performance validation also included the separate skip-unpicked checkpoint ([#1](https://github.com/LostVector/project-maya/pull/1)). That dependency is not added to this stacked PR. It checks full cold and warm logits against baseline/candidate/repeat, finite values, and 80 greedy tokens; then times 24 warm and eight cold trials in alternating ABBA/BAAB blocks. The scratch is primed before both timing modes.

Two prompt fixtures and frozen cache placement do not establish a general speedup across prompts or normal cache-promotion activity. Keep this path optional pending broader validation. Set `DS4_PREDECODE_VALIDATE_ONLY=1` to run the full parity and generation checks while skipping the timing blocks.

## Fixed-workload confirmation

On two Radeon AI PRO R9700 32GB cards plus a Radeon RX9070XT16GB, with the 3.5bpw DeepSeek-V4.1-Flash-1017 quant:

| Workload | Result |
| --- | --- |
| Warm prompt, 2,048 tokens | Median 7333.736 -> 7224.592 ms; 279.3 -> 283.5 tokens/s |
| Warm balanced blocks | All six improved; mean gain 1.447%; two-sided 95% Student-t interval 1.313–1.581% (df5) |
| Cold code prompt, 2,069 tokens | Median gain 0.055%; effectively tied |
| 64 decode tokens after 16 warmup tokens | 12.709 vs12.653 tokens/s in one comparison; no decode speedup claim |
| Numerical checks | Full warm and cold logits finite and bit-exact across modes/repeat and independent accepted engines; 80 greedy tokens exact |

[Raw per-trial times and summary](../tests/fixtures/ds4_predecode/gfx1201-confirmation.json) preserve all observations, including outliers. The confidence interval describes repeatability within this fixed workload. Global swap counters changed across loading, testing and restoration; there was no per-trial swap attribution. Normal cache-promotion activity and a broader prompt distribution remain untested. This is a small measured warm-prefill gain, not the 18–31% seen in large-shape synthetic kernels, and does not change the production default. The serving integration uses the same selector, fragment APIs, and scratch size; it allocates workspace on the first eligible dispatch and reports its size to stderr. Allocation failure returns the normal model-allocation error; reserve enough VRAM for the workspace.
