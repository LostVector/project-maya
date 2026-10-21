# Exact prepared inputs with compressed EXL3 weights

Adds HIP kernel APIs that reuse exact rotated FP16 inputs while keeping weights compressed inside the original FMA16 decode/multiply loop. No expanded weights are required by candidate operations. Existing weight prefetch, decoding, F32 accumulation and reduction order are retained. No Model dispatch or serving flag is added by this checkpoint.

Gate/up use distinct prepared inputs because suh differs; down prepares from the gate/up result. One stream-owned workspace is reused at disjoint lifetimes. At C2048/D5120 the bound is40MiB per exercised GPU. The same bounds/capacity/stream contract as the prepared-input APIs applies; gate/up requires equal K for those two matrices.

## Validation

On each dedicated R9700 and RX9070XT,33 all-K/codebook correctness cases and110 captured-shape contiguous/padded cases passed bit-exact outputs, finite checks, padding/boundary/workspace guards and negative API checks. Recorded HTTP counters verified inference was idle; tests would stop if external inference began. Captured group shapes/strides/counts use deterministic synthetic weights/activations.

The original48 compressed FMA16 gate/up/down GPU instruction bodies (K1..8,cb0..2) remain byte-identical with the new specialization off. Public kernel/header/test sources match the executed local delta.

## Frozen candidate dispatch rule

Training uses only27 captured groups. Choose the smallest threshold from0/16/32/64/128/256/512/768/1024 with at least3 selected training cases and all selected training medians positive. Preserve the existing predecode selector. This selected >=256 total routed rows for remaining compressed groups, D5120,FF1152/2304,cb2,equalK3/4. The policy file was hashed before held-out gains were inspected.

The selected six training cases and ten held-out cases all improved on both devices. Held-out median latency reductions: **4.58–12.14% R9700**, **4.71–13.88% RX9070XT**. Preparation launches are included; expanded-weight decoding is absent from both timed arms. Raw440 observations/device, fixtures and frozen policy are included. These are kernel results, not full-model gains or per-shape confidence claims. Small groups can regress, so the rule is not universal.

Build excluded HIP target `exl3_compressed_prepared_replay`; run it with `docs/experiments/exl3-prepared-groups.txt` while inference is idle. Full finite independent accepted logits,80 greedy tokens and balanced end-to-end timings remain gates before enabling. Current serving remains on the peer-prefill build.
