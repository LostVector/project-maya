from pathlib import Path
import json,sys,re,ast,statistics,hashlib
repo=Path(__file__).resolve().parents[2];r=Path(sys.argv[1]).resolve();sys.path.insert(0,str(repo/'tools'))
import strata_tokenizer as ST
tok=ST.Tokenizer.from_dir(sys.argv[2])
protocol=json.loads((r/'protocol.json').read_text());assert hashlib.sha256((r/'cases.json').read_bytes()).hexdigest()==protocol['cases_sha256']
cases=json.loads((r/'cases.json').read_text());scores=[json.loads(x) for x in (r/'scores.jsonl').read_text().splitlines()];assert len(scores)==24
index={(x['id'],x['mode']):x for x in scores};assert len(index)==24
# Predeclared normalization: whitespace/outer code delimiters; Python literals compare by value.
def normal(text):
 text=text.strip()
 if text.startswith('```') and text.endswith('```'):text='\n'.join(text.splitlines()[1:-1]).strip()
 text=text.strip('`').strip()
 try:return ('literal',ast.literal_eval(text))
 except (ValueError,SyntaxError):return ('text',text.casefold() if text in ['Yes','No','yes','no'] else text)
out=[]
for case in cases:
 arms=[]
 for mode in [0,1]:
  score=index[(case['id'],mode)];assert score['prompt_tokens']==case['prompt_tokens'] and score['answer_tokens']==len(case['answer_ids'])
  ids=[int(x) for x in (r/(case['id']+'-mode'+str(mode)+'-tokens.txt')).read_text().split()];text=tok.decode(ids)
  arms.append(dict(mode=mode,text=text,ended=score['ended'],passed=score['ended'] and normal(text)==normal(case['expected_answer']),answer_mean_nll=score['answer_nll_sum']/score['answer_tokens']))
 out.append(dict(id=case['id'],expected=case['expected_answer'],long_context=case['long_context'],arms=arms,regression=arms[0]['passed'] and not arms[1]['passed']))
result=dict(scope='Twelve-task handcrafted smoke screen, not broad quality proof',cases=out,baseline_pass=sum(x['arms'][0]['passed'] for x in out),candidate_pass=sum(x['arms'][1]['passed'] for x in out),regressions=[x['id'] for x in out if x['regression']],mean_case_nll_delta=statistics.mean(x['arms'][1]['answer_mean_nll']-x['arms'][0]['answer_mean_nll'] for x in out))
(r/'analysis.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
