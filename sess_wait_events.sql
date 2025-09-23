set lines 200;
set pages 2000;
col event for a50;
select sid, EVENT, TOTAL_WAITS, TIME_WAITED, WAIT_CLASS
from V$SESSION_EVENT
where WAIT_CLASS !='Idle'
order by TIME_WAITED;
