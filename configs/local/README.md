# Three-R9700 scalar-tile preset

`three-r9700-scalar-tiles.env.json` records our tested `auto` mode with gate/up cutoff48 and down cutoff128. Merge its `env` entries into the existing optimized serving configuration after building an engine containing `upstream/hip-exl3-scalar-tiles` (or applying that kernel change to the helper-enabled serving stack). It is an environment overlay, not a standalone launch configuration; it carries no executable/model paths or replacement helper/MTP/cache settings. Older binaries ignore these new variables.

The thresholds refer to the maximum routed rows in a dispatched expert batch, not the prefill chunk size. Our matched warm4K screen measured 2.54% lower prefill latency with this preset and 2.17% with fixed12, with exact checked logits. The small difference between them needs broader confirmation. Other GPUs/workloads can prefer different tile sizes or cutoffs; upstream defaults stay off.

The upstream PR contains the configurable kernels and general documentation. This workstation preset is fork-only. The same overlay is saved locally at `maya-r9700-scalar-tiles.env.json` (a generated/ignored root config).
