# Explicit global reads for packed attention: operator checkpoint

This is a default-off prototype, based on `b49b20c`. It is **not enabled in
selected serving**. Full-model logit parity and end-to-end speed are untested.

With `DS4_HIP_ATTN_SWIZZLE=1`, set `DS4_HIP_ATTN_GLOBAL_READS=1` to select
explicit global-address-space reads of the window and packed-KV rows. Other
layouts and the few-query predecoded attention path retain their dispatch.
BF16 values, unpack arithmetic, FP32 operation order, softmax and LDS layout
are unchanged. No precision or chunk-size change is introduced.

## Specific source technique

[libr4d's BF16 GEMM](https://codeberg.org/StillDeadcode/libr4d/src/commit/a3e4833d29c3c7e6c36f43277ff9a7c9193950a3/r4d_gemm_bf16_nt_m64.hip)
uses address-space-qualified global pointers when generic pointers held in
arrays lose LLVM's address-space inference. Its notes describe gfx12 flat
loads affecting both load and LDS counters. Our selected packed-attention
ISA has this pattern after row pointers pass through an LDS table.

The prototype annotates these known-global reads, using scalar 64-bit pairs
because HIP vector structs do not accept an address-space-qualified source.
The compiler merges the pairs into 128-bit global loads. The G8 swizzled
kernel's 14 static flat-load sites become global loads; combined
loadcnt/dscnt wait sites fall 17→5. Both variants have the same object metadata:
88 VGPR, 33 SGPR, 19040-byte LDS, zero private storage and zero spills.
These are static object observations, not runtime stall or occupancy counters.

## Quick operator results

Nine cases cover steady/early prefill, ragged selected counts, window-only,
explicit row metadata, one query, one head and all 254 finite E4M3 scale codes.
Each tests head groups 1/2/4/8 and global reads off/on against G8 generic reads,
with the swizzled layout held on. All 288 comparisons pass exactly, including
finite outputs and output guards: 72 initial comparisons on GPU1, then 72 each
on GPUs 1/0/2. GPU1 is deliberately repeated.

Two warmups and eight timed samples per option use alternating forward/reverse
order. GPU-event times include the complete staging/unpack and attention
kernel. G8 median latency reductions are:

| GPU/run | Steady512 | Early512 |
| --- | ---: | ---: |
| R9700 GPU1 initial | 1.03% | 3.53% |
| R9700 GPU1 repeat | 1.37% | 3.22% |
| R9700 GPU0, also drives desktop | 3.83% | 3.84% |
| RX 9070 XT GPU2 | 1.65% | 3.95% |

These are short synthetic operator measurements, with repeated inputs and
different clock/display conditions. They do not establish model throughput
or decode gains. The approximately 1% steady-kernel gain is retained as a
candidate while larger targets from the current model profile are examined.
The validated serving executable remains unchanged.

## Reproduce

```sh
cmake --build build-hip --target ds4_attention_global_bench -j4
./build-hip/ds4_attention_global_bench 1
python3 docs/experiments/attention-global-checks/check.py
```

The included checker regrades saved logs, medians, ISA instructions and object
resource metadata. It does not execute the model or access a GPU. The operator
was compiled and linked directly with recorded SDK flags and verified archived
dependencies; the new explicit CMake target follows the existing layout-bench
recipe. Full-model and matched API checks are required before promotion.
