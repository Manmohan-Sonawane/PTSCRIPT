colu INPUT_BYTES_PER_SEC_DISPLAY format A12
colu OUTPUT_BYTES_PER_SEC_DISPLAY format A12
colu OUTPUT_BYTES_DISPLAY format A12
colu TIME_TAKEN_DISPLAY format A12
colu InputGB format  999999.99
colu OutputGB format 999999.99
colu elptime  format 999.999
select db_name, to_char(start_time,'DD-MM-YYYY HH24:MI:SS') StartTime, to_char(End_time,'   DD-MM-YYYY HH24:MI:SS') End_Time,
input_bytes/1024/1024/1024 InputGB, output_bytes/1024/1024/1024 OutputGB,  ELAPSED_SECONDS/60/60 elptime, status, INPUT_TYPE , OUTPUT_DEVICE_TYPE                             
from RC_RMAN_BACKUP_JOB_DETAILS where DB_NAME='ORCL'  and trunc(start_time) > trunc(sysdate)-7000  order by input_type, start_time;
