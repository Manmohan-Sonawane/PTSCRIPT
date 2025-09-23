select name, open_mode,log_mode from v$database;

PROMPT  ****************************** PROD-DR SYNC ************************************************
select sum(A) "PROD",sum(B) "DR",nvl(sum(A-B),0) "Difference to sync" from (select ARCHIVED_SEQ# A,0 B
from v$archive_dest_status where DEST_ID = 1 and STATUS='VALID' union all select 0 A,APPLIED_SEQ# B FROM
v$archive_dest_status WHERE DEST_ID= 2);

PROMPT  ****************************** Redo Generation Daily ************************************************
#select trunc(FIRST_TIME),count(1) Logswitch from v$log_history
#where trunc(first_time) >= trunc(sysdate-60)
#group by trunc(FIRST_TIME) order by trunc(FIRST_TIME);

PROMPT  ****************************** Redo Generation Hourly ************************************************
set lines 200 pages 300
SELECT to_date(first_time) DAY,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'999') "00",
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'999') "01",
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'999') "02",
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'999') "03",
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'999') "04",
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'999') "05",
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'999') "06",
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'999') "07",
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'999') "08",
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'999') "09",
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'999') "10",
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'999') "11",
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'999') "12",
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'999') "13",
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'999') "14",
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'999') "15",
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'999') "16",
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'999') "17",
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'999') "18",
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'999') "19",
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'999') "20",
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'999') "21",
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'999') "22",
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'999') "23"
from v$log_history
where to_date(first_time) > sysdate -20 --for last 20 days.
--where to_date(first_time) > sysdate -3  -- for last 1 day.
GROUP by to_char(first_time,'YYYY-MON-DD'), to_date(first_time)
order by to_date(first_time);

PROMPT *********************************  Backup Completion Details ********************************

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


PROMPT  ****************************** Invalid objects list ************************************************
set lines 200 pages 400
col owner for a20
col object_name for a40
col object_type for a20
select OWNER,object_name,object_type,created,to_char(LAST_DDL_TIME,'dd-MM-YYYY HH24:MM'),TIMESTAMP from dba_objects where status='INVALID' order by created ;

PROMPT  ****************************** Temp tablespace Info. ************************************************
select TABLESPACE_NAME,TOTAL_EXTENTS,USED_EXTENTS,FREE_EXTENTS from v$sort_segment;

set lines 150 pages 50
col FILE_NAME for a50
select FILE_NAME,TABLESPACE_NAME,BYTES/1024/1024,MAXBYTES/1024/1024,AUTOEXTENSIBLE from dba_temp_files order by tablespace_name;


PROMPT  #######################  TBSF  ###################################
set pages 500
select t.tablespace_name "TABLESPACE", t.TOTAL "TOTAL SIZE",
nvl(f.FREE,0) "FREE SPACE",round(nvl(f.FREE,0)*100/t.TOTAL) "% FREE"
FROM
(select tablespace_name,trunc(sum(bytes)/1024/1024) as "TOTAL" from dba_data_files group by tablespace_name) t,
(select tablespace_name,trunc(sum(bytes)/1024/1024) as "FREE" from dba_free_space group by tablespace_name) f
where t.tablespace_name=f.tablespace_name(+)
order by 4;
