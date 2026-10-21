"""Regrade saved serving receipts; no model execution or live-server probe."""
from pathlib import Path
import ast
import hashlib
import json

r = Path(__file__).resolve().parent
d = json.loads((r / 'serving-checks.json').read_text())
for name, digest in d['files_sha256'].items():
    assert hashlib.sha256((r / name).read_bytes()).hexdigest() == digest, name

def normal(text):
    text = text.strip()
    if text.startswith('```') and text.endswith('```'):
        text = '\n'.join(text.splitlines()[1:-1]).strip()
    text = text.strip('`').strip()
    try:
        return 'literal', ast.literal_eval(text)
    except (ValueError, SyntaxError):
        return 'text', text.casefold() if text in ('Yes', 'No', 'yes', 'no') else text

cases = json.loads((r / 'serving-quality-cases.json').read_text())
assert len(cases) == 12

def grade(rows):
    assert [x['id'] for x in rows] == [x['id'] for x in cases]
    result = []
    for case, row in zip(cases, rows):
        choice = row['response']['choices'][0]
        passed = choice['finish_reason'] == 'stop' and normal(choice['message']['content']) == normal(case['expected_answer'])
        assert passed == row['passed']
        result.append(passed)
    return result

controls = [grade(json.loads((r / name).read_text())) for name in d['quality_controls']]
rows = json.loads((r / 'serving-quality-responses.json').read_text())
candidate = grade(rows)
assert sum(candidate) == d['quality_analysis']['correct'] == 11
assert [sum(x) for x in controls] == d['quality_analysis']['baseline_scores']
regressions = [case['id'] for i, case in enumerate(cases) if all(x[i] for x in controls) and not candidate[i]]
assert regressions == d['quality_analysis']['observed_stable_baseline_regressions'] == []
assert sum(candidate) >= min(sum(x) for x in controls)
for row in rows:
    before, after = row['activity_before'], row['activity_after']
    assert before['in_flight'] == after['in_flight'] == 0
    assert after['requests'] == before['requests'] + 1

payloads = json.loads((r / 'serving-smoke-payloads.json').read_text())
smoke = json.loads((r / 'serving-smoke-responses.json').read_text())
assert len(payloads) == 2 and len(smoke) == 3
for i, row in enumerate(smoke):
    payload = payloads[min(i, 1)]
    choice = row['response']['choices'][0]
    text = choice['message']['content'].strip()
    if text.startswith('```') and text.endswith('```'):
        text = '\n'.join(text.splitlines()[1:-1])
    assert choice['finish_reason'] == 'stop' and json.loads(text) == payload['expected']
    before, after = row['before'], row['after']
    assert before['in_flight'] == after['in_flight'] == 0
    assert after['requests'] == before['requests'] + 1
    timing = row['response']['timings']
    if i < 2:
        assert timing['cache_n'] == 0 and timing['prompt_n'] == payload['full_rendered_prompt_tokens']
    else:
        assert timing['cache_n'] >= 32000
        assert timing['cache_n'] == d['smoke_assessment']['actual_followup_cache_tokens']

identity = d['live_identity_snapshot']
cfg = json.loads((r / 'serving-config.json').read_text())
assert identity['all3_smoke_correct'] and not identity['stable_baseline_regressions']
assert identity['followup_cached_tokens'] == smoke[-1]['response']['timings']['cache_n']
assert cfg['env']['DS4_HIP_ATTN_SWIZZLE'] == identity['actual_attention_flag'] == '1'
assert cfg['env']['DS4_MOE_COMBINE_MODE'] == identity['actual_combine_mode'] == '2'
assert cfg['args'][cfg['args'].index('--prefill-chunk') + 1] == '4096'
assert identity['health']['status'] == 'ok' and identity['health']['max_context'] == 262144
assert identity['runtime_sha256'] == json.loads((r / 'binary-inputs.json').read_text())['candidate_sha256']
print('PASS: baseline-relative 11/12 quality, 3/3 API checks, 32794-token cached followup, saved identity/config receipt')
