# Chunked-prefill expert hit and traffic counters

Set `DS4_PREFILL_STATS=1` to log one `DS4_PREFILL` record per device and
chunked feed. The counters read routing bounds already present on the CPU;
they add no GPU readback, kernels or synchronization. They are disabled by
default and do not replace the existing decode-only `STAT vram_hit` metric.

Fields:

- `expert_row_picks`: executed token/expert assignments on this device.
- `vram_row_picks`: assignments whose expert was resident in VRAM.
- `unique_expert_uses`: distinct expert uses per layer/chunk, summed over the
  feed. The same expert used in another chunk counts again.
- `vram_unique_expert_uses`: those uses served by resident experts.
- `streamed_weight_bytes`: delta of the existing expert-stream byte counter,
  including repeated copies. This is expert payload, not a PCIe hardware
  counter; it excludes all-reduce, activation handoffs and other transfers.
- `tokens` and `chunk`: feed token count and configured chunk size. Actual
  chunks may be balanced below the configured size.

The token-level hit rate is `vram_row_picks / expert_row_picks`. A resident
expert serving 100 rows contributes 100 hits, not one. Pruned rows contribute
no requests. Tensor-parallel members report the same logical assignments
but transfer their own weight slices: count the TP group once for a global
logical hit rate, while counting every device for physical streamed bytes.
The window path does not emit these chunked-prefill records.

Validation on two R9700s and one RX 9070 XT: the instrumented matrix path
matched independent 2069-row code and 2048-row database references exactly.
Six probe snapshots matched across baseline/candidate/repeated baseline.
All 15 device records had the expected executed routing totals; unique
nonresident uses equaled existing expert-copy counts; tail-GPU byte totals
equaled exact blob sizes and TP bytes fell within the actual layout bounds.
This validates the short reference workload, not larger-chunk performance.

The CPU `ds4_prefill_stats_test` checks weighted hits versus unique uses,
repeated use across chunks, empty slots, and invalid bounds without partial
counter updates. Build and run it through CMake/CTest.
