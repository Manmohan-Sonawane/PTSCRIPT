set lines 600 pages 6000
col RUN_DURATION for a20
col JOB_NAME for a30
select job_name
, status
, actual_start_date
, run_duration
from dba_scheduler_job_run_details where job_name like '%&JOB%';
