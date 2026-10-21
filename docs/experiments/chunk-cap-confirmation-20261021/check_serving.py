"""Regrade the limited quality and production-conversation serving checks."""
from pathlib import Path
import ast,json
def normal(text):
    text=text.strip()
    if text.startswith('```') and text.endswith('```'):text='\n'.join(text.splitlines()[1:-1]).strip()
    text=text.strip('`').strip()
    try:return ('literal',ast.literal_eval(text))
    except (ValueError,SyntaxError):return ('text',text.casefold() if text in ['Yes','No','yes','no'] else text)
root=Path(__file__).resolve().parent
data=json.loads((root/'serving-checks.json').read_text())
gold=data['quality_cases']
def grade(rows):
    assert len(rows)==len(gold)==12 and [x['id'] for x in rows]==[x['id'] for x in gold]
    flags=[]
    for x,g in zip(rows,gold):
        choice=x['response']['choices'][0]
        assert choice['message']['content']==x['text']
        passed=choice['finish_reason']=='stop' and normal(x['text'])==normal(g['expected_answer'])
        assert passed==x['passed']
        flags.append(passed)
    return flags
candidate=grade(data['quality_candidate']);controls=[grade(x['rows']) for x in data['quality_controls']]
regressions=[g['id'] for i,g in enumerate(gold) if all(x[i] for x in controls) and not candidate[i]]
assert not regressions and sum(candidate)>=min(sum(x) for x in controls)
smoke=data['smoke_responses'];assert len(smoke)==3
for i,x in enumerate(smoke):
    c=data['smoke_cases'][min(i,1)]
    choice=x['response']['choices'][0];assert choice['finish_reason']=='stop'
    text=choice['message']['content'].strip()
    if text.startswith('```') and text.endswith('```'):text='\n'.join(text.splitlines()[1:-1])
    assert json.loads(text)==c['expected']
    timing=x['response']['timings']
    if i<2:assert timing['cache_n']==0 and timing['prompt_n']==c['full_rendered_prompt_tokens']
    else:assert timing['cache_n']>=32000
print(json.dumps(dict(quality_correct=sum(candidate),quality_total=12,baseline_scores=[sum(x) for x in controls],failed_quality_cases=[g['id'] for g,p in zip(gold,candidate) if not p],stable_baseline_regressions=regressions,smoke_correct=3,actual_followup_cache_tokens=smoke[-1]['response']['timings']['cache_n'],scope='Limited integration checks; no broad quality or full256K benchmark claim.'),indent=2))
