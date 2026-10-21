#!/usr/bin/env python3
"""Reproduce the recorded chunk comparison using only the Python standard library."""
from pathlib import Path
import json,math,statistics
p=Path(__file__).with_name('ds4-prefill-chunk-api-20261021.json');data=json.loads(p.read_text());arms=data['arms']
assert [a['chunk'] for a in arms]==[2048,4096,4096,2048]
assert sum(not s['primer'] for a in arms for s in a['samples'])==16
assert data['aborted_quality_only_load']['timed_requests']==0
for a in arms:
 assert len(a['samples'])==6 and all(s['correct'] and s['isolated'] and s['swap_kib']==0 for s in a['samples'])
 assert all(s['timings']['cache_n']==0 and s['timings']['prompt_n']==s['prompt_tokens'] for s in a['samples'])
results=[]
for n in [8192,32768]:
 means=[statistics.mean(s['timings']['prompt_ms'] for s in a['samples'] if not s['primer'] and s['prompt_tokens']==n) for a in arms]
 blocks=[100*(1-means[b]/means[a]) for a,b in [(0,1),(3,2)]]
 mean=statistics.mean(blocks);half=12.706204736*statistics.stdev(blocks)/math.sqrt(2)
 recorded=next(x for x in data['results'] if x['prompt_tokens']==n)
 assert means==recorded['arm_mean_prefill_ms'] and blocks==recorded['paired_latency_reductions_percent']
 assert math.isclose(mean,recorded['mean_paired_latency_reduction_percent'],abs_tol=1e-12)
 assert all(math.isclose(a,b,abs_tol=1e-12) for a,b in zip([mean-half,mean+half],recorded['student_t_95_interval_percent']))
 results.append(dict(prompt_tokens=n,mean_latency_reduction_percent=mean,student_t_95_interval_percent=[mean-half,mean+half]))
print(json.dumps(results,indent=2))
