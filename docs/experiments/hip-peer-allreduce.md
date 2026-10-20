# Experimental exact HIP peer all-reduce

Adds a standalone two-rank F32 collective and an excluded-by-default test target. No model dispatch or serving configuration changes.

The implementation pushes into fine-grained peer VRAM, publishes per-block completion flags, and adds values in the existing rank order using explicit round-to-nearest F32 addition. Both ranks must use matching ordered calls on their respective single streams. Two slots protect receive data under that contract. Frozen host sequence numbers cannot be replayed in a graph. Callers must check the sticky timeout error before accepting output.

## Validation

The identical kernel/header/test sources were tested on two gfx1201 R9700s under ROCm 7.14.1 with GPU_MAX_HW_QUEUES unset. The model remained resident and idle. 256 chained calls matched the existing collective bit for bit over varying sizes, including signed zero, finite extremes, subnormals, sequence wrap, guards, and staggered rank submission. Missing-peer timeout detection passed. Every timing output was checked.

20 measured repetitions per method/size, alternating method order, plus two warmups:

| Payload per rank | Existing host staging median | Peer median | Median speedup |
|---|---:|---:|---:|
| 20 KiB | 0.039775 ms | 0.037260 ms | 1.07x (inconclusive) |
| 320 KiB | 0.135590 ms | 0.074846 ms | 1.81x |
| 40 MiB | 10.048552 ms | 1.756672 ms | 5.72x |

These are isolated collective results, not inference speedups or full-model parity evidence. The measured local stack contains additional accepted transfer-pruning/RAM-slice work; this PR carries only the standalone collective.

Build the excluded target `ds4_peer_allreduce_test` in a HIP test build and run with HIP_VISIBLE_DEVICES=0,1. The test allocates scratch on both GPUs and should run while inference is idle. The checked-in receipt includes every raw timing observation.

## Before model integration

Require bidirectional peer capability, all-or-nothing allocation with host fallback, scratch allocation after expert cache placement, and request-level sticky-error propagation/recovery. Keep the third GPU pipeline transport unchanged. Validate full cold/warm/repeated logits against the independent accepted baseline and 80 greedy tokens, then measure balanced end-to-end trials before enabling.

Inspired by the transport design in [Radiance](https://github.com/magiccodingman/vllm-radiance/blob/main/radiance_allreduce.py); this kernel preserves Maya F32 rank-order arithmetic.
