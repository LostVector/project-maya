# HIP pending-stream wait diagnostic

This optional standalone benchmark reproduces a small-kernel dispatch penalty on this host's two R9700s and RX9070XT. It does not change Maya, run with the normal build/tests, or establish a model speedup. The experiment was prompted by [ROCm/TheRock#9297](https://github.com/ROCm/TheRock/issues/9297) and [vLLM#58639](https://github.com/vllm-project/vllm/issues/58639). The benchmark is an independent implementation of the reported pending-wait scenario.

A main stream runs a bounded park kernel, 200 small kernels, then a separately timed 256 MiB streaming-read control. Zero, one, two or four nonblocking side streams wait for the final event. The park gives the CPU time to submit those waits before measured work starts; every trial records whether the tiny-kernel start event was still pending after submission. Side streams complete markers after their wait. All streams drain before buffers/events are reused.

Every trial checks all 4,096 tiny outputs, every streaming-read partial sum, and all four side markers. Two warmups and all measured repetitions are emitted. The wait-count order alternates by repetition; no outliers are removed. Captured mode graphs contain only the 200 tiny kernels, with timing events outside the graph. The large control follows on the same stream in both modes.

## Build and run

Use a HIP compiler matching the runtime. For example:

```sh
hipcc -O2 -std=c++17 --offload-arch=gfx1201 tests/hip_pending_wait_bench.hip -o /tmp/hip_pending_wait_bench
HIP_VISIBLE_DEVICES=0,1,2 env -u GPU_MAX_HW_QUEUES /tmp/hip_pending_wait_bench 1 20 > default.jsonl
HIP_VISIBLE_DEVICES=0,1,2 GPU_MAX_HW_QUEUES=2 /tmp/hip_pending_wait_bench 1 20 > queues2.jsonl
python3 tests/analyze_hip_pending_wait.py default.jsonl queues2.jsonl > summary.json
```

The arguments are HIP device index and repetitions (default 1 and 20). Repeat separately for devices 0/2 and queue limits 1/4/8. The environment header reports GPU identity/BDF, driver/runtime versions, repetition count and the actual inherited queue variable. Explicitly unset the variable for the default arm; container images can otherwise silently provide it.

Run with no concurrent inference or other GPU benchmark. The program requires384 MiB free before allocating its 256 MiB control buffer; it refuses rather than overcommitting. The park is10ms at the reported maximum shader clock and can take longer at lower clocks. This is a bounded diagnostic, not a persistent service.

## Retained local result

The reference fixture retains all 2,640 observations: three devices, five process-local queue settings, two execution modes, four wait counts, twenty measured repetitions and two warmups. `sample_columns` describes the compact arrays. Warmups remain in the fixture and are excluded only from the declared timing summary. Each process completed with all numerical checks passing; every measured start event was pending at the submission check. No HTTP inference overlapped any process. Maya remained resident and idle; graphics remained active on HIP0. One process per device/queue setting limits claims about spawn-to-spawn variability.

Graph-mode medians at the **unset** queue limit:

| HIP device | No side waits, us/kernel | Four side waits, us/kernel | 256 MiB control, no/four waits, ms |
|---|---:|---:|---:|
| 0: R9700,03:00 | 2.327 | 8.005 | 0.434 /0.446 |
| 1: R9700,07:00 | 2.289 | 7.992 | 0.432 /0.438 |
| 2: RX9070XT,0f:00 | 3.112 | 63.861 | 0.445 /0.604 |

Queue limits 1/2 removed the small-kernel penalty through four waits on all three cards. Explicit limits 4/8 changed the wait-count threshold; see the complete fixture. The RX9070XT large control also slowed (~36%), so it is not accurate to call that card's memory workload unaffected.

These observations establish a local pending-stream scheduling effect. They do **not** establish the cause of Maya's earlier 100ms kernel outliers, demonstrate a prefill/decode gain, or prove that reducing the hardware queue count is safe for Maya's dependent compute/copy streams and resident handoff waits. The linked vLLM report found worse end-to-end pipeline throughput with a queue cap despite a faster local forward. Keep production unchanged until application dependencies, strict full-logit parity, cold/warm prefill and decode are validated.

Potential application experiments should reduce unnecessary pending side waits while preserving all producer/consumer dependencies, or evaluate a queue cap in an isolated, bounded process first. A positive microbenchmark is insufficient to select either approach for serving.
