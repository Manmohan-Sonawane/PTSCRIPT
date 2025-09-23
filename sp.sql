set linesize 120
set pagesize 120
column sid format 9999
column serial# format 99999999
column status format A15
column osuser format a15
column event format a32
column terminal format a15
select sid, serial#, status,last_call_et,module, osuser,event, terminal from v$session where type='USER' order by logon_time;
/
