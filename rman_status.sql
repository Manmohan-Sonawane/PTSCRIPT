set linesize 200 heading off
set heading on pagesize 200
column status format a10
column time_taken_display format a10;
column input_bytes_display format a12;
column output_bytes_display format a12;
column output_bytes_per_sec_display format a10;
column device_type format a10
column OutBytesPerSec for a13
col "Time(Hrs.)" for a20
SELECT b.input_type,
b.status,
to_char(b.start_time,'DD-MM-YY HH24:MI') "Start Time",
b.time_taken_display "Time(Hrs.)",
b.output_device_type device_type,
b.input_bytes_display,
b.output_bytes_display,
b.output_bytes_per_sec_display "OutBytesPerSec"
FROM v$rman_backup_job_details b
WHERE b.start_time > (SYSDATE - 10)
ORDER BY b.start_time;

