from pathlib import Path
import json,sys,shutil,hashlib
repo=Path(__file__).resolve().parents[2];out=Path(sys.argv[1]).resolve();profile=Path(sys.argv[2]).resolve();out.mkdir(parents=True,exist_ok=True)
cases=repo/'data/exl3-matrix-quality-cases.json';protocol=repo/'docs/experiments/exl3-matrix-quality-protocol.json'
assert hashlib.sha256(cases.read_bytes()).hexdigest()==json.loads(protocol.read_text())['cases_sha256']
shutil.copy2(cases,out/'cases.json');shutil.copy2(protocol,out/'protocol.json');shutil.copy2(profile,out/'frozen-profile.bin')
items=json.loads(cases.read_text());(out/'case-list.txt').write_text(''.join(x['id']+'\n' for x in items))
for x in items:
 for field,suffix in [('prompt_ids','ids'),('answer_ids','answer-ids')]:
  (out/(x['id']+'-'+suffix+'.json')).write_text(json.dumps(x[field])+'\n')
