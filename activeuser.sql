/* active.sql
    show info about active user sessions */
col sid format 99999
col username format a5 trunc
col osuser format a10 trunc
col logged_on format a13 head LOGON_TIME
col machine format a10 trunc
col program format a20 trunc
col proginfo format a25 trunc
set verify off
accept trgtmod char default ALL prompt 'Restrict to which module <ALL> : '
accept trgtmach char default ALL prompt 'Restrict to which originating server <ALL> : '
select s.sid,s.status,s.username,s.osuser,s.machine,s.sql_hash_value,s.command,s.process, p.spid,
   to_char(logon_time,'mm/dd hh:miAM') logged_on, 
   s.module || ' - ' || s.program proginfo
from v$session s, v$process p
where s.username is not null
and s.type = 'USER'
and s.paddr = p.addr
and s.status = 'ACTIVE'
and (upper(s.module) like upper('%&trgtmod%') or upper('&trgtmod') = 'ALL') 
and (upper(s.machine) like upper('%&trgtmach%') or upper('&trgtmach') = 'ALL') 
/

