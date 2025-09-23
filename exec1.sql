col last_load_time for a50
select FETCHES,EXECUTIONS,rows_processed,sql_id,last_load_time,TO_CHAR(last_active_time,'DD-MON-YYYY HH24:MI:SS') last_active_time,plan_hash_value,PHYSICAL_READ_REQUESTS,ELAPSED_TIME from v$sql where sql_id='&SQLID';
