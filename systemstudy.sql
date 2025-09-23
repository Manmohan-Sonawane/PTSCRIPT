set serveroutput on
set lines 100
set pages 0
set head off
set feedback off
set colsep "|"
col bytes for 999999999999999.99
break on grantee
spool  jDE_system.log
SELECT 'SS_INSTANCE'||'|'||HOST_NAME||'|'||NAME||'|'||INSTANCE_NAME||'|'||CREATED||'|'||LOG_MODE||'|'||OPEN_MODE FROM V$DATABASE, V$INSTANCE ;
select 'SS_TABLESPACE'||'|'||tablespace_name||'|'||extent_management||'|'||segment_space_management||'|'||Initial_extent||'|'||contents
from dba_tablespaces;
select 'SS_DATAFILE'||'|'||tablespace_name||'|'||file_name||'|'||trunc((bytes/1024/1024),2)
from dba_data_files;
select 'SS_TEMPFILE'||'|'||tablespace_name||'|'||file_name||'|'||trunc((bytes/1024/1024),2)
from dba_temp_files;
select 'SS_CONTROL'||'|'||name
from v$controlfile;
select 'SS_REDO'||'|'||a.group#||'|'||b.member||'|'||trunc((a.bytes/1024/1024),2)
from v$log a, v$logfile b
where a.group#=b.group#;
select 'SS_ROLLBACK'||'|'||segment_name||'|'||tablespace_name||'|'||initial_extent||'|'||next_extent||'|'||min_extents||'|'||max_extents||'|'||optsize||'|'||dba_rollback_segs.status
from dba_rollback_segs, v$rollstat
where usn=segment_id;
select 'SS_USERS'||'|'||username||'|'||to_char(created,'DD-MON-YYYY')||'|'||default_tablespace||'|'||temporary_tablespace||'|'||profile
from dba_users;
select 'SS_PRIVS'||'|'||grantee||'|'|| granted_role from dba_role_privs where grantee not in ('SYS','SYSTEM','OUTLN')
and grantee in (select username from dba_users);
select 'SS_INIT'||'|'||name||'|'||value
from v$parameter
where name in
('db_name',
'db_domain',
'instance_name',
'service_names',
'control_files',
'db_block_buffers',
'db_file_multiblock_read_count',
'open_cursors',
'Shared_pool_size',
'Large_pool_size',
'java_pool_size',
'log_checkpoint_interval',
'sort_area_size',
'Processes',
'dml_locks',
'log_buffer',
'rollback_segments',
'background_dump_dest',
'core_dump_dest',
'user_dump_dest',
'db_block_size',
'remote_login_passwordfile',
'os_authent_prefix',
'job_queue_processes',
'job_queue_interval',
'Distributed_transactions',
'open_links',
'mts_dispatchers',
'mts_max_dispatchers',
'mts_servers',
'mts_max_servers',
'compatible');

REM - Findings Section
DECLARE 
X NUMBER;
Y NUMBER;
Z NUMBER;
S NUMBER;
BEGIN
SELECT trunc(sum(bytes/1024/1024),2) INTO X FROM dba_segments;
SELECT trunc(sum(bytes/1024/1024),2) INTO Y FROM dba_data_files;
SELECT trunc(sum(bytes/1024/1024),2) INTO Z FROM dba_temp_files;
S:=Y+Z;
DBMS_OUTPUT.PUT_LINE ('SS_DBSIZE'||'|'||S||'|'||X);
END;
/
select 'SS_TSSPSTAT'||'|'||f.tablespace_name||'|'||a.total||'|'||u.used||'|'||f.free||'|'||round((u.used/a.total)*100)||'|'||round((f.free/a.total)*100)
from
(select tablespace_name, sum(bytes/(1024*1024)) total from dba_data_files group by tablespace_name) a,
(select tablespace_name, round(sum(bytes/(1024*1024))) used from dba_extents group by tablespace_name) u,
(select tablespace_name, round(sum(bytes/(1024*1024))) free from dba_free_space group by tablespace_name) f
WHERE a.tablespace_name = f.tablespace_name
and a.tablespace_name = u.tablespace_name
order by f.free;
---SELECT 'SS_OBJGROW'||'|'||S.OWNER||'|'||S.SEGMENT_NAME||'|'||S.SEGMENT_TYPE||'|'||S.TABLESPACE_NAME||'|'||S.INITIAL_EXTENT||'|'||S.NEXT_EXTENT||'|'||S.MIN_EXTENTS||'|'||S.MAX_EXTENTS 
---FROM DBA_SEGMENTS  S 
---WHERE next_extent > (select MAX(f.bytes)
---from dba_free_space f
---where f.tablespace_name = s.tablespace_name);
select 'SS_FRAG'||'|'||owner||'|'||segment_name||'|'||segment_type||'|'||tablespace_name||'|'||extents||'|'||next_extent/1024/1024 
from dba_segments
where extents > 20 
and owner not in ('SYS','SYSTEM','SCOTT') ;

col value for 9999999999.99
select 'SS_SGA'||'|'||trunc((value/1024/1024),2) from v$sga ;
DECLARE
X NUMBER;
Y NUMBER;
BEGIN
select trunc(sum(value/1024/1024),2)  INTO X from v$sga;
select trunc(sum(bytes/1024/1024),2) INTO Y FROM V$SGASTAT WHERE NAME LIKE '%free memory%';
DBMS_OUTPUT.PUT_LINE ('SS_SGASIZE'||'|'||X||'|'||Y);
END;
/
select 'SS_SGA_LCS'||'|'||GETS||'|'||GETHITS||'|'||trunc(GETHITRATIO,2)||'|'||PINS||'|'||PINHITS||'|'||trunc(PINHITRATIO,2)||'|'||RELOADS||'|'||INVALIDATIONS from v$librarycache;
DECLARE
X NUMBER;
Y NUMBER;
BEGIN
select trunc(sum(gethitratio)/count(*) *100,2) INTO X from v$librarycache;
SELECT trunc((1- SUM(RELOADS)/SUM(PINS))*100,2) INTO Y FROM V$LIBRARYCACHE;
DBMS_OUTPUT.PUT_LINE ('SS_SGA_LCHR'||'|'||X||'|'||Y);
END;
/
SELECT 'SS_SGA_DCS'||'|'||PARAMETER||'|'||GETS||'|'||GETMISSES||'|'||trunc((1-GETMISSES/GETS)*100,2)
FROM V$ROWCACHE 
WHERE GETS<>0 AND GETMISSES<>0;
select 'SS_SGA_DCHR'||'|'||sum(gets)||'|'||sum(getmisses)||'|'||trunc((1-(sum(getmisses)/sum(gets)))*100,2)
from v$rowcache;
SELECT 'SS_SGA_DBCHR'||'|'||trunc((1-PHY.VALUE/(cur.value+con.value))*100,2) from v$sysstat phy,v$sysstat con,v$sysstat cur 
where cur.name='db block gets'
and con.name='consistent gets'
and phy.name='physical reads';
SELECT 'SS_SGA_DBCS'||'|'||NAME||'|'||trunc(VALUE,2)  FROM V$SYSSTAT WHERE NAME IN ('db block gets','consistent gets','physical reads');
select 'SS_LRUC'||'|'||name||'|'||trunc((1-sleeps/gets)*100,2) from v$latch
where name ='cache buffers lru chain';
select 'SS_SHW'||'|'||class||'|'||count||'|'||time  from v$waitstat
where class='segment header';
select 'SS_BBW'||'|'||event||'|'||total_waits from v$system_event where event='buffer busy waits';
select 'SS_SEBBW'||'|'||s.segment_name||'|'||s.segment_type||'|'||s.freelists||'|'||w.wait_time||'|'||w.seconds_in_wait||'|'||w.state
from dba_segments s,v$session_wait w
where w.event='buffer busy waits'
and w.p1=s.header_file
and w.p2=s.header_block
/
DECLARE
X NUMBER;
Y NUMBER;
Z NUMBER;
BEGIN
SELECT value INTO X FROM V$SYSsTAT 
WHERE name ='sorts (disk)' ;
SELECT value INTO Y FROM V$SYSsTAT 
WHERE name ='sorts (memory)';
SELECT (1-d.VALUE/m.value)*100 INTO Z  FROM V$SYSsTAT d,v$sysstat m
WHERE d.name ='sorts (disk)' and m.name='sorts (memory)';
DBMS_OUTPUT.PUT_LINE ('SS_SORT'||'|'||X||'|'||Y||'|'||Z);
END;
/
SELECT 'SS_IDX_LKP'||'|'||trunc((1-l.VALUE/(l.value+s.value))*100,2) FROM V$SYSsTAT l,v$sysstat s
WHERE s.name ='table scans (short tables)' and l.name= 'table scans (long tables)';
select 'SS_SGA_LBCAU'||'|'||'Specified in INIT'||'|'||to_number(value,'999999999') from v$parameter where name ='log_buffer'
union 
select 'SS_SGA_LBCAU'||'|'||'Allocated by OS'||'|'||bytes from v$sgastat where name ='log_buffer';
select 'SS_SGA_LBCW'||'|'||sid||'|'||event||'|'||seconds_in_wait||'|'||state 
from v$session_wait where event like '%log buffer space %';
col name format a30
select 'SS_SGA_LBCS'||'|'||name||'|'||value 
from v$sysstat 
where name in ('redo log space requests','redo buffer allocation retries','redo entries');
select 'SS_SGA_LBCHR'||'|'||(1-(re.value/r.value ))*100 
from v$sysstat re ,v$sysstat r 
where re.name ='redo buffer allocation retries' and r.name='redo entries';
SELECT 'SS_OVERALL_WAITS'||'|'||class||'|'||count||'|'||time FROM V$WAITSTAT;
select 'SS_REDO_SW'||'|'||EVENT||'|'||TOTAL_WAITS||'|'||TIME_WAITED||'|'||AVERAGE_WAIT 
FROM V$SYSTEM_EVENT 
WHERE EVENT LIKE 'log file switch completion%';
select 'SS_CKPT'||'|'||EVENT||'|'||TOTAL_WAITS||'|'||TIME_WAITED||'|'||AVERAGE_WAIT 
FROM V$SYSTEM_EVENT 
WHERE EVENT LIKE 'log file switch (check%';
select 'SS_ARCH'||'|'||EVENT||'|'||TOTAL_WAITS||'|'||TIME_WAITED||'|'||AVERAGE_WAIT 
FROM V$SYSTEM_EVENT 
WHERE EVENT LIKE 'log file switch (arch%';
select 'SS_RBSTAT'||'|'||b.name||'|'||a.WRITES||'|'||a.GETS||'|'||a.WAITS||'|'||a.HWMSIZE||'|'||a.SHRINKS||'|'||a.WRAPS||'|'||a.STATUS
from v$rollstat a, v$rollname b
where a.usn=b.usn;
select 'SS_LATCH'||'|'||name||'|'||gets||'|'||misses||'|'||sleeps||'|'||immedIATE_GETS||'|'||IMMEDIATE_MISSES 
from v$latch where misses<>0;
spool off


