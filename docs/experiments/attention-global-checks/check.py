"""Regrade operator receipts and static ISA; does not run a GPU or model."""
from pathlib import Path
import collections
import json
import math
import re
import statistics

r = Path(__file__).resolve().parent
d = json.loads((r / 'checks.json').read_text())
initial = d['initial_screen_exit']
assert initial['exit_code'] == 0 and initial['all_exact_finite_guards'] and initial['isolated']
assert initial['before']['requests'] == initial['after']['requests']
assert d['confirmation']['all3_passed']
assert [x['gpu'] for x in d['confirmation']['results']] == [1, 0, 2]
logs = [('screen.log', initial)] + [(f"confirmation-gpu{x['gpu']}.log", x) for x in d['confirmation']['results']]
total = 0
for name, receipt in logs:
    lines = (r / name).read_text().splitlines()
    pairs = [dict(x.split('=', 1) for x in line.split()[1:]) for line in lines if line.startswith('PARITY ')]
    assert len(pairs) == receipt['comparisons'] == 72
    assert len({(x['case'], x['group'], x['global_reads']) for x in pairs}) == 72
    assert {x['group'] for x in pairs} == {'1', '2', '4', '8'}
    assert all(x['mismatches'] == '0' and x['finite'] == x['guards'] == '1' for x in pairs)
    assert lines[-1] == 'COMPLETE exact=1'
    assert receipt['before']['requests'] == receipt['after']['requests']
    assert receipt['before']['in_flight'] == receipt['after']['in_flight'] == 0
    total += len(pairs)
    timings = {}
    for line in lines:
        if not line.startswith('TIME '):
            continue
        x = dict(v.split('=', 1) for v in line.split()[1:])
        if x['warmup'] == '0':
            timings.setdefault((x['case'], int(x['group']), int(x['global_reads'])), []).append(float(x['gpu_ms']))
    assert len(timings) == 72 and all(len(x) == 8 for x in timings.values())
    if name == 'screen.log':
        saved = json.loads((r / 'screen-analysis.json').read_text())
        for case in saved['results']:
            for x in case['comparisons']:
                for flag, label in [(0, 'generic'), (1, 'global')]:
                    assert math.isclose(statistics.median(timings[case['case'], x['group'], flag]), x['median_gpu_ms'][label], rel_tol=1e-12)
    else:
        for case, x in receipt['G8_primary'].items():
            a, b = [statistics.median(timings[case, 8, flag]) for flag in (0, 1)]
            assert math.isclose(a, x['generic_median_ms'], rel_tol=1e-12)
            assert math.isclose(b, x['global_median_ms'], rel_tol=1e-12)
            assert math.isclose(100 * (1 - b / a), x['latency_reduction_percent'], abs_tol=1e-12)
assert total == 288
isa = json.loads((r / 'isa-analysis.json').read_text())['kernels']
metadata = (r / 'object-resource-metadata.txt').read_text()
for kernel in isa:
    asm = (r / (kernel['name'] + '.asm')).read_text()
    counter = collections.Counter()
    for line in asm.splitlines():
        match = re.match(r'\s*([a-z][a-z0-9_]+)\s+.*// [0-9A-Fa-f]+:', line)
        if match:
            counter[match[1]] += 1
    for op, count in kernel['instructions'].items():
        assert counter[op] == count
    glob = kernel['name'].endswith('global1')
    tag = 'sparse_attn_packed_kernelILi8ELb1E' + ('Lb1E' if glob else 'Lb0E')
    block = next(b for b in metadata.split('  - .args:') if tag in b)
    for key, value in kernel['resources'].items():
        assert int(re.search(r'\.' + key + r':\s+(\d+)', block)[1]) == value
    if glob:
        assert not any(count for op, count in counter.items() if op.startswith('flat_load'))
assert isa[0]['resources'] == isa[1]['resources']
print('PASS: 288 exact operator comparisons, timing medians, global-load ISA and unchanged object resources')
print('Operator evidence only; full-model correctness and speed are untested; selected serving does not enable this flag.')
