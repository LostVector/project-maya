# Opt-in HIP host wait for expert-part reuse

`DS4_HIP_HOST_COPY_WAIT=1` replaces the copy queue's wait for an expert part's `freed` event with a blocking wait on that device worker's host thread. The default is disabled. Only the standard HIP `copy_ahead` path changes; the flow path and CUDA keep their original scheduling.

The reused part is still waited on before its next DMA, and compute still waits for the corresponding `filled` event. Expert batches, buffer layout, arithmetic, and accumulation order are unchanged. In the streamer invariant, a new part copy satisfies `cp - P < kp`: its previous consumer and `freed` event have already been submitted before this wait. The host wait may reduce submission overlap; it is a measured option, not an assumption that CPU synchronization is generally faster.

The hypothesis follows [ROCm/TheRock#9297](https://github.com/ROCm/TheRock/issues/9297), [vLLM#58639](https://github.com/vllm-project/vllm/issues/58639), and our standalone [pending-wait checkpoint](https://github.com/LostVector/project-maya/pull/12). This change does not set a hardware queue limit or establish that the same mechanism explains earlier long-kernel stalls.

## Fixed-workload measurement

Two R9700 32GB cards plus an RX9070XT 16GB, EXL3 3.5bpw DeepSeek-V4.1-Flash-1017, TP2/split36/4, 256K context, FMA16/packed-host/predecode and skip-unpicked enabled. The cache profile is fixed and Engram readers remain 16. The local measured stack includes PR #1 in addition to this branch's PR #10 base; this PR does not duplicate PR #1. A broader prompt distribution and normal cache-promotion activity remain untested.

| Workload | Result |
|---|---|
| Warm 2,048 tokens, 24 trials | Median 7518.923 -> 7458.083 ms; six balanced blocks all positive |
| Warm block gain | Mean 0.8796%; two-sided 95% Student-t interval 0.7483–1.0108%, df5 |
| Cold 2,069 tokens, eight trials | Mean block gain 0.429%; interval −16.828–17.686%, df1; no gain established |
| Decode 64 tokens after 16 warm tokens | 12.277 vs12.299 tokens/s in one pair; no speedup claim |
| Correctness | Full cold and warm logits finite and bit-exact across modes/repeat and independent accepted references; all 80 greedy tokens exact |
| Resource/control checks | Identical EXL3 GPU code, no extra GPU workspace, zero per-trial model swap, zero cache swaps/RAM moves; actual host-wait calls positive only in candidate feeds |

[Every raw timing and summary](../tests/fixtures/ds4_hip_copy_wait/gfx1201-confirmation.json) is retained, including both cold blocks and their differing signs. Small repeatable gains count; no arbitrary 5% threshold is used. The interval measures repeatability within this fixed workload, not general production benefit or resolution of earlier latency spikes.

## Dedicated validation

Build `ds4_hip_copy_wait_test` explicitly with HIP/tests enabled; it is excluded from the ordinary build. `--selftest` checks the finite/bit-exact verifier, including one-bit changes, signed zero, NaNs and infinities. The model test takes `<pack> <output-root>` and requires the canonical `code-ids.json`, `database-ids.json`, `frozen-profile.bin` from `tests/fixtures/ds4_packed_host`, plus `engram-files.txt` containing the two native Engram safetensor paths (47/48 for the tested pack).

The test fixes all baseline flags, toggles the real production option, runs full cold/warm parity, eight cold and 24 warm ABBA/BAAB trials, and 80-token generation. Test-only atomic counters verify the changed path. `--check-existing <output-root>` independently rechecks saved cold files and token sequences. Those checks cover within-run equivalence; independent accepted full-reference comparisons were also performed for the retained result. Production builds contain no test counter or getter.

Do not run the full model alongside another loaded instance: this configuration uses most system RAM. The test's cache/prompt controls are part of its protocol and must not be silently replaced by a different serving setup. Keep all observations and restore the accepted configuration if broader validation regresses.
