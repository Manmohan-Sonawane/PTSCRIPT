select a.sid, a.serial#, b.spid, a.process, to_char(a.logon_time,'DD-MM HH24:MI:SS') LogonDate,
 a.status,a.action, a.module, c.seconds_in_wait/60 Idle
from v$session a, v$process b ,v$session_wait c
where a.paddr = b.addr and a.action like '%FRM%' and a.sid=c.sid
order by a.action
/

