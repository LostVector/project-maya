# Actual EXL3 expert-group replay fixture

55 groups sampled from controlled database and code prompts for LibertAIDAI/DeepSeek-V4.1-Flash-1017-EXL3-3.5bpw. Input token fixtures and frozen profile are in ../ds4_packed_host. Baseline: packed host weights plus FMA16, transfer pruning, TP2 on two R9700 cards with RX9070XT stage3, split36/4, 2K chunks, context262144, reserve2048MiB.

All full logits were finite and bit-exact for logged/unlogged database runs and code/repeat/independent accepted-engine controls. The full capture contains20973 records and covers every expected case/GPU/layer/chunk, with exactly6 routed rows per input token per layer. Duplicate code-repeat records are excluded from sampling.

Fields: case0 database/case1 code; GPU0 TP representative/GPU2 final-stage card; layer; actual chunk lengthT; streamed versus cached; D/F matrix dimensions; per-expert byte stride; native EXL3 fmt0; gate/up/down bit widthsK; counts in original expert order including empty slots. record_id refers to the immutable full capture on the test host. T is2048 for database and1034/1035 for code. Actual token gather indices are not captured.

Sampling stratifies by case,GPU,source,K, chooses20/50/80/100% quantiles of total routed rows plus the largest single-expert group, and removes duplicate count vectors within each stratum. The split field holds27 training and28 held-out groups, assigned by layer parity. This is a small two-prompt fixture, not a broad-workload evaluation. Keep held-out timing results separate when fitting a policy.

Retain empty slots and the exact expert cardinality in a replay: both affect launch geometry. Use model-sized activation buffers and multiple index patterns, since actual gather indices are absent. Free allocations between cases. A replay benchmark consuming this fixture remains future work; no policy or model speedup is claimed from the capture.

Source capture, sampler scripts, checksums and raw logits live at /home/rkuo/research/llm-weight-compression/_meta/maya-tile-trace-20261020 on the test host.
