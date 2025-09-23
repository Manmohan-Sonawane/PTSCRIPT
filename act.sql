set linesize 120
set pagesize 120
column sid format 9999
column serial# format 99999999
column username format A15
column schemaname format A9
column osuser format a15
column machine format a32
column terminal format a15
select sid, serial#, username, schemaname, osuser,TO_CHAR(logon_Time,'DD-MON-YYYY HH24:MI:SS'), machine, terminal,status,MODULE from v$session
; 
