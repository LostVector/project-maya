# Opt-in exact HIP peer transport for chunked prefill

`DS4_HIP_PEER_AR=1` enables the experimental two-rank peer-VRAM all-reduce for chunked prefill. The default remains the host transport. Requires bidirectional HIP peer access and fine-grained device allocation support. Window/decode reductions, logits gathering and pipeline handoffs retain their existing transports.

Initialization runs after expert-cache placement. At chunk 2048 and dimension 5120, two receive slots require 80 MiB per rank plus padded flags/error storage. Partial allocation failure frees temporary buffers for both ranks and retains host transport. The allocation must fit remaining reserve; it does not evict experts.

The peer kernel retains existing rank-order F32 arithmetic. A bounded device wait reports a sticky error. Subsequent queued peer calls drain, and the model checks errors after workers finish, before returning request success. Failed model state remains poisoned across reset; reload is required. Graph replay with frozen host sequence numbers is unsupported; this integration uses the chunked path.

## Validation protocol

Build excluded targets `ds4_peer_allreduce_test` and `ds4_peer_prefill_test` in a HIP test build. The latter requires the DS4 pack and artifact directory containing fixed code/database token IDs, frozen expert profile, and Engram file list. It uses all three GPUs, TP2 on the R9700 pair, chunk2048 and context262144. Run with inference stopped because the harness loads another model.

The full harness checks finite bit-exact cold2069/warm2048/repeat logits and 80 greedy tokens, plus transport counters and zero expert-cache moves. The durable analysis compares outputs with independent accepted references. Timings use two balanced cold blocks and six warm blocks, alternating ABBA/BAAB; confidence intervals use block gains. Candidate scratch remains allocated for both arms so expert placement is identical.

`DS4_PEER_AR_FAULT_ONLY=1` selects the separate model fault-injection gate: injected sticky peer errors must reject the current request, and reset must not allow subsequent decode or prefill. Fault injection methods exist only in the test build.

Measured local integration also contains separate transfer-pruning and RAM-slice work, which this stacked PR does not add. The measured candidate passed finite bit-exact cold2069/warm2048/repeat logits against independent accepted references and all 80 greedy tokens, with zero cache moves and zero process swap in every timing trial.

Warm prefill: 24 trials in six balanced blocks; mean block latency reduction **9.2332%**, t95/df5 **[8.9991%, 9.4673%]**, all blocks positive. Baseline/candidate medians **7456.793 / 6758.643 ms**.

Cold prefill: eight trials/two balanced blocks; mean reduction 7.6577%, interval [-25.2828%, 40.5982%], inconclusive. Decode pair 12.292 / 12.273 tokens/s; no decode gain claim.

The separate test-only model fault-injection gate and clean public build were pending when this checkpoint was opened. Serving activation is not part of this result. The measured executable was built at local ffcaf63; subsequent test-only fault injection does not change the production code path.
