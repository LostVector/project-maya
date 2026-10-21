# HIP peer all-reduce steady deadline

A 32K prompt at cap5472 failed with rank0 sequence178 observing sequence176. Its recorded elapsed counter was18446744073653827951, equivalent to signed -55723665. The signed core-counter difference was compared to an unsigned budget, causing an immediate false timeout. Rank1 subsequently reached a normal deadline waiting for sequence179. This does not prove every historical peer failure had this cause.

Use HIP wall_clock64 (constant-frequency steady counter) and query hipDeviceAttributeWallClockRate in kHz for the unchanged physical two-second production deadline. Invalid or unsupported rate queries retain the existing host-transport fallback. Arithmetic, flags, fences and rank sum order are unchanged.

Validation: two R9700 GPUs, gfx1201. 256 chained variable-size collectives, including signed zero, extremes, subnormals, sequence wraparound and guarded outputs, match the host-transport reference bit for bit. Capacity extended through8192x5120 floats, including the failing5462x5120 payload. Deliberately absent peer times out with a50ms wall-clock budget; assert45–1000ms physical elapsed.32 subsequent poisoned collectives drain and preserve the first diagnostic record. Both initial2K and extended8K tests exit0.

Full-model chunk sweep is pending; passing the unit test does not establish model-wide stability or a throughput gain. Durable logs: /home/rkuo/research/llm-weight-compression/_meta/maya-peer-steady-clock-20261021.
