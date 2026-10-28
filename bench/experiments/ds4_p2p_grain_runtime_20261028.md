The faster peer-reduction operator did not produce a general decode win in the completed model screens.

| Workload | Improved vs AR2, adaptive interleaved | Improved vs AR2, matched startup-static placement |
|---|---:|---:|
| Coding | +0.57% | −0.08% |
| Async workers | +4.56% | −1.25% |
| Long context | +5.19% | −0.82% |

Both positive and negative observations are retained. The adaptive screen had roughly 10% late-control improvement on the short fixtures, different outputs/MTP work in every block, and cannot establish a causal gain. The static-placement diagnostic had identical output tokens, accepted/offered drafts, expert hit/lookup counts and reduction-row histograms across modes. Its AR2 tail drift was +0.43%/−0.37%/−1.09%. Static startup residency is less representative of a fully warmed adaptive cache; these results do not rule out other residency/batching regimes.

Original peer grain1 remained a bounded coding positive in the static run (+0.68% versus AR2), while async/long were −0.48%/−0.29%. The improved grain was−0.76%/−0.78%/−0.53% versus that original peer mode. The operator 18–45% latency reductions in the preceding checkpoint remain valid for their isolated workload; they are not model gains.

Each model screen contains 27 primary 128-token requests (three modes × three fixtures × three Latin-order blocks), three extra AR2 controls, and three discarded warmups. The static diagnostic uses full-length warmups, disables expert migrations while retaining startup VRAM weights, and uses consistent last-row prompt replay. All 60 timed requests across both screens had no observed KFD eviction or memory-pressure events; no samples were removed or times subtracted. These are time blocks within single loads, not a tight multi-load confidence interval.

The improved kernel/model passed 1,551,360 canonical-reference logit values exactly. Runtime counters verified the actual peer selection and selective status checks. After timing, idle host-state injection checked that feed, feed_mark, forward, chunked forward, draft and verify remain invalid after reset and transport switching; it does not demonstrate recovery from a driver hang or actual model-level missing peer.

Private research controls switch backends between completed requests. The accompanying patch records their exact delta against the preceding preserved private baseline, with preimage hashes in the JSON. It is a recovery/review artifact, not an upstream/main serving patch. Full immutable source, native/probe/operator build commands, protocols, raw results, fingerprints and restoration receipts live in the permanent research workspace and are referenced by the canonical plan's p2p-decode-reductions item.

Normal serving was restored after both screens, with its original executable hash, environment, migrations setting and health independently verified. No decode-P2P default or additional upstream runtime PR is proposed from this checkpoint. Next: assess the separate logits-gather opportunity from its active path and measured cost before implementing.
