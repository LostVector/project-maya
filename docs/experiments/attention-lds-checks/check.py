"""Regrade the portable receipts; optionally check full model-test output bytes."""
from pathlib import Path
import argparse
import array
import hashlib
import json
import math
import statistics

p = argparse.ArgumentParser()
p.add_argument('--raw-dir', type=Path, help='Output directory from ds4_attention_model_test')
args = p.parse_args()
root = Path(__file__).resolve().parent
d = json.loads((root / 'checks.json').read_text())
for name, expected in d['fixture_sha256'].items():
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == expected, name
assert d['native_exit']['exit_code'] == 0 and d['native_exit']['swap_peak_kib'] == 0
assert len(d['native_cases']) == 3
states = 0
for case in d['native_cases']:
    assert len(case['states']) == 65 and len(case['answers']) == 3
    for answer in case['answers']:
        assert answer['correct'] and answer['parsed_json'] == case['expected_answer']
        text = answer['text'].strip()
        if text.startswith('```') and text.endswith('```'):
            text = '\n'.join(text.splitlines()[1:-1])
        assert json.loads(text) == case['expected_answer']
    for step, state in enumerate(case['states']):
        assert state['step'] == step and state['candidate_repeat_prior_all_exact']
        states += 1
        if args.raw_dir:
            for trial in range(3):
                file = args.raw_dir / f"{case['id']}-trial{trial}-step{step}.f32"
                data = file.read_bytes()
                assert len(data) == 129280 * 4, file
                assert hashlib.sha256(data).hexdigest() == state['sha256'], file
                floats = array.array('f')
                floats.frombytes(data)
                assert all(math.isfinite(x) for x in floats), file
assert states == 195
units = d['unit_results']['results']
assert {x['device'] for x in units} == {0, 1, 2}
for unit in units:
    lines = (root / f"gpu{unit['device']}.log").read_text().splitlines()
    pairs = [dict(x.split('=', 1) for x in line.split()[1:])
             for line in lines if line.startswith('PARITY ')]
    assert len(pairs) == unit['comparisons'] == 64 and unit['exit_code'] == 0
    assert len({(x['case'], x['group'], x['swizzle']) for x in pairs}) == 64
    assert {x['group'] for x in pairs} == {'1', '2', '4', '8'}
    assert all(x['mismatches'] == '0' and x['finite'] == x['guards'] == '1' for x in pairs)
    assert unit['before']['requests'] == unit['after']['requests']
    assert unit['before']['in_flight'] == unit['after']['in_flight'] == 0
    assert lines[-1] == 'COMPLETE exact=1'
times = {}
for line in (root / 'initial-screen.log').read_text().splitlines():
    if not line.startswith('TIME '):
        continue
    row = dict(x.split('=', 1) for x in line.split()[1:])
    if row['warmup'] == '0':
        times.setdefault((row['case'], row['group'], row['swizzle']), []).append(float(row['gpu_ms']))
for case in d['initial_screen']['results']:
    for group in (8, 4):
        for swizzle in (0, 1):
            values = times[case['case'], str(group), str(swizzle)]
            assert len(values) == 8
            assert math.isclose(statistics.median(values), case['median_ms'][f'G{group}_sw{swizzle}'], rel_tol=1e-12)
print('PASS: 195 native receipt states, 9 answers, 192 operator comparisons, initial timing medians')
if args.raw_dir:
    print('PASS: all 585 raw snapshots match the independent accepted-state SHA256 digests and are finite')
