set lines 200 pages 300
select
SESSION_KEY, INPUT_TYPE, STATUS,
to_char(START_TIME,'mm/dd/yy hh24:mi') start_time,
to_char(END_TIME,'mm/dd/yy hh24:mi')   end_time,
elapsed_seconds/60 minutes
from V$RMAN_BACKUP_JOB_DETAILS
where input_type in ('DB FULL','DB INCR')
and start_time > sysdate-10
order by start_time desc;

