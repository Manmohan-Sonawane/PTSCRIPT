set lines 200;
col EVENT for a60;
col WAIT_CLASS for a40;
select EVENT, TOTAL_WAITS, TIME_WAITED, WAIT_CLASS from V$SYSTEM_EVENT
where wait_class != 'Idle'
order by 3,4;
