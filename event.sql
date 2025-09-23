set lines 150
set pages 1000
col event format a35

select event,count(*) from v$session_wait group by event order by 2
/

col sql format a35
col username format a15
col child format 999
col secs format 9999
col machine format a12
col event format a25
col state format a10

select /*+ rule */ distinct 
w.inst_id,w.sid,s.username,substr(w.event,1,25) event,substr(s.machine,1,12) machine,substr(w.state,1,10) state,
substr(q.sql_text,1,33) "SQL",round(s.LAST_CALL_ET) SECS
from gv$session_wait w,gv$session s,gv$sql q where w.event like '%&event%'
and w.sid=s.sid
and s.SQL_HASH_VALUE=q.HASH_VALUE
and s.status='ACTIVE'
and s.username is not null
and substr(w.event,1,25) not like 'SQL*Net message from clie%'
order by "SECS"
/



