"""Regrade all 36 synthetic answers and recompute coarse cap summaries (stdlib only)."""
from pathlib import Path
import json
import math
import statistics

root = Path(__file__).resolve().parent
data = json.loads((root / 'measurements.json').read_text())
fixtures = {x['name']: x for x in data['fixtures']}
assert len(fixtures) == 6
assert [a['cap'] for a in data['arms']] == data['protocol']['caps']
results = []
for arm in data['arms']:
    cap = arm['cap']
    rows = arm['requests']
    assert len(rows) == 6 and {x['name'] for x in rows} == set(fixtures)
    for row in rows:
        case = fixtures[row['name']]
        assert row['primer'] == case['primer']
        assert row['isolated'] and row['swap_kib'] == 0
        timing = row['response']['timings']
        n = case['expected_prompt_tokens']
        assert timing['cache_n'] == 0 and timing['prompt_n'] == n
        assert all(math.isfinite(timing[k]) and timing[k] > 0 for k in ['prompt_ms', 'predicted_ms'])
        choice = row['response']['choices'][0]
        text = choice['message']['content'].strip()
        if text.startswith('```') and text.endswith('```'):
            text = '\n'.join(text.splitlines()[1:-1])
        assert choice['finish_reason'] == 'stop'
        assert json.loads(text) == case['expected_answer']
        assert row['correct']
        nc = (n + cap - 1) // cap
        per = (n + nc - 1) // nc
        skipped = ((n - 2668) // per) * per if n - 2668 >= 1024 else 0
        retained = n - skipped
        metrics = row['prefill_metrics']
        assert metrics['retained_rows'] == retained
        gpu = metrics['per_gpu']
        assert [x['gpu'] for x in gpu] == [0, 1, 2]
        for x in gpu:
            assert x['tokens'] == n and x['chunk'] == cap
            expected = 6 * (20*n + 16*retained) if x['gpu'] < 2 else 6*4*retained
            assert x['expert_row_picks'] == expected
            assert 0 <= x['vram_row_picks'] <= expected
            missing = x['unique_expert_uses'] - x['vram_unique_expert_uses']
            assert missing >= 0
            if x['gpu'] == 2:
                assert x['streamed_weight_bytes'] == missing*17739264
            else:
                assert missing*6673152 <= x['streamed_weight_bytes'] <= missing*8884992
        assert gpu[0]['vram_row_picks'] == gpu[1]['vram_row_picks']
        logical = gpu[0]['expert_row_picks'] + gpu[2]['expert_row_picks']
        hits = gpu[0]['vram_row_picks'] + gpu[2]['vram_row_picks']
        assert math.isclose(metrics['logical_row_hit_fraction'], hits/logical, abs_tol=1e-12)
        assert metrics['total_streamed_weight_bytes'] == sum(x['streamed_weight_bytes'] for x in gpu)
    item = dict(cap=cap, allocation=arm['allocation'], lengths={})
    for n in [8192, 32768]:
        timed = [x for x in rows if not x['primer'] and x['expected_prompt_tokens'] == n]
        assert len(timed) == 2
        ms = statistics.mean(x['response']['timings']['prompt_ms'] for x in timed)
        item['lengths'][str(n)] = dict(
            mean_prompt_ms=ms, tokens_per_second=n*1000/ms,
            sample_prompt_ms=[x['response']['timings']['prompt_ms'] for x in timed],
            mean_expert_transfer_GB=statistics.mean(x['prefill_metrics']['total_streamed_weight_bytes']/1e9 for x in timed),
            mean_logical_row_hit_fraction=statistics.mean(x['prefill_metrics']['logical_row_hit_fraction'] for x in timed),
            decode_tokens_per_second=sum(x['response']['timings']['predicted_n'] for x in timed)*1000/sum(x['response']['timings']['predicted_ms'] for x in timed))
    results.append(item)
print(json.dumps(dict(correct_requests=36, results=results,
    ranking_32k=[x['cap'] for x in sorted(results, key=lambda x:x['lengths']['32768']['mean_prompt_ms'])],
    limitation='Single load per cap; screening only. Warmups excluded but retained. No precise gain or broad quality claim.'), indent=2))
