Select fcpp.concurrent_request_id,fcpp.processor_id,v.PROGRAM,
v.ACTUAL_START_DATE,
(nvl(v.ACTUAL_COMPLETION_DATE,sysdate)-v.ACTUAL_START_DATE)*(24*60) tt,v.PHASE_CODE,v.STATUS_CODE
from fnd_conc_pp_actions fcpp,FND_CONC_REQ_SUMMARY_V v,
FND_CONCURRENT_REQUESTS r,fnd_concurrent_processes fcp
where v.REQUEST_ID=r.REQUEST_ID
and fcpp.processor_id = fcp.concurrent_process_id (+)
and fcpp.concurrent_request_id=v.REQUEST_ID
and v.PHASE_CODE='R'and v.STATUS_CODE='R'
AND fcpp.action_type = 6
order by fcpp.processor_id
