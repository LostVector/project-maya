Pure peer transport did not materially improve the helper's result-store path in this isolated screen. The existing helper writes its weighted sum directly to host-mapped RAM, then publishes a flag. Direct peer writes were about as fast; storing locally and adding a peer copy-engine transfer was slower.

Active helper 2→primary 0 path, median device span in microseconds:

| Rows | Host result | Helper-local only | Direct peer fine-grained | Local + peer DMA | Direct peer ordinary |
|---|---:|---:|---:|---:|---:|
| 1 | 9.039 | 8.135 | 9.094 | 20.169 | 9.041 |
| 2 | 11.659 | 7.643 | 11.656 | 22.417 | 11.664 |
| 3 | 15.090 | 7.858 | 14.776 | 25.623 | 14.776 |
| 4 | 18.963 | 7.781 | 18.034 | 29.397 | 17.979 |
| 6 | 25.253 | 7.982 | 24.330 | 35.648 | 24.308 |
| 8 | 31.455 | 8.114 | 30.612 | 42.507 | 30.636 |
| 16 | 56.347 | 8.415 | 56.070 | 67.710 | 56.050 |

The local-only column leaves the answer on the helper and is not a delivery path. The direct-peer small positive points are retained: at six rows, host 25.253 us versus peer 24.330 us, while at one row host 9.039 us versus peer 9.094 us. Both primary/helper pairs were tested. The extra copy-engine path cost about 10–14 us above the host path in this screen.

All 700 dynamic checks passed; 18,816 timed combine/store/signal operations were retained, with zero observed KFD/PSI counter changes and no serving requests. Both devices' initialization streams are synchronized before timing. The first attempt lacked that explicit initialization ordering and failed batched consistency; its raw results are preserved and excluded from interpretation.

The kernel models the existing 128-lane output combine: six ordered FMA contributions from precomputed partials, followed by +0. It omits expert matmul/decompression. Device event spans include host launch gaps and the helper ready-signal fence. This is a store/transport opportunity screen, not a model throughput benchmark or a complete CPU/GPU merge implementation.

Reusing historical layer/window counts gives only an illustrative service-volume estimate: helper-local-only could remove roughly 101–107 us/output, direct peer writes about 5 us/output, and the copy-engine variant adds about 176–191 us/output. These estimates assume every profiled layer uses one helper result stage, linearly interpolate T5 and assume no overlap. They are not observed decode gains or rigorous bounds. The old CPU helper-merge time 0.026 ms/output also does not bound GPU output-store time.

A fused GPU result read/merge with changed scheduling remains a distinct, unimplemented question. Source inspection shows T1 token mode waits before fused down, while the window path already computes down before its wait/combine. The prior DS4_MOE_TOKEN=0 experiment retained +0.51/+1.54% observations that missed an old 3% gate, with adaptive-placement numerical confounds. The canonical CPU critical-path work item preserves that evidence and a potentially distinct fused T1 late-wait hypothesis; this result does not disprove it.

No runtime result-transport change, model reload or upstream PR is proposed from this screen. Normal serving stayed unchanged. All work and remaining hypotheses are referenced from the single canonical plan. The raw records, source and commands live at the adjacent JSON's permanent artifact root.
