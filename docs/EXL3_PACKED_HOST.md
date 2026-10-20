# Opt-in startup-packed EXL3 host weights

`DS4_EXL3_PACKED_HOST=1` stores resident CPU-lane experts as consecutive GPU-ready member blobs. Streaming one member then needs one contiguous H2D copy instead of nine small/strided copies. Packing happens once during loading and when a cache demotion writes a host slot. No per-request CPU packing or GPU gather kernel is used.

The flag is off by default. The prototype applies only to native EXL3, explicit resident host storage, one NUMA part and uniform TP2 with 128-aligned FFN partitions. Unsupported layouts retain the original representation. RAM availability is checked before using the larger stride. GPU allocation, quantization, chunk size and expert placement are unchanged.

CPU fallback reads column views of gate/up and consecutive input views of down. It keeps the original global split-K chunks, FP32 accumulation and final reduction order. It does not combine independently reduced half outputs. The cache's blob/host conversion helpers also handle packed slots; DS4_CHECK_SWAPS compares logical weight bytes through the full-blob view.

## Validation on 2026-10-20

Model: LibertAIDAI/DeepSeek-V4.1-Flash-1017-EXL3-3.5bpw. Hardware: two R9700 32GB cards plus an RX9070XT 16GB, Ryzen9950X, ROCm7.14.1/gfx1201. FMA16 enabled, split36/4, TP2, 2K chunks, context262144, reserve2048MiB and explicit expert RAM.

* GPU EXL3 machine code matches the accepted FMA16 build byte-for-byte.
* Actual CPU expert outputs match bit-for-bit in108 cases: every TP2 layer, with1/3/8 activations, AVX512 tier. Outputs are finite.
* Every layout change round-trips all10355 TP2 host experts through the original full-blob representation and checks all reconstructed bytes. No second full weight copy is retained; scratch is bounded per loader. Duplicated scales cost318.1MB across those experts, plus spare slots.
* All2069x129280 logits are finite and bit-exact against control, reference repeat and independently saved accepted-engine output. All80 greedy tokens match. GPU expert counts remain3469/3469/695. Expert swaps and RAM moves are zero in the frozen-placement timing protocol.

| Screen | Original host layout | Startup-packed layout |
| --- | ---: | ---: |
| Cold varied-code prefill,2069 tokens | 13.982s | 12.097s |
| Warm database prefill,2048 tokens | 7.686s | 7.345s |
| 64 timed decode tokens | 5.065s | 5.037s |

Cold prefill improves13.5%; warm prefill improves4.4%. Decode is effectively unchanged. Physical disk reads and read calls are unchanged; the gain comes from streaming the expert bytes. These are bounded paired screens, not long-context or broad-workload results.

One loaded model is converted between layouts outside timing, with identical enlarged host-slot allocation and frozen GPU placement. Parity order0/1/0; timing order0/1/1/0. An identical untimed database prefill warms compute after each conversion. Cold arms then clear the application Engram cache and successfully advise eviction of both native Engram files. No file hashing runs concurrently with timing. Live cache promotions are not exercised by this frozen timing protocol; the changed data conversions are exercised by the slot round-trips.

## Reproduction

Build `ds4_packed_host_test` explicitly on Linux/POSIX; it is excluded from normal builds and CTest. See `tests/fixtures/ds4_packed_host/README.md` for required model, resources, copied fixture and Engram paths. The test-only conversion hooks are absent from production builds.

The verifier's `--selftest` checks changed bits, signed zero and nonfinite values. `--check-existing DIR` verifies full saved logit shapes, finiteness, exact control/candidate/repeat equality and all80 greedy tokens. The public target was built and these verifier modes passed the archived full-model outputs. The numerical/timing run used the same hooks and harness before the guarded CMake target was packaged.

Raw logits, source snapshots, exact commands, profiles and receipts are retained on the test host under `/home/rkuo/research/llm-weight-compression/_meta/maya-packed-host-20261020`.
