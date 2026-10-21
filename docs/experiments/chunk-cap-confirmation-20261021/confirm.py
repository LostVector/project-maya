"""Regrade confirmation data, then recompute two-load means and paired intervals."""
from pathlib import Path
import json, statistics, math, subprocess, sys
def paired_latency_summary(winner_ms, comparator_ms):
    assert len(winner_ms) == len(comparator_ms) == 2
    assert all(math.isfinite(x) and x > 0 for x in winner_ms + comparator_ms)
    reductions = [100*(b-a)/b for a,b in zip(winner_ms, comparator_ms)]
    mean = statistics.mean(reductions)
    half = 12.7062047364321*statistics.stdev(reductions)/math.sqrt(2)
    return dict(block_latency_reduction_percent=reductions, mean_percent=mean,
                descriptive_unadjusted_t95_interval=[mean-half, mean+half])
root=Path(__file__).resolve().parent
data=json.loads((root/'confirmation.json').read_text())
assert data['workflow_exit']['exit_code']==0
raw=json.loads(subprocess.check_output([sys.executable,str(root/'summarize.py'),'confirmation.json'],text=True))
assert raw['correct_requests']==36
selected=data['protocol']['finalists_ranked_by_coarse_32k']
assert len(set(selected))==3
assert data['protocol']['caps']==list(reversed(selected))+selected
by={c:[(i,x) for i,x in enumerate(raw['results']) if x['cap']==c] for c in selected}
assert all(len(v)==2 and v[0][0]<3<=v[1][0] for v in by.values())
results=[]
for cap,loads in by.items():
    item=dict(cap=cap,load_indices=[i for i,x in loads],lengths={})
    for n in ['8192','32768']:
        ms=[x['lengths'][n]['mean_prompt_ms'] for i,x in loads]
        cases=[q for a in data['arms'] if a['cap']==cap for q in a['requests'] if not q['primer'] and q['expected_prompt_tokens']==int(n)]
        assert len(cases)==4
        mean=statistics.mean(ms)
        item['lengths'][n]=dict(mean_prompt_ms=mean,tokens_per_second=int(n)*1000/mean,load_mean_prompt_ms=ms,load_sample_sd_ms=statistics.stdev(ms),decode_tokens_per_second=sum(q['response']['timings']['predicted_n'] for q in cases)*1000/sum(q['response']['timings']['predicted_ms'] for q in cases),mean_expert_transfer_GB=statistics.mean(q['prefill_metrics']['total_streamed_weight_bytes']/1e9 for q in cases))
    results.append(item)
results.sort(key=lambda x:x['lengths']['32768']['mean_prompt_ms'])
comparisons={};winners={}
for n in ['8192','32768']:
    ranked=sorted(results,key=lambda x:x['lengths'][n]['mean_prompt_ms']);winner=ranked[0];winners[n]=winner['cap']
    comparisons[n]=[dict(winner=winner['cap'],comparator=x['cap'],**paired_latency_summary(winner['lengths'][n]['load_mean_prompt_ms'],x['lengths'][n]['load_mean_prompt_ms'])) for x in ranked[1:]]
print(json.dumps(dict(correct_requests=36,results=results,winner_observed_32k=winners['32768'],winner_observed_8k=winners['8192'],comparisons_32k=comparisons['32768'],comparisons_8k=comparisons['8192'],scope='Two independent loads per cap; both screens excluded. Descriptive unadjusted df1 paired intervals, conditional on observed winner selection. Short deterministic generations and limited retrieval only; no global optimum, broad quality or sustained decode claim.'),indent=2))
