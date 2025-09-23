select to_char(s.logon_time,'mm/dd hh24:mi:ss') logontime,
       s.sid,s.status,s.type,s.username,s.osuser,s.machine,
       s.module || ' - ' || s.program proginfo,
       s.process,p.spid, s.sql_hash_value
from v$session s, v$process p
where p.spid = '&a' and p.addr = s.paddr;

