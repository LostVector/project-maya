from pathlib import Path
import hashlib,json,re,statistics,math
r=Path(__file__).resolve().parent
for name,h in json.loads((r/'evidence-sha256.json').read_text()).items():assert hashlib.sha256((r/name).read_bytes()).hexdigest()==h,name
expected=json.loads((r/'quick-screen-analysis.json').read_text());confirmation=json.loads((r/'confirmation-review.json').read_text());count=0
for index,name in enumerate(['screen-gpu1.log','confirm-gpu1.log','confirm-gpu0.log','confirm-gpu2.log']):
 text=(r/name).read_text();assert 'COMPLETE exact=1' in text;parity=[];times={}
 for line in text.splitlines():
  if line.startswith('PARITY '):
   x=dict(re.findall(r'(\w+)=([^ ]+)',line));assert x['mismatches']==x['cpu_mismatches']=='0' and x['finite']==x['guards']=='1';parity.append(x)
  elif line.startswith('TIME '):
   x=dict(re.findall(r'(\w+)=([^ ]+)',line))
   if x['warmup']=='0':times.setdefault(x['case'],{}).setdefault(x['mode'],[]).append(float(x['gpu_ms']))
 assert len(parity)==39 and len(times)==13;count+=len(parity)
 assert {x['case'] for x in parity}==set(times)
 assert len({(x['case'],x['mode']) for x in parity})==39
 for case,t in times.items():
  assert set(t)=={'0','2','3'} and all(len(v)==12 for v in t.values());med={m:statistics.median(v) for m,v in t.items()}
  if index==0:
   assert med==expected['cases'][case]['medians_ms']
   assert math.isclose(100*(1-med['3']/med['2']),expected['cases'][case]['mode3_latency_reduction_vs_selected_mode2_percent'],abs_tol=1e-12)
  else:assert med==confirmation['gpus'][index-1]['medians_ms'][case]
assert count==confirmation['initial_plus_confirmation_checks']==156 and confirmation['all_pass']
print('PASS:156exactfiniteguardchecksacross3GPUs,CPUfma smallcases,andalloperator medians regraded;not fullmodel/API acceptance')
