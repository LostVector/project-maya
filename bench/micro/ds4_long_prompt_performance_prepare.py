from pathlib import Path
import sys,json,hashlib,random
repo=Path(__file__).resolve().parents[2];sys.path[:0]=[str(repo),str(repo/'tools')]
from serve.frontend import ChatTemplate,effort_kwargs
import strata_tokenizer as ST
assert len(sys.argv)==4,'usage: prepare.py OUTPUT TOKENIZER_DIR FROZEN_PROFILE'
r=Path(sys.argv[1]);r.mkdir(parents=True,exist_ok=True);p=Path(sys.argv[2]);tok=ST.Tokenizer.from_dir(p);template=ChatTemplate(p/'chat_template.jinja');rng=random.Random(20261020)
records=[f'Record {i:04d}: station sector-{i:04d} reports inventory {rng.randrange(10000,99999)}, cycle {i%17}, and archive cedar-{i+5000}.\n' for i in range(3000)]
specs=[('study_8k','Lima',8192,0,0),('study_32k','Kyoto',32768,0,64),('resume_pruned_prefix','Tallinn',512,8192,0)];manifest=[]
for name,city,n,prefix_n,position in specs:
 codes=[rng.randrange(100000,1000000) for _ in range(6)];key='QX-'+name
 fact=f'Authoritative deployment entry {key}: backup region is {city}; authorization codes in order are '+json.dumps(codes)+'.\n'
 intro='Read the reference records. Only the authoritative deployment entry answers the final question.\n'
 content=intro+''.join(records[:position])+fact+''.join(records[position:])+'End of reference records.\n\n'+f'For authoritative deployment entry {key}, return exactly a JSON object with keys "region" and "codes", containing its backup region and the complete authorization code list in order. Return only JSON.'
 rendered=template.render([dict(role='user',content=content)],tools=None,**effort_kwargs('none'));all_ids=tok.encode(rendered,parse_special=True)
 assert len(all_ids)>n+prefix_n+1024
 full=all_ids[:n+prefix_n-256]+all_ids[-256:]
 decoded=tok.decode(full);assert fact.strip() in decoded and key in decoded and 'authorization code list' in decoded
 if prefix_n:assert fact.strip() in tok.decode(full[:prefix_n]),'Cached-prefix needle must be entirely before append'
 prompt=full[prefix_n:];prefix=full[:prefix_n];assert len(prompt)==n
 for suffix,ids in [('ids',prompt),('prefix',prefix)]:(r/(name+'-'+suffix+'.json')).write_text(json.dumps(ids)+'\n')
 expected={'region':city,'codes':codes}
 manifest.append({'id':name,'new_tokens':n,'prefix_tokens':prefix_n,'expected_skipping':n>=3692,'expected_prefix_skipping_in_candidate':prefix_n>=3692,'needle_record_position':position,'expected_answer':expected,'prompt_sha256':hashlib.sha256((r/(name+'-ids.json')).read_bytes()).hexdigest(),'prefix_sha256':hashlib.sha256((r/(name+'-prefix.json')).read_bytes()).hexdigest(),'needle_text':fact.strip()})
(r/'input-manifest.json').write_text(json.dumps({'scope':'Two timing cases and a pruned-prefix-resume quality case frozen before controlled timing results, not broad quality evidence. Facts must be retrieved from skipped/cached prefix; longer JSON answers permit meaningful preEOS comparison.','decode_steps':64,'chunk':2048,'construction':'3000 unique generated reference records. Preserve first(total-256) and last256 token IDs, deleting only unrelated middle records; verify complete needle and final question survive.','seed':20261020,'template_sha256':hashlib.sha256((p/'chat_template.jinja').read_bytes()).hexdigest(),'cases':manifest},indent=2)+'\n');(r/'case-list.txt').write_text(''.join(x['id']+'\n' for x in manifest));(r/'frozen-profile.bin').write_bytes(Path(sys.argv[3]).read_bytes());print([(x['id'],x['new_tokens'],x['prefix_tokens'],x['expected_answer']) for x in manifest])
