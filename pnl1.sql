set lines 200 pages 300;
col job_name for a20
col status for a20
select job_name,STATUS,ACTUAL_START_DATE,RUN_DURATION from dba_scheduler_job_run_details where job_name like 'HOSYS_PNL%' order by ACTUAL_START_DATE desc ;
