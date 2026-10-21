# Layer-paired expert reuse: negative quick screen

Default-off HIP prototype `DS4_LAYER_PAIR=1` changes prefill traversal from chunk/layer to pair/layer/chunk. One extra device chunk state preserves h/pre/topk/cand; each layer still sees chronological chunks. A bounded first-admission expert cache copies GPU-ready first-chunk expert blobs from the existing ring and serves second-chunk hits back into their original ring slots. Original virtual expert order, GEMM shapes and accumulation order are preserved. No new GPU matrix kernel.

A 768 MiB contiguous cache allocation was rejected before any paired work. The final allocator targets512 MiB uniformly across ranks, with bounded384/256 MiB fallback and512 MiB reported free-memory guard. In the measured run all three GPUs allocated512 MiB with no fallback, leaving at least1.29 GB reported free. Resident expert placement was held fixed at94/165 test slots; this is a numerical fixture, not normal serving placement.

All six32K full-vocabulary prefill states were bit-exact against an independently built accepted reference. Zero swap, unchanged routing counts, and exact payload conservation: baseline H2D = actual H2D + cache-saved bytes on every rank/request. Each R9700 avoided37,759,293,696 bytes per prefill (17.504% of215,719,319,808 baseline bytes). Each also performed80,437,360,896 additional D2D payload bytes. The pruned third-card tail had no reusable first-chunk experts and no cache hits.

Two excluded warmups followed by off/on/on/off timing:

| Pair | Baseline ms | Paired ms | Latency change |
|---|---:|---:|---:|
|1|32612.415|33783.825|+3.592%|
|2|32805.351|34352.012|+4.715%|

The predefined >=1% improvement gate failed. Keep disabled; no expensive decode/KV/snapshot/API quality campaign or upstream proposal. Byte reduction alone did not translate into throughput. Potential copy-admission/overlap overhead is a hypothesis, not a profiled explanation. A future variant could defer/batch D2D admission after publishing the existing ring filled event, preserving copy-stream ordering and ring lifetime; it requires its own parity and timing validation.

Conditions: EXL3 3.5bpw, TP2 R9700 fastpair with RX9070XT tail, split36/4, chunk4096, context262144, all three GPUs240W, matrix/attention/whole-chunk pruning/combine-mode3 selected baseline. No dense reconstruction cache or speculative prefetch enabled.

Durable machine-local source/build/fixtures/logs/analysis: `/home/rkuo/research/llm-weight-compression/_meta/maya-layer-paired-reuse-20261021/`. Initial guard rejection and768 MiB allocation failure are retained in separate attempt directories.
