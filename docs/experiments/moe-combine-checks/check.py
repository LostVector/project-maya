"""Regrade saved evidence; --raw-dir additionally verifies native snapshots."""
from pathlib import Path
import argparse
import array
import csv
import hashlib
import json
import math
import re
import statistics

p = argparse.ArgumentParser()
p.add_argument('--raw-dir', type=Path)
args = p.parse_args()
r = Path(__file__).resolve().parent
d = json.loads((r / 'checks.json').read_text())
assert d['initial']['exit_code'] == 0 and d['initial']['all_exact'] and d['initial']['isolated']
assert d['confirmation']['all3_passed']
logs = [('screen.log', d['initial'])] + [(f"confirm-gpu{x['gpu']}.log", x) for x in d['confirmation']['results']]
total = 0
for name, receipt in logs:
    lines = (r / name).read_text().splitlines()
    pairs = [dict(x.split('=', 1) for x in line.split()[1:]) for line in lines if line.startswith('PARITY ')]
    assert len(pairs) == 30 and len({(x['case'], x['mode']) for x in pairs}) == 30
    assert all(x['mismatches'] == x['cpu_mismatches'] == '0' and x['finite'] == x['guards'] == '1' for x in pairs)
    assert sum(x['cpu_checked']=='1' for x in pairs)==9
    assert lines[-1] == 'COMPLETE exact=1'
    assert receipt['before']['requests'] == receipt['after']['requests']
    assert receipt['before']['in_flight'] == receipt['after']['in_flight'] == 0
    total += len(pairs)
    times = {}
    for line in lines:
        if line.startswith('TIME '):
            x = dict(y.split('=', 1) for y in line.split()[1:])
            if x['warmup'] == '0':
                times.setdefault((x['case'], x['mode']), []).append(float(x['gpu_ms']))
    assert len(times) == 30 and all(len(v) == 12 for v in times.values())
    saved = json.loads((r / 'screen-analysis.json').read_text())['results'] if name == 'screen.log' else [{'case': k, 'median_gpu_ms': v} for k, v in receipt['medians'].items()]
    for case in saved:
        for mode, value in case['median_gpu_ms'].items():
            assert math.isclose(statistics.median(times[case['case'], mode]), value, rel_tol=1e-12)
assert total == 120
native = json.loads((r / 'native-analysis.json').read_text())
assert native['baseline_correct'] == native['candidate_correct'] == 3
assert native['independent_accepted_4k_reference_states_exact'] == 195
hashes = json.loads((r / 'native-reference-hashes.json').read_text())
states = 0
for case in native['cases']:
    assert len(case['steps']) == 65
    for answer in case['answers']:
        text = answer['text'].strip()
        if text.startswith('```') and text.endswith('```'):
            text = '\n'.join(text.splitlines()[1:-1])
        assert json.loads(text) == case['expected_answer'] and answer['correct']
        if args.raw_dir:
            tokens = [int(x) for x in (args.raw_dir / f"{case['id']}-trial{answer['trial']}-free-tokens.txt").read_text().split()]
            assert tokens == answer['tokens']
    for step, x in enumerate(case['steps']):
        assert x['candidate_exact'] and x['baseline_repeat_exact'] and x['max_abs_error'] == 0
        states += 1
        if args.raw_dir:
            for trial in range(3):
                data = (args.raw_dir / f"{case['id']}-trial{trial}-step{step}.f32").read_bytes()
                assert len(data) == 129280 * 4
                assert hashlib.sha256(data).hexdigest() == hashes[case['id']][step]['sha256']
                floats = array.array('f')
                floats.frombytes(data)
                assert all(math.isfinite(v) for v in floats)
assert states == 195 and d['native_exit']['exit_code'] == d['native_exit']['swap_peak_kib'] == 0
timing = json.loads((r / 'native-timing-analysis.json').read_text())
rows = list(csv.DictReader((r / 'native-timing.csv').open()))
assert len(rows) == 10 and sum(int(x['warmup']) for x in rows) == 2 and all(x['exact'] == '1' for x in rows)
effects = []
for pair in timing['timed_pairs']:
    values = {int(x['mode']): float(x['feed_ms']) for x in rows if int(x['rep']) == pair['rep']}
    assert values[0] == pair['control_ms'] and values[2] == pair['candidate_ms']
    effect = 100 * (1 - values[2] / values[0])
    assert math.isclose(effect, pair['latency_reduction_percent'], abs_tol=1e-12)
    effects.append(effect)
a=statistics.mean(x['control_ms'] for x in timing['timed_pairs']);b=statistics.mean(x['candidate_ms'] for x in timing['timed_pairs'])
assert math.isclose(100*(1-b/a),timing['pooled_latency_reduction_percent'],abs_tol=1e-12)
text = (r / 'model-test.log').read_text()
metrics = []
for match in re.finditer(r'COMBINE_PERF_BEGIN rep=(-?\d+) mode=(\d+)\n(.*?)COMBINE_PERF_END rep=\1 mode=\2 ms=([\d.]+) exact=1', text, re.S):
    values = [dict((k, int(v)) for k, v in re.findall(r'(\w+)=(\d+)', line)) for line in match[3].splitlines() if line.startswith('DS4_PREFILL ')]
    values.sort(key=lambda x: x['gpu'])
    assert len(values) == 3
    metrics.append(values)
assert len(metrics) == 10 and all(x == metrics[0] for x in metrics)
print('PASS: 120 operator comparisons, 195 native states/9 answers, 10 exact timed feeds and identical routing/copy counters')
if args.raw_dir:
    print('PASS: all585 raw snapshots match independent reference hashes and decoded-path token receipts')
print('Native frozen-profile screening only; fresh-load API performance and serving acceptance are separate.')
