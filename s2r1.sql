select f.request_id, v.spid,s.sid, s.username,s.serial#, s.osuser, s.status
from v$process v, v$session s, applsys.fnd_concurrent_requests f
where 1=1
and s.paddr=v.addr
and f.oracle_process_id=v.spid
and trunc(f.request_date)=trunc(sysdate)
and sid=&SID;
