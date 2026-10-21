# Exact sparse expert combination: matched API checkpoint

When a streamed expert batch has no outputs for a token, the original combine
kernel still reads that token's accumulator. The six-pick specialization in
[the component checkpoint](moe-combine.md) checks membership first, skips those
reads, and preserves the original conditional FMA order. The HIP feature remains
default-off in source (`DS4_MOE_COMBINE_MODE=2` enables it).

## Matched performance

Four fresh model loads ran control/candidate/candidate/control. Both variants
used attention LDS swizzling, chunk 4096, whole-chunk pruning, EXL3 matrix16,
RAM experts, and TP2 plus a four-layer third-GPU tail. Each load excluded fixed
8K and 32K warmups, then measured two fresh prompts at each length. All samples,
including warmups, are preserved. These are server prompt timings, excluding
HTTP and decode; they are not native feed-only timings.

| Prompt | Control tok/s | Candidate tok/s | Latency reduction |
| --- | ---: | ---: | ---: |
| 8,192 | 726.794 | 739.589 | 1.730% |
| 32,768 | 1,058.044 | 1,076.561 | 1.720% |

Both paired 32K blocks improved (1.759% and 1.681% lower latency). The descriptive
paired t interval with only two blocks is [1.222%, 2.218%]; the 8K interval is
[0.474%, 2.986%]. These intervals are descriptive, with one degree of freedom;
two loads per variant do not establish a general hardware/workload effect.
The predeclared small-gain gate required at least 1% pooled 32K latency
reduction, both pairs positive, no pooled 8K regression, and all integration
checks passing. It passed.

All 24 requests returned the expected answers, began with zero reused prompt
tokens, ran in isolation, and had zero observed process swap at request
boundaries. Expert allocations matched across all loads. Raw prefill counters
and engine logs are included. Short 27-token decode samples do not establish
sustained decode performance.

The independent native gate compared 195 candidate, 195 repeat, and 195 prior
reference full-vocabulary states exactly, and all nine free responses passed.
A separate frozen-profile native screen measured 1.636% lower feed latency and
identical routing/copy counters for all ten runs. Its throughput is not combined
with API rates: it uses a different expert profile and excludes API work.

## Serving integration

A separate limited suite scored 11/12, matching the stable historical cases;
`sort_key` is the sole miss and also varies in historical controls (11, 12, 11,
11, 11). Fresh 8K and 32K requests and a real cached conversation follow-up all
returned the expected answer. The follow-up reused 32,794 tokens. This is
limited integration evidence, not a broad quality claim. The existing relaxed
matrix and cross-chunk numerical limitations remain.

The selected local experimental configuration enables combine mode 2 and keeps
all other selected settings, including context 262144. The previous attention
layout configuration and executable remain available for rollback. Live process
identity is recorded separately from portable regrading; a saved identity
receipt is not evidence of the current live process.

## Reproduce saved evidence

From this repository, with Python 3:

```sh
python3 docs/experiments/moe-combine-api-checks/check.py
python3 docs/experiments/moe-combine-api-checks/check_serving.py
```

The first command independently regrades all 24 responses, checks saved
configuration and three-GPU counters, and recomputes pooled rates and paired
intervals. The second regrades the quality controls and candidate, verifies all
three API responses and actual cache reuse, and checks the saved serving
identity/configuration receipt. Neither command runs the model or measures new
performance. The component checkpoint retains operator and native validation.
