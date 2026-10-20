# Exact row-pair scheduling for HIP sparse attention

`DS4_ATTN_ROWPAIR=1` enables an experimental schedule for the packed-KV eight-head kernel. It computes two independent query/key row dot products before their original warp reductions. Every row retains its original FP32 multiply/add order, shuffle order, score scaling, softmax, and output accumulation. It adds no matrix instructions, precision changes, or global workspace. Other head-group sizes and the small-query scratch path retain their existing implementation. The default is off.

The kernel shares staging and softmax code with the original schedule through a compile-time parameter. Refactoring preserved the complete GPU instruction bytes for all four original head-group kernels and the validated paired kernel. Production and validation GPU text matched byte for byte; test counters are excluded from production.

## Evidence and limits

On gfx1201, the second R9700 showed a 2.9–3.7% attention-kernel gain across eight prefill-oriented shapes: heads 32/T512 and heads 64/T256, p0=0/1034, ratios 4/128, dimension 512, window 128, and selected-key cap 512. These match the tested model's geometry. All 64 balanced timing arms produced finite, bit-exact outputs. The existing KV stress suite also matched BF16 references, including ragged rows and all head-group sizes.

An ordinary unroll hint gave essentially no benefit; the existing four-head alternative was about 10–12% slower on the same card. GPU 0 is also used by desktop graphics clients and produced noisy short-kernel timings; that is a possible confounder, not established causality. All original observations remain in the research receipts.

The complete model test passed: cold 2069-token and warm 2048-token logits were finite and bit-exact across baseline/candidate/repeat and independent accepted engines, and all 80 greedy tokens matched. It exercised 8048 paired-kernel launches. The model remained unswapped at both endpoints of each timed trial, with zero model cache swaps/RAM moves.

**No whole-model speedup is established.** The full run had multi-second outliers in both modes: warm trial times ranged roughly 7.2–17.6 seconds, with the paired warm-gain interval spanning zero. The accepted local server was restored without enabling this option. Normal cache-promotion activity and a broader prompt distribution remain untested.

[Kernel raw times](../tests/fixtures/ds4_attention_schedule/gfx1201-kernel.json), [full-model raw times](../tests/fixtures/ds4_attention_schedule/gfx1201-model.json), and [alternative schedules](../tests/fixtures/ds4_attention_schedule/gfx1201-alternatives.json) retain every observation. Local model validation also included the separate skip-unpicked checkpoint (#1) plus packed-host, FMA16, and accepted weight-predecode settings. This stacked PR does not add #1.

## Reproduce

With HIP/tests enabled:

```sh
cmake --build build-hip --target ds4_gguf_test ds4_attention_pair_test
DS4_ATTN_ROWPAIR=1 HIP_VISIBLE_DEVICES=1 ./build-hip/ds4_gguf_test --kv
HIP_VISIBLE_DEVICES=1 ./build-hip/ds4_gguf_test --attn-schedule
```

The benchmark toggles the original/paired schedule, warms each arm for approximately 200ms, measures approximately 100ms with GPU events, and checks the complete output after every arm. Copies and environment changes are outside timed intervals. It uses bounded synthetic inputs; the separate KV suite covers broad exponents, zeros, and compressed-cache roundings.

The explicit full-model target takes `PACK_DIR OUTPUT_DIR`; it is excluded from default builds and CTest. Copy the code/database token fixtures and frozen profile from `tests/fixtures/ds4_packed_host`, and provide `engram-files.txt` containing the two absolute native Engram file paths. It requires the full 3.5bpw model, sufficient CPU RAM for experts, local Engram files, and three gfx1201 GPUs. It fixes TP2, split 36/4, context 262144, 16 Engram readers, packed-host/FMA16/weight-predecode, frozen expert placement, and balanced cold/warm timing blocks. `--selftest` checks the finite/bitwise verifier; `--check-existing DIR` checks saved cold outputs and greedy-token files.
