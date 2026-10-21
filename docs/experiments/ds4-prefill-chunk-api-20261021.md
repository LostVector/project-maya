# DS4 EXL3 prefill chunk comparison

Increasing the chunk cap from 2,048 to 4,096 reduced repeated expert transfers and improved latency in both completed load pairs on this machine. This is a timing checkpoint, not acceptance of a new serving configuration.

| Prompt tokens | Mean paired latency reduction | 95% interval, two load pairs |
|---|---:|---:|
| 8,192 | 6.00% | -12.54% to 24.55% |
| 32,768 | 9.79% | -20.12% to 39.70% |

The wide intervals include zero. Both pairs favor 4K, but the small sample does not establish a precise gain. All 16 timed samples and eight excluded warmups are included in the accompanying JSON. Logical prefill hit rates were similar; fewer repeated expert loads explain the approximately 37–41% lower expert payload traffic.

The original final baseline stopped before timing: its sorting answer improved from Sable to the correct Aspen, violating an exact-answer-repeat gate. Its 12/12 quality result is preserved. A fresh final baseline completed under a documented amendment. The four timed loads scored 11/12 each; the extra baseline scored 12/12. This is quality uncertainty, not proof of equivalence. No transport error or process swap occurred in the completed requests.

Run `python docs/experiments/summarize_ds4_prefill_chunks.py` to reproduce the paired timing summary. The JSON records per-request timings, prefill counters, allocations, quality outcomes, input hashes, configuration and limitations. It omits generated prompt text; raw requests, original failure receipts and scripts remain in the durable research archive. Separate 4K pruning/prefix and cross-chunk numerical validation is pending. Selected serving remains at 2K.
