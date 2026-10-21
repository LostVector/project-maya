from pathlib import Path
import json,hashlib,sys,numpy as np
repo=Path(__file__).resolve().parents[2];sys.path[:0]=[str(repo),str(repo/'tools')]
import strata_tokenizer as ST
tok=ST.Tokenizer.from_dir(Path(sys.argv[2]).resolve())
r=Path(sys.argv[1]).resolve();manifest=json.loads((r/'input-manifest.json').read_text());count=manifest['decode_steps']+1;rows=[]
def parse_json(text):
 text=text.strip()
 if text.startswith('```') and text.endswith('```'):
  lines=text.splitlines();text='\n'.join(lines[1:-1])
 try:return json.loads(text)
 except (ValueError,TypeError):return None
for case in manifest['cases']:
 name=case['id']
 for suffix,key in [('ids','prompt_sha256'),('prefix','prefix_sha256')]:assert hashlib.sha256((r/(name+'-'+suffix+'.json')).read_bytes()).hexdigest()==case[key]
 decisions=[];answers=[]
 for trial in range(3):
  v=[int(x) for x in (r/(name+'-trial'+str(trial)+'-argmax.txt')).read_text().split()];assert len(v)==count;decisions.append(v)
  free=[int(x) for x in (r/(name+'-trial'+str(trial)+'-free-tokens.txt')).read_text().split()];assert 0<len(free)<=manifest['decode_steps']
  source=(r/(name+'-trial'+str(trial)+'-free-source.txt')).read_text().strip();assert source in ['baseline_greedy_path','matching_decisions_through_EOS','independent_free_generation']
  if source=='matching_decisions_through_EOS':assert free==decisions[0][:len(free)] and v[:len(free)]==free
  eos=free.index(1) if 1 in free else len(free);text=tok.decode(free[:eos]);parsed=parse_json(text)
  answers.append({'trial':trial,'source':source,'tokens':free,'stopped_at_EOS':1 in free,'text':text,'parsed_json':parsed,'correct':parsed==case['expected_answer']})
 assert answers[0]['tokens']==answers[2]['tokens'],name
 eos=decisions[0].index(1) if 1 in decisions[0] else count-1
 steps=[]
 for step in range(count):
  vals=[np.fromfile(r/(name+'-trial'+str(trial)+'-step'+str(step)+'.f32'),dtype=np.float32) for trial in range(3)]
  assert all(len(x)==129280 and np.isfinite(x).all() for x in vals)
  assert vals[0].tobytes()==vals[2].tobytes(),(name,step,'baseline repeat differs')
  x,y=[v.astype(np.float64) for v in vals[:2]];delta=y-x;lx=x-x.max();lx-=np.log(np.exp(lx).sum());ly=y-y.max();ly-=np.log(np.exp(ly).sum());kl=float(np.sum(np.exp(lx)*(lx-ly)));assert np.isfinite(kl) and kl>=-1e-12
  steps.append({'step':step,'through_first_baseline_EOS':step<=eos,'baseline_repeat_exact':True,'candidate_exact':vals[0].tobytes()==vals[1].tobytes(),'top1_matches':decisions[0][step]==decisions[1][step],'kl':kl,'max_abs_error':float(np.max(np.abs(delta))),'relative_l2':float(np.linalg.norm(delta)/max(np.linalg.norm(x),1e-300))})
 rows.append({'id':name,'expected_answer':case['expected_answer'],'answers':answers,'prefill_kl':steps[0]['kl'],'max_kl_all_steps':max(x['kl'] for x in steps),'max_kl_through_first_EOS':max(x['kl'] for x in steps if x['through_first_baseline_EOS']),'steps':steps})
base=sum(c['answers'][0]['correct'] for c in rows);cand=sum(c['answers'][1]['correct'] for c in rows);reg=[c['id'] for c in rows if c['answers'][0]['correct'] and not c['answers'][1]['correct']]
out={'scope':'Frozen synthetic retrieval cases; actual free answers or equivalent matching decisions throughEOS.65 full-vocabulary states along identical baseline continuation. All postEOS rows retained. No broad quality or controlled speed acceptance.','baseline_repeats_exact':True,'baseline_correct':base,'candidate_correct':cand,'cases_count':len(rows),'observed_quality_regressions':reg,'review_flags':{'any_candidate_decision_divergence':any(any(not x['top1_matches'] for x in c['steps']) for c in rows),'any_row_kl_above_0_001':any(c['max_kl_all_steps']>0.001 for c in rows)},'cases':rows}
(r/'analysis.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'baseline_correct':base,'candidate_correct':cand,'cases_count':len(rows),'observed_quality_regressions':reg,'review_flags':out['review_flags']},indent=2))
