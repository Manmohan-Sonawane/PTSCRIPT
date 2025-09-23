set lines 150;
set pages 50;
select sid, serial#, username, schemaname, osuser,TO_CHAR(logon_Time,'DD-MON-YYYY HH24:MI:SS'), machine, terminal,status,MODULE,event from v$session where osuser='beldb' order by logon_time;
