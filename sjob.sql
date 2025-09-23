col JOB_NAME for a28
set lines 800 pages 8000 long 99999
col ACTUAL_START_DATE for a38
col REQ_START_DATE for a38
col owner for a12
col RUN_DURATION for a20
select JOB_NAME,ACTUAL_START_DATE,RUN_DURATION,OWNER,status from dba_scheduler_job_run_details where JOB_NAME='&jobname' order by ACTUAL_START_DATE asc;
