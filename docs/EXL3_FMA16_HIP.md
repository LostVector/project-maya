# Experimental sixteen-token HIP EXL3 FMA tiles

`DS4_EXL3_FMA16=1` selects a sixteen-token tile for grouped expert gate/up and down kernels on HIP. It is off by default. The existing eight-token implementation, dense kernels and decode kernels remain available unchanged. This builds on the portable HIP EXL3 implementation in `EXL3_HIP.md`.

Each warp prepares up to two activation rows. A compressed weight tile is decoded once and multiplied against up to sixteen routed rows. This uses ordinary FP32 FMAs; each output retains the eight-token path's FMA order, four-lane reduction, Hadamard transforms, scaling and FP16 rounding. No expanded-weight cache or additional expert VRAM is allocated.

## Validation on 2026-10-20

Hardware: two Radeon AI PRO R9700 32 GB cards plus an RX 9070 XT 16 GB; ROCm 7.14.1, gfx1201. Model: LibertAIDAI/DeepSeek-V4.1-Flash-1017-EXL3-3.5bpw. Serving uses TP2 across the R9700s, layer split 36/4, 2K prefill chunks, context 262144, explicit expert RAM and 2048 MiB GPU reserve.

`EXL3_SET_ONLY=1 ./exl3_test` compares both paths against the scalar CPU reference for all 24 K/codebook combinations. All intermediate FP16 gate values and FP32 expert outputs matched bit-for-bit. Additional tails 1/8/9/15/16/17/31/32/33, an empty expert and a nonzero routing offset also passed: 33 cases, zero failures or launch errors.

`EXL3_SET_BENCH=1 ./exl3_test` measures model-shaped E=5120/F=1152 expert sets with 37/0/70 routed rows. After 2000 warm-up iterations, eight balanced arms of 200 timed iterations gave:

| Quant bits | Eight-token mean | Sixteen-token mean | Reduction |
| --- | ---: | ---: | ---: |
| 2 | 0.746 ms | 0.706 ms | 5.4% |
| 3 | 0.757 ms | 0.708 ms | 6.5% |
| 4 | 0.718 ms | 0.714 ms | 0.5% |

These microkernel figures do not predict whole-model gains. The K3 gate/up kernel uses 195 VGPRs and 25,344 bytes LDS, versus 147 VGPRs and 13,056 bytes for the eight-token build; neither spills.

A single loaded model with frozen expert placement was tested in order 8/16/8 for parity and 8/16/16/8 for timings. All 2069 x 129280 logits were finite and bit-exact, including the repeat control and an independent saved output from the original engine. All 80 greedy tokens matched. Expert swaps and RAM moves were zero; GPU expert counts remained 3469/3469/695.

| Full-model screen | Eight-token mean | Sixteen-token mean |
| --- | ---: | ---: |
| Cold varied-code prefill, 2069 tokens | 14.448 s | 14.445 s |
| Warm database prefill, 2048 tokens | 8.230 s | 7.688 s |
| 64 timed decode tokens after warm-up | 5.069 s | 5.064 s |

Warm prefill improved 6.6%. Cold results were noisy (candidate arms 13.91 and 14.98 seconds) and establish no cold-prefill gain. Decode was unchanged. These are bounded two-prompt screens, not long-context or broad-workload performance claims. Cache placement and token arithmetic boundaries must stay fixed when comparing logits.

The validation harness's temporary cache-reset API is excluded from this checkpoint. Raw logits, source snapshots, commands, profiles and receipts are retained under `/home/rkuo/research/llm-weight-compression/_meta/maya-fma16-20261020` on the test host. Production uses the same GPU machine code as the validated harness.
