# 4K chunk numerical checkpoint

The long-prompt test now accepts a 4,096-token chunk cap. At that cap it saves the complete code/database probe logits for cross-chunk analysis, while retaining strict reference comparisons at 2K.

Whole-chunk pruning matched unpruned execution in all 195 full-vocabulary snapshots across 8K, 32K and pruned-prefix follow-up fixtures. Unpruned repeats were also exact. All three expected retrieval answers were correct. The associated JSON records the protocol, input hashes and answers.

Changing the overall configuration from 2K to 4K was not bit exact:

| Probe | Positions | Top-1 agreement | Mean KL | Next-token NLL delta, 4K minus 2K |
|---|---:|---:|---:|---:|
| Code | 2,069 | 96.76% | 0.01371 | +0.00322 nats |
| Database | 2,048 | 99.32% | 0.00632 | +0.00180 nats |

These comparisons include changed workspace/resident capacity and expert dispatch. They do not isolate the arithmetic cause, establish broad quality equivalence or measure serving speed. The numerical fixtures use frozen cache admissions; serving uses normal learning. API timing and the unstable sorting answer are documented separately in PR36.

The native process and analysis passed. A missing launcher restore helper caused an operational failure afterward; restoration was recovered and the captured 2K server was verified healthy. Original failure receipts remain preserved. No runtime behavior or default selection changes in this checkpoint.
