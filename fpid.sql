set verify off
col sid format 99999
col machine format a10
col program format a25 trunc
col username format a10
col logontime format a15
col osuser format a10 trunc
col proginfo format a30 trunc
select to_char(s.logon_time,'mm/dd hh24:mi:ss') logontime,
       s.sid,s.status,s.type,s.username,s.osuser,s.machine,
       s.module || ' - ' || s.program proginfo,
       s.process,p.spid, s.sql_hash_value
from v$session s, v$process p
where s.process='&a'
and p.addr = s.paddr;
