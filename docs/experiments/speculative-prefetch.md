# Speculative expert prefetch: negative quick screen

Default-off `DS4_SPEC_PREFETCH=1` predicts the next layer first streaming batch from the preceding chunk same-layer routing. False negatives are repaired before consumption; original virtual slots and accumulation order are preserved.

On TP2 R9700 + RX9070XT 36/4, EXL3 3.5bpw, chunk4096, fixed94/165 resident slots, all GPUs240W, six 32K full-prefill vocabulary states were bit-exact against an independently built accepted reference. No swap, both TP ranks used predictions, no pending batches. Two excluded warmups followed by off/on/on/off timed requests.

Paired latency reductions: **0.1700% and0.4162%**. Both fail the predefined >=1% quick-screen threshold. No larger quality/API campaign was run; no decode/KV/snapshot validation claim. This prototype remains off and is not proposed for upstream or serving.

Machine-local durable receipts: `/home/rkuo/research/llm-weight-compression/_meta/maya-speculative-prefetch-20261021/quick-validation/`. JSON alongside this note contains timings and raw counters.
