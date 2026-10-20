# Reference math windows with coalesced expert transfers

This builds on the opt-in HIP experiment in `DS4_GEMM_TILING.md`. `DS4_GEMM_TILE_2K=1` now derives the same balanced <=2048-token math windows that the reference chunk planner would use for each feed, then coalesces whole windows into expert chunks up to the configured `--prefill-chunk`. The flag remains off by default.

Dense BLAS calls, mHC mixes, attention/indexer slabs and Engram projection batches retain the reference window boundaries. Compressed-key projection batches count the groups actually completed at each boundary, including odd window lengths and nonzero starting positions.

Expert arithmetic needs its own boundary preservation. `run_set` subdivides expert sets by routed-row capacity, and `moe_combine` adds contributions in rank order within each subdivision. Increasing the token count can change those subdivisions and therefore the floating-point addition order. The implementation sorts and combines each math window separately while keeping the streamed expert batch resident for all windows. It reuses the existing GPU bounds and routed-row buffers, with a small pinned host bounds table. No expert decoder or matrix arithmetic kernel changes are included.

## Validation

Same loaded model, fixed expert placement, 8192-token buffer allocation, reference/candidate/reference order:

| Text | New tokens | Prefix tokens | Result |
| --- | ---: | ---: | --- |
| Database prose | 8192 | 0 | Every logit bit-identical |
| Python code | 2067 | 17 | Every logit bit-identical |
| Narrative prose | 4160 | 1 | Every logit bit-identical |
| Python code, multiple expert chunks | 10000 | 0 | Every logit bit-identical |

All 24,419 positions x 129,280 vocabulary entries were finite and bit-identical; all repeated references were bit-identical. Cache promotions were prevented with `DS4_CACHE_BONUS=1e30` while retaining initial cache allocation; the harness verified zero swaps and RAM moves. This is a numerical experiment setting, not a serving recommendation.

Hardware/model: DeepSeek-V4.1-Flash-1017 EXL3 3.5bpw, portable HIP support, two 32GB R9700 cards in TP2 plus one 16GB gfx1201 card, split 36/4, explicit RAM experts, vision and DSpark disabled, 256K context, ROCm 7.14.1. Transfer pruning was enabled. The EXL3 kernel source retained SHA-256 `5e7d710a61b8a50b6cd88c64b7abe123543af830d7f89ac2b0cec3cb534cad2a`.

`ds4_math_windows_test` passes 2160 CPU scheduling cases, including larger capacities, odd compressed-group boundaries, offsets and slab limits. The reproducer and input generator compile/run; generated inputs match the measured token files byte-for-byte.

An initial attempt preserving only dense/slab windows passed the two shorter cases but failed the 8K and 10K gates. Preserving expert combine groups removed those failures. The prior checkpoint's performance measurements do not establish the speed of this revision.

## Reproduction

Build `maya-ds4` with portable HIP EXL3 support and the Unix Makefiles generator. Generate inputs with:

```sh
python bench/micro/make_ds4_math_inputs.py MODEL/tokenizer.json OUTPUT_DIRECTORY
```

Copy the initial expert profile to `OUTPUT_DIRECTORY/frozen-profile.bin`, preserving a separate copy because shutdown writes it back. Compile `bench/micro/ds4_math_windows.cpp` with `-Isrc/ds4` and link it using the engine-object procedure in `DS4_GEMM_TILING.md`, replacing the CLI main with this reproducer's object. Run the executable with `PACK OUTPUT_DIRECTORY`, under `HIP_VISIBLE_DEVICES=0,1,2`, `DS4_SPLIT=36,4`, and `DS4_SKIP_UNPICKED=1`. It requires the model's full memory allocation and roughly 38GB output space. Stop any existing model server first.

For each case, compare `<case>-0.f32` (reference), `-1.f32` (candidate) and `-2.f32` (repeat) as float32 arrays of the token count above x 129280. This checkpoint requires all values finite and bit equality. The reference feeds balanced <=2K windows sequentially; the candidate feeds the whole prompt. Both retain the same 8K allocation and cache placement.

## Remaining gates

This is a draft research checkpoint. It has not been deployed. Measure this revised scheduling path, compare complete 2K versus larger-buffer configurations, and check short prompts, ordinary endpoint/greedy continuation and decode before enabling it in the server. Same-allocation parity does not prove parity across different cache placements or buffer budgets. Validation here covers the RAM EXL3 non-flow path on the listed hardware; other models/backends are unvalidated.

Durable local receipts: `/home/rkuo/research/llm-weight-compression/_meta/maya-expert-math-windows-20261020`. The failed initial attempt is in sibling `maya-math-windows-20261020`. Protocols, token IDs, profiles, full logits, binaries and source hashes are retained there.
