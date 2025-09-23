set linesize 120
set pagesize 120
column sid format 9999
column serial# format 99999999
column username format A15
column schemaname format A9
column osuser format a15
column machine format a32
column terminal format a15
set lines 400 
col USERNAME for a8
col OSUSER for a7
col EVENT for a20
col MODULE for a25
col MACHINE for a12
col TERMINAL for a8
select sid, serial#, username, schemaname, osuser,TO_CHAR(logon_Time,'DD-MON-YYYY HH24:MI:SS'), machine, terminal,status,MODULE,event from gv$session where status='ACTIVE' and type='USER' order by logon_time
/
