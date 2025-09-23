


set pagesize 500
set linesize 200
col sid for 99999999 
col serial for 99999
col module for a20 trunc
col action for a20 trunc
col program for a20 trunc
col event for a20 trunc
col dt for a12 trunc
col request_id for 99999999
col uname for a10

select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "DATE" from dual;
select 	request_id,s.sid sid,s.serial# serial,to_char(logon_time,'dd/mm hh:mi') dt,s.module module,s.action action,fu.user_name uname,sw.event
from	v$session_wait sw,v$session s,v$process p,fnd_concurrent_requests fnd,fnd_user fu 
where 	sw.sid = s.sid
and	p.addr = s.paddr
and	p.spid = fnd.oracle_process_id
and	fnd.status_code = 'R'
and	fnd.phase_code = 'R'
and 	fnd.requested_by=fu.user_id
order by 4
/


