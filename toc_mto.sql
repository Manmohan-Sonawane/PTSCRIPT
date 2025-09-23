col LOG_DATE for a40
col ACTUAL_START_DATE for a40
col RUN_DURATION for a20
set lines 800 pages 800
select  JOB_NAME, STATUS,ACTUAL_START_DATE,RUN_DURATION,LOG_DATE from dba_scheduler_job_run_details where job_name in ('TOC_MTO','TOCLUM_MTO') order by ACTUAL_START_DATE asc;
