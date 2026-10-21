"""Regrade saved native evidence; optionally read all raw logit states."""
from pathlib import Path
import argparse,json,hashlib,array,math
p=argparse.ArgumentParser();p.add_argument('--raw-dir',type=Path);a=p.parse_args();r=Path(__file__).resolve().parent
for name,h in json.loads((r/'native-evidence-sha256.json').read_text()).items():assert hashlib.sha256((r/name).read_bytes()).hexdigest()==h,name
j=json.loads((r/'native-analysis.json').read_text());e=json.loads((r/'model-exit.json').read_text());h=json.loads((r/'native-reference-hashes.json').read_text());assert e['exit_code']==e['swap_peak_kib']==0
assert j['baseline_correct']==j['candidate_correct']==3 and j['baseline_repeats_exact'] and j['independent_accepted_4k_reference_states_exact']==195
count=answers=0
for c in j['cases']:
 assert len(c['steps'])==65 and len(c['answers'])==3
 for ans in c['answers']:
  text=ans['text'].strip()
  if text.startswith('```') and text.endswith('```'):text='\n'.join(text.splitlines()[1:-1])
  assert ans['correct'] and json.loads(text)==c['expected_answer'];answers+=1
  if a.raw_dir:assert [int(x) for x in (a.raw_dir/f"{c['id']}-trial{ans['trial']}-free-tokens.txt").read_text().split()]==ans['tokens']
 for step,v in enumerate(c['steps']):
  assert v['candidate_exact'] and v['baseline_repeat_exact'] and v['max_abs_error']==0 and v['relative_l2']==0;count+=1
  if a.raw_dir:
   for trial in range(3):
    data=(a.raw_dir/f"{c['id']}-trial{trial}-step{step}.f32").read_bytes();assert len(data)==129280*4 and hashlib.sha256(data).hexdigest()==h[c['id']][step]['sha256'];floats=array.array('f');floats.frombytes(data);assert all(math.isfinite(x) for x in floats)
assert count==195 and answers==9
print('PASS:195candidate/repeat/priorreference states exact,9answerscorrect,observedVmSwap0;notAPIperformanceacceptance')
if a.raw_dir:print('PASS:585rawstates independently checkedagainstpriorreferencehashes anddecodedtokens')
