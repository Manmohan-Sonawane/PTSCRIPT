set linesize 200
column instance_name format a15
column host_name format a30
column version format a10
column startup_time format a25
set pages 100
spool /export/ebizdb/clover/dailycheckup_Bajaj.log
REM Instance , server , version and startup time

select instance_name,host_name,version,to_char(startup_time,'DD-MON-YYYY HH24:MI:SS') STARTUP_TIME from v$instance;

REM Db name, Log mode, status, role
select name,log_mode,open_mode,database_role from v$database;

REM ################# DBA JOBS OUTPUT ############

set linesize 150
col interval for a25
col broken for a10
select JOB,THIS_DATE,LAST_DATE,NEXT_DATE,INTERVAL,BROKEN,FAILURES from dba_jobs;

REM Tablespace & freespace

set pages 55
set lines 120
set heading on
column tablespace_name for a30
column tbsize    for 99999.999
column tbfree    for 99999.999
column Largest   for 99999.999
column ratio     for  9999.99
column Required  for 99999.999
select
        a.tablespace_name ,
        tbsize  ,
        (tbsize - tbfree) Used_ts_size,
        tbfree ,
         b.tbfree/a.tbsize*100 "ratio" ,
         b.Largest "Largest space"
from
        ( select tablespace_name,sum(bytes)/1024/1024 tbsize
                from dba_data_files
                group by tablespace_name) a,
        ( select tablespace_name,sum(bytes)/1024/1024 tbfree,
                 max(bytes)/1024/1024 Largest
                from dba_free_space
                group by tablespace_name) b
where a.tablespace_name=b.tablespace_name
order by 5  ;

REM SESSION INFORMATION

select count(*) from v$session;

REM SORT STATISTICS  THIS SHOULD BE MORE THAN 95 %

SELECT (1-d.VALUE/m.value)*100 "SORT RATIO " FROM V$SYSsTAT d,v$sysstat m
WHERE d.name ='sorts (disk)' and m.name='sorts (memory)';

rem the ratio of getmisses/gets should be less than 15%

select (1-(sum(getmisses)/sum(gets)))*100 "OVER ALL DICT HIT RATIO" from v$rowcache;

REM THE OVER ALL HITRATIO OF THE LIBRARY CACHE

select sum(gethitratio)/count(*) *100 " LIBRARY CACHE HIT RATIO " from v$librarycache;

rem the buffer cache hit ratio shud be more than 90%

SELECT (1-PHY.VALUE/(cur.value+con.value))*100 " BUFFER CACHE HIT RATIO " from v$sysstat phy,v$sysstat con,v$sysstat cur
where cur.name='db block gets'
and con.name='consistent gets'
and phy.name='physical reads';

REM INDEX LOOK UP RATIO

SELECT (1-l.VALUE/(l.value+s.value))*100 "INDEX LOOK UP RATIO " FROM V$SYSsTAT l,v$sysstat s
WHERE s.name ='table scans (short tables)' and l.name= 'table scans (long tables)';

REM THE RATIO SHOULD BE LESS THAN 1%

select (1-(re.value/r.value ))*100  "REDO LOG HIT RATIO " from v$sysstat re ,v$sysstat r where re.name ='redo buffer allocation retries' and r.name='redo entries';

REM TOTAL SIZE OF A DATABASE

Select sum(bytes)/1024/1024/1024 "Physical Database Size" ,' GB '
        from dba_data_files ;

REM ACTUAL SIZE OF DATABASE

select sum(bytes)/1024/1024/1024 "Actual Database Size", ' GB '
        from dba_segments ;

REM check Recover file
set serveroutput on
Begin
DBMS_OUTPUT.put_line ('FILES NEED TO BE RECOVER ');
END;
/
select * from v$recover_file;
set serveroutput off

REM check Recover file
set serveroutput on
Begin
DBMS_OUTPUT.put_line ('FILES IN BACKUP MODE');
END;
/
select * from v$backup where status='ACTIVE';
set serveroutput off

spool off
host /bin/df -h>>/export/ebizdb/clover/dailycheckup_Bajaj.log; exit

host /bin/df -h
