# Opt-in exact prepared inputs in DS4 prefill

`DS4_EXL3_PREPARED=1` enables exact input reuse only inside the existing HIP predecode selector. Default off. Selector remains FF1152, at most3 experts, >=768 total routed rows and >=512 maximum rows per expert. The third GPU and compressed expert dispatch retain their existing paths.

Scratch is allocated after expert-cache placement. run_set submits <=C sorted routed rows, so C2048/D5120/FF1152 requires40MiB/main GPU. Actual nrows determine the tight per-group layout; gate/up and down reuse one stream-owned allocation. Input preparation is temporary; no new weight cache or arithmetic precision is introduced.

## Full-model validation

The local accepted peer-prefill stack passed finite bit-exact full cold2069/warm2048/repeat logits and all80 greedy tokens against independent accepted references. Test counters proved candidate execution (including162 calls for the2048-row warm prompt). Expert slots remained3469/3469/695. Cache moves and process swap were zero.

24 warm trials in six balanced blocks: initial mean block latency reduction **0.5137%**, t95/df5 **[0.0481%,0.9792%]**. Medians6775.152→6758.9195ms. One block was slightly negative; this is a small initial signal with confirmation still needed. Cold8/two blocks was inconclusive:0.4622%, interval[-10.3645%,11.2889%]. No decode gain claim. Raw observations and protocol are included.

The existing flag-off decoded gate/up and down GPU instruction bodies were byte-identical to the accepted pre-preparation build (45524/23004bytes). Full-logit checks also guard compiler/code-generation differences outside those two bodies.

The public model/kernel/header/test changes are source-identical to the executed local delta. The local measured stack contains separate accepted transfer-pruning/RAM-slice work, not added here. Clean public production/test builds and the verifier self-test passed. Production prepared-input test hooks are absent.

This remains an experimental checkpoint. Current serving stays on the accepted peer-prefill build; activation is not claimed. A separate compressed-weight input-reuse experiment may cover more expert groups without expanded-weight decoding cost.
