select trunc(FIRST_TIME),count(1) Logswitch from gv$log_history
where trunc(first_time) >= trunc(sysdate-60)
group by trunc(FIRST_TIME) order by trunc(FIRST_TIME);

