# Whole-chunk pruning with the decoded matrix path

This experiment compares pruning off/on in one model session, using the same
decoded matrix kernels, expert profile, allocation and chunk size. It does not
compare the matrix kernels with FMA kernels.

Generate the frozen retrieval fixtures:

```sh
python bench/micro/ds4_long_prompt_performance_prepare.py RUN PACK/tokenizer PROFILE
```

The native `ds4_long_prompt_skip_test` target takes `PACK RUN 2048 64`. Set
`DS4_YOCO_TEST_MATRIX=1`, `DS4_YOCO_TEST_PERF=1`,
`DS4_YOCO_WHOLE_CHUNKS=1`, `DS4_YOCO_TEST_FORCE_FREE=1`, and
`DS4_YOCO_TEST_PREFIX_PRUNED=1`.

Before launch, provide independent accepted **matrix** references as
`independent-code-reference.f32` and `independent-database-reference.f32`, with
their inputs `baseline-code-ids.json` and `baseline-database-ids.json`. These
must contain full-vocabulary logits for every input row; an FMA reference is
not interchangeable. The test checks both references exactly before the
long-prompt cases.

Preflight runs baseline/pruned/baseline for 8K, 32K, and an 8K pruned prefix
followed by a 512-token append. Each case retains 65 full-vocabulary snapshots,
including post-EOS states, plus actual free-generation answers. The prefix
case is quality-only. Pruned candidate answers are generated independently.

The process then writes `preflight-ready.txt` and waits up to 600 seconds.
Use `python bench/micro/ds4_long_prompt_context_analyze.py RUN PACK/tokenizer`
to inspect the preflight snapshots and answers. Review correctness, numerical
differences, actual whole-chunk plans,
allocations and the frozen profile before atomically writing `APPROVED` to
`timing-gate.txt`. Write `REJECTED` to stop without measurements. An approval
file must never be reused from a previous run. Serving must be stopped and no
other GPU work may run during the experiment.

Timing uses four alternating ABBA/BAAB blocks at 8K and two at 32K, interleaved
by length. All 24 samples are retained. Every measured final logit vector must
exactly match its own preflight arm; actual pruning-plan counts, finite logits,
zero model swapping and zero process swap are mandatory. Debug plan logging
is disabled during timing. KV state is reset for each sample; this is a warm
engram/file-cache experiment, not a cold-disk benchmark.

The experiment controller records `model-exit.json` and `gate-review.json`.
After successful completion, analyze the raw samples with:

```sh
python bench/micro/ds4_long_prompt_performance_analyze.py RUN
```

The analyzer requires successful exit, an approved preflight, and the complete
scheduled sample sequence. It reports each length separately, using per-block
latency reduction and a Student-t 95% interval. These are time blocks within
one model load, not independent loads. Synthetic retrieval checks do not prove
broad quality, and the experiment makes no decode-speed claim.

## Local validation checkpoint

On the three-gfx1201 setup (two R9700s plus one RX 9070 XT), the independent
2069-row code and 2048-row database matrix references matched exactly. All
195 pruning-versus-control snapshots matched bit-for-bit, all baseline repeats
matched, and all three independently generated candidate retrieval answers
were correct. Six logged whole-chunk plans retained 4096 rows with zero
partial cut rows. The 512-token append reused a genuinely pruned 8192-token
prefix in the candidate arm. Expert allocations remained
26.85/26.85/12.40 GB in VRAM and 173.4 GB in RAM.

This establishes numerical invariance on these three inputs relative to the
selected matrix baseline. It does not establish equivalence between matrix
and FMA kernels or broad model quality. The controlled timing run is pending;
preflight timings are excluded from performance claims.
