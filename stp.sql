select a.sid,a.action,a.serial#, b.spid,a.username,a.osuser,a.machine,a.status,a.module
from v$session a, v$process b where a.paddr = b.addr and a.sid=&sid;
