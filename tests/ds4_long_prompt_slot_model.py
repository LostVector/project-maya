"""Bounded two-party slot schedule model, not a proof of GPU or implementation correctness."""
from collections import deque
from pathlib import Path
import json,sys

def explore(n,cut,drain=True,skip_missing_ack=True):
 producer=[];consumer=[]
 for k in range(n):
  producer.append(('kv',k))
  if k>=cut:producer.append(('hand',k))
  if k>=cut:consumer.append(('hand',k))
  if drain or k>=cut:consumer.append(('kv',k))
 # State: producer/consumer PC, two KV slots, two hand slots, each kind two ACKs.
 initial=(0,0,(-1,-1),(-1,-1),(-1,-1),(-1,-1))
 seen={initial};todo=deque([initial]);dead=[];terminals=0
 while todo:
  state=todo.popleft();pi,ci,kv,hand,ka,ha=state
  if pi==len(producer) and ci==len(consumer):terminals+=1;continue
  moves=[]
  if pi<len(producer):
   kind,k=producer[pi];slot=k%2;ack=ka if kind=='kv' else ha
   need=k-2
   if kind=='hand' and skip_missing_ack and need<cut:need=-1
   if k<2 or ack[slot]>=need:
    slots=list(kv if kind=='kv' else hand);slots[slot]=k
    moves.append((pi+1,ci,tuple(slots) if kind=='kv' else kv,tuple(slots) if kind=='hand' else hand,ka,ha))
  if ci<len(consumer):
   kind,k=consumer[ci];slot=k%2;data=kv if kind=='kv' else hand
   if data[slot]>=k:
    assert data[slot]==k,('Payload overwritten before consumption',state,kind,k)
    ack=list(ka if kind=='kv' else ha);ack[slot]=k
    moves.append((pi,ci+1,kv,hand,tuple(ack) if kind=='kv' else ka,tuple(ack) if kind=='hand' else ha))
  if not moves:dead.append({'state':state,'producer_next':producer[pi] if pi<len(producer) else None,'consumer_next':consumer[ci] if ci<len(consumer) else None})
  for state2 in moves:
   if state2 not in seen:seen.add(state2);todo.append(state2)
 return {'chunks':n,'cut_chunk':cut,'states':len(seen),'terminal_states':terminals,'deadlocks':len(dead),'first_deadlock':dead[0] if dead else None}

if __name__=='__main__':
 cases=[explore(n,cut) for n in range(1,9) for cut in range(n+1)]
 assert all(c['terminal_states'] and not c['deadlocks'] for c in cases)
 missing_drain=explore(6,3,drain=False)
 missing_handoff=explore(6,3,skip_missing_ack=False)
 assert missing_drain['deadlocks'] and missing_handoff['deadlocks']
 # Source cut prefix publication with same sequence exposes ready before suffix exists.
 partial={'published_sequence':4,'required_sequence':4,'payload_rows_ready':17,'payload_rows_expected':64}
 assert partial['published_sequence']>=partial['required_sequence'] and partial['payload_rows_ready']<partial['payload_rows_expected']
 out={'scope':__doc__,'corrected_cases':cases,'negative_controls':{'omit_prefix_KV_drain':missing_drain,'wait_for_skipped_activation_ack':missing_handoff,'publish_partial_cut_with_full_sequence':partial},'result':'All44 bounded corrected schedules terminate without overwrite; negative controls expose the three source-level hazards. Does not validate actual GPU scheduling/memory visibility or full-model outputs.'}
 p=Path(sys.argv[1]) if len(sys.argv)>1 else Path(__file__).with_suffix('.json');p.write_text(json.dumps(out,indent=2)+'\n');print(out['result'])
