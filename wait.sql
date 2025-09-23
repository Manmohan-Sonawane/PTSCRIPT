col username format a12
col sid format 9999
col state format a15
col event format a45
col wait_time format 99999999
set pagesize 800
set linesize 800
select TO_CHAR(LOGON_TIME,'dd-mon-yyyy hh24:mi') LOGON_TIME,s.sid, s.username, se.event
from v$session s, v$session_wait se
where s.sid=se.sid
and se.event not like 'SQL*Net%'
--and se.event like '%dblink%'
and se.event not like '%rdbms%'
and s.username is not null
order by 4;
