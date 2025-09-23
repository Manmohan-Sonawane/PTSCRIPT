set verify off
col sid format 99999
col machine format a10
col program format a25 trunc
col username format a10
col logontime format a15
col osuser format a10 trunc
col proginfo format a30 trunc
accept trgtsid number default 0 prompt 'What is the SID : '
select to_char(s.logon_time,'mm/dd hh24:mi:ss') logontime,
       s.sid,s.inst_id,s.status,s.type,s.username,s.osuser,s.machine,
       s.module || ' - ' || s.program proginfo,
       s.process,p.spid, s.sql_hash_value
from gv$session s, gv$process p
where sid = &trgtsid
and p.addr = s.paddr;
