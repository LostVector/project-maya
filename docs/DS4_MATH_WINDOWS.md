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

## Serving-configuration benchmark: candidate rejected

Fresh measurements of this revision use warmed, fixed-placement runs with endpoint files flushed before prefill timing. The full 2K configuration submits the 8K prompt in one feed, retaining its internal chunk pipeline. The 8K candidate coalesces reference windows. Model inputs and initial profile are shared across sequential loads; this is not an interleaved cross-load timing trial.

| Prompt | Full 2K configuration | Full 8K candidate |
| --- | ---: | ---: |
| 8192 tokens | 26.48 s mean, four runs | 28.81 s mean, two runs |
| 1024 tokens | 5.311 s mean, four runs | 5.482 s mean, two runs |

The 8K candidate was ~8.8% slower on the long prompt and ~3.2% slower on the short prompt. Single-pass decode screening after 8K context was ~17.7 tokens/s in both configurations. These decode samples are not a controlled steady-state throughput claim.

Within the 8K allocation, ordinary endpoint logits remained bit-identical and all 80 greedy tokens agreed. Across 2K/8K allocations, all three tested endpoints failed the strict logit gate (max abs 2.84–4.67, relative L2 0.125–0.156), despite matching top-1 and greedy continuations. The candidate loses ~4GB of expert VRAM across the three GPUs: cached expert counts changed from 3469/3469/695 to 3294/3294/620.

The serial-reference comparison in the 8K allocation was 32.01 s versus 28.81 s candidate, but separate reference feeds prevent the original cross-group chunk pipeline. **That comparison does not isolate transfer reuse and does not establish a serving speedup.** The earlier timing in the first checkpoint should likewise not be interpreted as a production gain. The complete configuration results above take precedence.

Do not enable the 8K candidate. The baseline remains deployed. Further work must preserve the actual reference cache budget and expert subdivision capacity, retain pipeline overlap and pass cross-configuration parity, or pursue an optimization that leaves those properties intact.

`bench/micro/ds4_window_bench.cpp` is the measured timing harness. It accepts `PACK OUTPUT_DIRECTORY CAPACITY` (2048 or 8192). Prepare `8k-ids.json` and `ragged-offset-ids.json` using the input generator, plus independent identical initial profiles at `2048/frozen-profile.bin` and `8192/frozen-profile.bin`. It disables path picking to force chunks and freezes promotions; it saves endpoint/greedy files before warmed ABBA prefill timing. Link it against the engine objects using the earlier reproducer procedure. Durably archived commands/results: `/home/rkuo/research/llm-weight-compression/_meta/maya-window-bench-20261020`.
