"""Summarize JSONL emitted by hip_pending_wait_bench.hip; never discard outliers."""
import argparse
import json
from pathlib import Path
import statistics


def quantile(values, q):
    ordered = sorted(values)
    position = q * (len(ordered) - 1)
    lower = int(position)
    upper = min(lower + 1, len(ordered) - 1)
    return ordered[lower] + (ordered[upper] - ordered[lower]) * (position - lower)


def summarize(path):
    records = [json.loads(line) for line in path.read_text().splitlines()]
    assert records[0]['type'] == 'environment', 'Missing environment header'
    assert records[-1] == {'type': 'complete', 'valid': True}, 'Incomplete run'
    environment = records[0]
    trials = records[1:-1]
    assert len(trials) == (environment['reps'] + 2) * 8, 'Missing or extra trials'
    assert all(t['type'] == 'trial' and t['valid'] for t in trials)
    groups = []
    for mode in ('eager', 'graph'):
        for waits in (0, 1, 2, 4):
            selected = [t for t in trials if t['mode'] == mode and t['waits'] == waits]
            assert sorted(t['rep'] for t in selected) == list(range(-2, environment['reps']))
            assert all(t['warmup'] == (t['rep'] < 0) for t in selected)
            measured = [t for t in selected if not t['warmup']]
            values = [t['us_per_kernel'] for t in measured]
            groups.append({
                'mode': mode, 'waits': waits, 'n': len(values),
                'median_us': statistics.median(values),
                'p10_us': quantile(values, 0.1), 'p90_us': quantile(values, 0.9),
                'min_us': min(values), 'max_us': max(values),
                'big_median_ms': statistics.median(t['big_ms'] for t in measured),
                'pending_before_start_all': all(t['pending_before_start'] for t in measured),
            })
    return {'environment': environment, 'groups': groups}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('jsonl', type=Path, nargs='+')
    arguments = parser.parse_args()
    results = [summarize(path) for path in arguments.jsonl]
    print(json.dumps(results, indent=2))
    if not all(g['pending_before_start_all'] for r in results for g in r['groups']):
        raise SystemExit('A timing condition did not keep waits pending; inspect raw records.')
