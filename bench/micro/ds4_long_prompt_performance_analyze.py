from pathlib import Path
import json, math, statistics, sys

assert len(sys.argv)==2,'usage: analyze.py RUN_DIRECTORY'
r = Path(sys.argv[1])
assert json.loads((r/'model-exit.json').read_text())['exit_code'] == 0
assert json.loads((r/'gate-review.json').read_text())['decision'] == 'APPROVED'
rows = [json.loads(s) for s in (r/'performance.jsonl').read_text().splitlines()]
assert len(rows) == 24
visits = [('study_8k',0),('study_32k',0),('study_8k',1),('study_32k',1),('study_8k',2),('study_8k',3)]
for i,x in enumerate(rows):
    case, block = visits[i//4]
    order = [0,1,1,0] if block%2 == 0 else [1,0,0,1]
    assert (x['case'],x['block'],x['position'],x['sample'],x['mode']) == (case,block,i%4,i,order[i%4])
    assert x['finite'] and math.isfinite(x['prefill_ms']) and x['prefill_ms'] > 0
    assert x['swap_before_kib'] == x['swap_after_kib'] == 0
    assert x['plans'] == x['mode'] and x['matrix'] == x['whole_chunks'] == 1 and x['chunk'] == 2048
    assert x['new_tokens'] == (8192 if case=='study_8k' else 32768)
results = []
for case,n,tcrit in [('study_8k',4,3.182446305),('study_32k',2,12.706204736)]:
    selected = [x for x in rows if x['case']==case]
    blocks = []
    for b in range(n):
        arms = [[x['prefill_ms'] for x in selected if x['block']==b and x['mode']==mode] for mode in [0,1]]
        assert all(len(a)==2 for a in arms)
        a,bmean = map(statistics.mean,arms)
        blocks.append({'block':b,'control_ms':a,'candidate_ms':bmean,'latency_reduction_percent':100*(1-bmean/a)})
    gains = [x['latency_reduction_percent'] for x in blocks]
    mean = statistics.mean(gains); half = tcrit*statistics.stdev(gains)/math.sqrt(n)
    arms = []
    for mode in [0,1]:
        s = [x for x in selected if x['mode']==mode]
        ms = statistics.mean(x['prefill_ms'] for x in s)
        arms.append({'mode':mode,'mean_ms':ms,'tokens_per_second':s[0]['new_tokens']*1000/ms,'read_bytes_total':sum(x['read_bytes'] for x in s)})
    results.append({'case':case,'blocks':blocks,'mean_latency_reduction_percent':mean,'student_t_95_interval_percent':[mean-half,mean+half],'arms':arms})
out = {'all24_samples_retained':True,'limits':'Within one model session, warm engram/file cache; synthetic prompts; no independent-load, cold-disk, general-quality or decode-speed claim. Intervals describe paired time blocks.','results':results,'samples':rows}
(r/'performance-analysis.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(results,indent=2))
