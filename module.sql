set linesize 400
set pagesize 200
column sid format 9999
column serial# format 99999999
column username format A15
column schemaname format A9
column osuser format a15
column machine format a15
column terminal format a15
column module for a20
column event for a20
select sid, serial#, username, schemaname, osuser,TO_CHAR(logon_Time,'DD-MON-YYYY HH24:MI:SS'), machine, terminal,status,MODULE,event from v$session where MODULE LIKE '%&M%' order by logon_time;
