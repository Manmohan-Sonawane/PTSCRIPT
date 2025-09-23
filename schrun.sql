set lines 800 pages 800
col OWNER for a20
col JOB_NAME for a50
col RUN_DURATION for a30
col RUN_DURATION for a40
col ACTUAL_START_DATE for a40 
select OWNER,JOB_NAME,ACTUAL_START_DATE,RUN_DURATION from dba_scheduler_job_run_details where JOB_NAME like '%&Jobname%';
