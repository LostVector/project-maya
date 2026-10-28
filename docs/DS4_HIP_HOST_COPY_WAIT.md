# Optional host wait for HIP expert-part reuse

`MAYA_DS4_HIP_HOST_COPY_WAIT=1` moves an expert part's reuse wait from its GPU copy stream to the device worker's host thread. Both modes wait for the previous consumer's `freed` event before a new DMA overwrites that part. Compute still waits for the new `filled` event. The default is off; native launches also accept `STRATA_DS4_HIP_HOST_COPY_WAIT` and `DS4_HIP_HOST_COPY_WAIT`.

Only the standard HIP batch-loader `copy_ahead` path changes. The flow loader and CUDA retain their existing scheduling. There are no fixed GPU IDs, model shapes or expert layouts. Arithmetic, expert batches, virtual slots, copy contents and accumulation order are unchanged. The host wait can reduce submission overlap, so it is a measured option rather than a general assumption that CPU synchronization is faster. It is not a driver-stall workaround.

## Ordering invariant

A wait on an event that has never been submitted does not wait for a future consumer. This path must therefore submit that old consumer and record its `freed` event first. The current streamer does so:

- `copy_ahead` queues only `cp < kp + P`, with P ring parts.
- Reuse means `cp >= P`, hence the old batch `cp - P < kp`.
- The consumer records `freed[half]` before incrementing `kp`, then calls `copy_ahead`.

The staging buffer's separate `filled` synchronization is retained: host writes cannot race its previous DMA. Return status from either wait is checked by the existing model error handling.

## Evidence

An earlier three-card EXL3 stack (two R9700s plus a 9070 XT, TP2/split36/4, frozen residency, packed host/FMA16/predecode/pruning) measured **0.880% lower warm 2048-token prefill latency**, six balanced blocks/24 trials, all blocks positive; block-based 95% interval 0.748–1.011%. Cold results were inconclusive and a single decode pair did not establish a gain. Warm/cold/repeat logits and 80 greedy tokens were exact against independent references; expert/RAM moves were zero. Raw receipts and protocol remain in [fork PR #13](https://github.com/LostVector/project-maya/pull/13).

That is historical evidence, not a current-upstream model measurement. The current v1.1.34 port retains the same event insertion point but has newer batching/staging around it. Before recommending it by default, repeat representative full-model comparisons, including normal caching and multi-GPU execution.

The standalone test exercises the actual production wait helper with two nonblocking streams and a four-part ring, in off/on/on/off order. It verifies 64 changing-length batches per arm against an independent integer CPU reference and checks the entire guarded output, including unwritten tails. The CPU staging and GPU slot lifetimes match the production constraints. It passes independently on two R9700s, totaling 512 batches. This is a ring-ordering test, not a full-model or multi-GPU peer test.

```sh
cmake --build build-hip --target maya-ds4 ds4_hip_copy_wait_test -j 4
HIP_VISIBLE_DEVICES=0 ./build-hip/ds4_hip_copy_wait_test
HIP_VISIBLE_DEVICES=1 ./build-hip/ds4_hip_copy_wait_test
```
