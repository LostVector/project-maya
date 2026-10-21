from pathlib import Path
import json,re,statistics,hashlib,math
r=Path(__file__).resolve().parent;assert json.loads((r/'run-exit.json').read_text())['exit_code']==0;p=json.loads((r/'protocol.json').read_text());payload=json.loads((r/'payloads.json').read_text());assert hashlib.sha256((r/'payloads.json').read_bytes()).hexdigest()==p['payload_sha256'];all_rows=[];configs=[]
for i,label in enumerate(p['arms']):
 arm=r/f'arm{i}-{label}';assert json.loads((arm/'exit.json').read_text())['exit_code']==0
 cfg=json.loads((arm/'config.json').read_text());configs.append(cfg);assert cfg['env']['DS4_HIP_ATTN_SWIZZLE']==('1' if label=='candidate' else '0')
 assert cfg['args'][cfg['args'].index('--prefill-chunk')+1]=='4096'
 samples=json.loads((arm/'requests.json').read_text());assert len(samples)==6;assert 'PEER_AR_FAILURE' not in (arm/'engine.log').read_text()
 for x,c in zip(samples,payload):
  assert x['name']==c['name'] and x['primer']==c['primer'] and x['expected_prompt_tokens']==c['expected_prompt_tokens']
  before=x['activity_before'];after=x['activity_after'];assert before['in_flight']==after['in_flight']==0 and after['requests']==before['requests']+1 and x['swap_kib']==0
  answer=x['response'];choice=answer['choices'][0];text=choice['message']['content'].strip()
  if text.startswith('```') and text.endswith('```'):text='\n'.join(text.splitlines()[1:-1])
  assert choice['finish_reason']=='stop' and json.loads(text)==c['expected_answer']
  timing=answer['timings'];n=c['expected_prompt_tokens'];assert timing['cache_n']==0 and timing['prompt_n']==n and timing['prompt_ms']>0 and math.isfinite(timing['prompt_ms'])
  trace=(arm/(c['name']+'-prefill-trace.log')).read_text();metrics=[dict((k,int(v)) for k,v in re.findall(r'(\w+)=(\d+)',line)) for line in trace.splitlines() if line.startswith('DS4_PREFILL ')];metrics.sort(key=lambda x:x['gpu']);assert metrics==x['prefill_metrics']['per_gpu']
  copied={int(g):int(v) for g,v in re.findall(r'ds4 prompt batches, CUDA(\d+): (\d+) experts copied',trace)};assert len(copied)==3
  nc=(n+4095)//4096;per=(n+nc-1)//nc;keep=n-((n-2668)//per)*per;assert keep==x['prefill_metrics']['retained_rows']==4096
  for met in metrics:
   gpu=met['gpu'];assert met['expert_row_picks']==(6*(20*n+16*keep) if gpu<2 else 6*4*keep)
   assert met['unique_expert_uses']-met['vram_unique_expert_uses']==copied[gpu]
  logical=(metrics[0]['vram_row_picks']+metrics[2]['vram_row_picks'])/(metrics[0]['expert_row_picks']+metrics[2]['expert_row_picks']);assert math.isclose(logical,x['prefill_metrics']['logical_row_hit_fraction'],rel_tol=1e-15)
  assert sum(y['streamed_weight_bytes'] for y in metrics)==x['prefill_metrics']['total_streamed_weight_bytes']
  all_rows.append({'index':i,'label':label,'name':x['name'],'warmup':x['primer'],'n':n,'prompt_ms':timing['prompt_ms'],'predicted_ms':timing['predicted_ms'],'predicted_n':timing['predicted_n'],'correct':True})
assert all(c['args']==configs[0]['args'] and {k:v for k,v in c['env'].items() if k!='DS4_HIP_ATTN_SWIZZLE'}=={k:v for k,v in configs[0]['env'].items() if k!='DS4_HIP_ATTN_SWIZZLE'} for c in configs)
published=json.loads((r/'analysis.json').read_text());assert len(published['results'])==4;pooled={}
for n in [8192,32768]:
 variants={};decode={}
 for label in ['control','candidate']:
  samples=[x for x in all_rows if x['label']==label and x['n']==n and not x['warmup']];assert len(samples)==4
  variants[label]=n*1000*len(samples)/sum(x['prompt_ms'] for x in samples);decode[label]=sum(x['predicted_n'] for x in samples)*1000/sum(x['predicted_ms'] for x in samples)
  assert math.isclose(variants[label],published['pooled'][str(n)]['tokens_per_second'][label],rel_tol=1e-14)
 pooled[str(n)]={'prefill_tokens_per_second':variants,'throughput_increase_percent':100*(variants['candidate']/variants['control']-1),'short27token_decode_tokens_per_second':decode}
 pairs=[]
 for a,b in [(0,1),(3,2)]:
  mean={i:statistics.mean(x['prompt_ms'] for x in all_rows if x['index']==i and x['n']==n and not x['warmup']) for i in [a,b]};pairs.append(100*(1-mean[b]/mean[a]))
 assert all(math.isclose(a,b,abs_tol=1e-12) for a,b in zip(pairs,published['paired'][str(n)]['latency_reductions_percent']))
 center=sum(pairs)/2;half=abs(pairs[0]-pairs[1])/2*math.tan(math.pi*.475)
 assert math.isclose(center,published['paired'][str(n)]['mean_percent'],abs_tol=1e-12)
 assert all(math.isclose(x,y,abs_tol=1e-7) for x,y in zip([center-half,center+half],published['paired'][str(n)]['descriptive_t95_df1']))
out={'status':'Independent saved-response,tracecounter,configuration and arithmetic review complete','all24_correct_cache0_isolated_swap0':True,'timed_requests':16,'excluded_warmups':8,'results':pooled,'limitations':'Two independentfresh loads pervariant;CI with2pairedblocks isverywide. Short27token decode samples includelarge8Kstalls onbothvariants;not evidenceofsustained decodegain/regression. Rawstalls retained.','source_phase_sha256':{f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in ['protocol.json','payloads.json','analysis.json']}}
assert out==json.loads((r/'independent-review.json').read_text());print('PASS: all24 answers,tracecounter/configuration checks,pooled rates and paired intervals regraded');print(json.dumps(out,indent=2))
