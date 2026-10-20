# Experimental HIP dense GEMM tiling

`DS4_GEMM_TILE_2K=1` caps dense prompt BLAS calls at 2048 rows while allowing a larger `--prefill-chunk`. It is off by default and has no effect on CUDA builds. It does not enable matrix instructions in the EXL3 expert kernels.

The reconstructed dense weights are reused across row tiles. The same cap applies to F16-weight projections and F32 mHC mixes. Compressed index-key projections use `2048 / compression_ratio` rows per call. Leading dimensions, output offsets, beta, weight reconstruction, expert arithmetic, routing and virtual slots retain their existing meaning.

## Why this exists

On gfx1201 with ROCm 7.14.1, a synthetic FP16 query-projection GEMM with output width 1280 and reduction width 5120 produced different results for 2048 versus 4096 activation rows: the first 64 rows were identical, then differences appeared. In a full-model trace, the first difference likewise appeared at row 64 after layer 0 attention and amplified through later layers. The normal endpoint and all-row diagnostics agreed; this was not just a logit-export issue.

Holding dense calls to the reference shapes removed the observed full-model mismatch in the aligned 4K experiment below. This does not establish a guarantee for arbitrary batch shapes or hardware.

## Checkpoint evidence and limits

Test setup: DeepSeek-V4.1-Flash-1017 EXL3 3.5bpw; two R9700 32GB cards plus a 16GB gfx1201 card; TP2 on the R9700 pair; layer split 36/4; experts explicitly resident in RAM; 256K context; 8192-token buffer allocation. Portable HIP EXL3 support and skip-unpicked transfers were enabled. Those are separate fork PRs #2 and #1.

Same loaded model and initial expert placement, reset between passes:

- Reference: two 2048-token feed calls, flag off.
- Candidate: one 4096-token feed call, flag on.
- All 4096 × 129280 float32 logits were bit-identical. A repeated reference was bit-identical, and the reference matched the previous binary exactly.
- No expert-kernel arithmetic changes; the portable EXL3 source hash remained `5e7d710a61b8a50b6cd88c64b7abe123543af830d7f89ac2b0cec3cb534cad2a`.

Timing measurements and raw validation receipts are recorded in the PR. This is an experimental checkpoint, not a production default change.

**Remaining gates:** full-model 8K parity; varied prompts, cached-prefix positions and ragged lengths; comparison of complete 2K versus larger-buffer configurations; stable repeated timing including short prompts and decode. Maya balances internal chunks for ragged lengths, so a fixed 2K BLAS cap does not generally reproduce those reference batch shapes. No claim of strict parity is made outside the measured aligned case.

The original diagnostic run with greedy generation allowed expert-cache promotions and failed its repeat controls. A subsequent diagnostic run froze cache movement and repeated both endpoints exactly. Generation agreement alone was not used to waive the logit gate.

Local durable receipts: `/home/rkuo/research/llm-weight-compression/_meta/maya-exl3-tiled-gemm-20261020` and `../maya-exl3-chunk-parity-20261020`. They include protocols, input IDs, expert placement, raw logits, source snapshots, binaries, build commands and hashes. No model weights or large raw arrays belong in this repository.

## Reproducing this checkpoint

`bench/micro/ds4_chunk_tiles.cpp` is the exact same-instance harness used for this checkpoint. It deliberately uses the hardware settings above. It accepts `PACK SEED_IDS_JSON OUTPUT_DIR`; the seed must contain 512 token IDs, and `OUTPUT_DIR/frozen-profile.bin` must hold the initial expert profile. Preserve an independent copy because model shutdown updates the profile. The harness writes three 4096-row logit arrays and then prints ABBA prompt timings. It requires roughly 6 GB of output disk space plus the model's RAM/VRAM allocation. Stop an existing model server before running it.

After building `maya-ds4` with the Unix Makefiles generator, link the harness against that build's engine objects:

```sh
c++ -O3 -std=c++20 -Isrc/ds4 -c bench/micro/ds4_chunk_tiles.cpp -o /tmp/ds4_chunk_tiles.o
python3 - BUILD_DIRECTORY <<'PYBUILD'
import pathlib, shlex, subprocess, sys
build = pathlib.Path(sys.argv[1]).resolve()
cmd = shlex.split((build / 'CMakeFiles/maya-ds4.dir/link.txt').read_text())
assert sum(x.endswith('ds4_main.cpp.o') for x in cmd) == 1
cmd = ['/tmp/ds4_chunk_tiles.o' if x.endswith('ds4_main.cpp.o') else x for x in cmd]
cmd[cmd.index('-o') + 1] = '/tmp/ds4_chunk_tiles'
subprocess.run(cmd, cwd=build, check=True)
PYBUILD
```

Run with the same `HIP_VISIBLE_DEVICES=0,1,2`, `DS4_SPLIT=36,4` and `DS4_SKIP_UNPICKED=1` environment used above. Compare `split.f32`, `whole.f32` and `split-repeat.f32` as float32 arrays; the checkpoint criterion was bit equality for all three, with all values finite. The 8K measurements are timing only and do not establish 8K logit parity.
