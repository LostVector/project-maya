# HIP packed-attention LDS vector layout

Experimental, default off. Set `DS4_HIP_ATTN_SWIZZLE=1` to select the new
layout in the packed-KV attention kernel. This checkpoint is based on
`d80bd83` and targets gfx1201.

Each 512-element BF16 row is staged as 64 sixteen-byte vectors. For logical
vector index `v`, its physical vector index becomes
`((v >> 2) | ((v & 3) << 4)) ^ ((v & 3) << 1)`. This is a bijection; the
eight BF16 elements inside each vector retain their order. Staging and both
consuming passes use the same mapping. The 16 KiB row tile, query/key order,
FP4 unpacking, FP32 FMA order, softmax tiles and reductions are unchanged.
The layout addresses the repeated LDS-bank aliasing in the original strided
vector access pattern. Runtime bank-conflict counters were not collected.

## Validation

Hardware: two Radeon AI PRO R9700 32 GB cards and one RX 9070 XT 16 GB.
Model: `LibertAIDAI/DeepSeek-V4.1-Flash-1017-EXL3-3.5bpw`, Maya pack,
RAM experts, TP2 plus tail, layer split 36/4, chunk cap 4096, context limit
262144. These checks use the existing experimental decoded-matrix and
whole-chunk-pruning configuration.

- Eight synthetic operator cases, head groups 1/2/4/8, flag off/on: all 192
  comparisons across the three GPUs are bit exact against the unswizzled G8
  output. All outputs are finite and both output guards are intact. Cases
  cover steady/early prefill, ragged selected-row counts, window-only input,
  explicit row metadata, one query and one head.
- Full-model layout off/on/off with pruning held on: all 195 candidate and
  195 repeat full-vocabulary states are bit exact. These are prefill plus 64
  teacher-forced continuation steps for 8K, 32K and a pruned 8K prefix plus
  512-token append. All 195 states also match the previously accepted 4K
  pruning-on references. All nine decoded responses match their expected
  JSON, with no model swap observed.
- Independent raw-byte and finite-value readback verified the four sets of
  snapshots. Portable checks retain the expected state hashes, fixture
  hashes, answer receipts and operator logs. Raw float snapshots are kept in
  the durable research artifacts rather than this repository.

The initial isolated R9700 operator screen used two warmups and eight timed
samples per option, alternating forward/reverse order. G8 steady-prefill
median GPU time fell from **7.6373 ms to 3.3209 ms (2.30x)**. This is a short
synthetic kernel measurement. It does not establish an end-to-end prefill
gain. A separate frozen four-fresh-load ABBA API experiment is in progress;
this flag has not been promoted to serving.

The selected matrix configuration already has documented cross-cap logit
drift. This experiment holds the cap and arithmetic fixed and requires
strict within-cap equality. These three fixtures are limited quality
evidence, including continuation states beyond EOS.

## Reproduce

With the normal HIP build configured, build the explicit targets:

```sh
cmake --build build-hip --target ds4_attention_layout_bench ds4_attention_model_test -j4
./build-hip/ds4_attention_layout_bench 1
python3 docs/experiments/attention-lds-checks/check.py
```

The model test requires exclusive access to the three GPUs and enough RAM
for the model. Copy the files from `docs/experiments/attention-lds-checks/`
into a writable output directory, then run:

```sh
DS4_YOCO_TEST_MATRIX=1 DS4_YOCO_TEST_PERF=0 \
DS4_YOCO_WHOLE_CHUNKS=1 DS4_YOCO_TEST_PREFIX_PRUNED=1 \
HIP_VISIBLE_DEVICES=0,1,2 \
./build-hip/ds4_attention_model_test /path/to/maya-pack /path/to/output 4096 64
python3 docs/experiments/attention-lds-checks/check.py --raw-dir /path/to/output
```

The model test asserts candidate/repeat byte equality directly. The Python
raw check also compares all 585 generated snapshots against the 195 stored
independent-reference hashes. Exact reproduction depends on the same model,
frozen profile, configuration and compatible GPU/toolchain. The default
Python check only regrades the included receipts and timing medians; it does
not execute the model or prove missing raw snapshots.
