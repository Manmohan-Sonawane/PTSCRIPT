select SID,SERIAL# from gv$session
where audsid in (
select oracle_session_id
from apps.fnd_concurrent_requests
where request_id = &conc_req_number);

