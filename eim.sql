set lines 400 pages 4000
col MODULE for a20
col EVENT for a40
col MACHINE for a15
col USERNAME for a15
col status for a15
select sid, serial#,status, username,TO_CHAR(logon_Time,'DD-MON-YYYY HH24:MI:SS'), machine,MODULE,event 
from v$session where MACHINE like 'BEL\INTRANET' and event like 'SQL*Net message from dblink';
