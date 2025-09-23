select STATUS,ACTUAL_START_DATE,RUN_DURATION from dba_scheduler_job_run_details where job_name='NG_BEL_UPDATEALL_PAYMNT_STATUS' order by ACTUAL_START_DATE desc ;
