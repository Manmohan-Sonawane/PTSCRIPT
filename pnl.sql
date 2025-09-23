set lines 200 pages 300;
select STATUS,ACTUAL_START_DATE,RUN_DURATION from dba_scheduler_job_run_details where job_name='HOSYS_PNL1' order by ACTUAL_START_DATE desc ;
