set lines 190
cle bre
col sid form 99999
col start_time head "Start|Time" form a12 trunc
col opname head "Operation" form a12 trunc
col target head "Object" form a10 trunc
col totalwork head "Total|Work" form 9999999999 trunc
col Sofar head "Sofar" form 9999999999 trunc
col elamin head "Elapsed|Time|(Mins)" form 99999999 trunc
col tre head "Time|Remain|(Mins)" form 999999999 trunc
col message for a55 trunc

select sid,serial#,to_char(start_time,'dd-mon:hh24:mi') start_time,
         opname,target,totalwork,sofar,(elapsed_Seconds/60) elamin,
         time_remaining/60 tre,message
from v$session_longops
where totalwork <> SOFAR and sid='&SID'
order by start_time
/

