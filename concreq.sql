set term on
set feedback on
set echo on
set arraysize 4
set linesize 200
set pages 9999
set underline =;
column username format A15
column sid format 9990 heading SID
column type format A4
column lmode format 990 heading 'HELD'
column request format 990 heading 'REQ'
column id1 format 9999990
column id2 format 9999990
column sql_text format a100
column name format a80
break on id1 skip 1 dup
undefine v_request_id
define v_request_id
undefine v_spid
define v_spid
undefine v_sid
define v_sid
spool concurrent_monitor.lst

Prompt Enter the concurrent_request_id
Accept v_request_id
prompt checking requests
select oracle_process_id from fnd_concurrent_requests where request_id='&v_request_id';

Prompt Enter the operating system oracle process id for this concurrent request
accept v_spid
Prompt Getting the sid
SELECT SID,SERIAL#,LOGON_TIME FROM V$SESSION WHERE PADDR IN
(SELECT ADDR FROM V$PROCESS WHERE SPID='&v_spid');

prompt Enter the session id for this concurrent request
accept v_sid
prompt memory usage for this session
SELECT A.SID,A.USERNAME,B.VALUE,c.name FROM V$SESSION a,V$SESSTAT B,V$STATNAME C WHERE A.SID=B.SID
AND B.STATISTIC#=C.STATISTIC# AND C.NAME like'%memor%' and a.sid='&v_sid';

prompt resource usage for this session
SELECT A.SID,A.USERNAME,B.VALUE,c.name FROM V$SESSION a,V$SESSTAT B,V$STATNAME C WHERE A.SID=B.SID
AND B.STATISTIC#=C.STATISTIC# and a.sid='&v_sid' order by b.value;


prompt this session waited on
select sid,event,wait_time,state from v$session_wait where sid='&v_sid' order by wait_time;


prompt current sql executing by this session
select a.sid,b.sorts,b.executions,b.loads,b.parse_calls,b.disk_reads,
b.buffer_gets,b.rows_processed,C.sql_text from v$session a,v$sqlarea b,V$SQLTEXT C
where a.sql_address=b.address and b.address=c.address and a.sid='&v_sid';


prompt sql which is taking more than 3mb in shared pool
prompt nosql should take morethan 1mb in shared pool.
prompt please ask the developers to tune the following sql statements
select name,
namespace,type,sharable_mem/(1024*1024) sharablemem,loads,executions,locks,pins,kept from v$db_object_cache
where SHARABLE_MEM>3000000;


prompt sort segments using by this session
SELECT s.username,s.sid,s.osuser,s.process,s.machine,u.extents, u.blocks,u.tablespace FROM v$session s, v$sort_usage u
WHERE s.saddr=u.session_addr order by extents;
and s.sid='&v_sid';

prompt current temp segments free in this instance
SELECT tablespace_name, extent_size, total_extents, used_extents, free_extents, max_used_size FROM v$sort_segment;



prompt total system events at this time
select event,total_waits waits, total_timeouts timeouts, time_waited total_time from v$system_event order by total_waits;

prompt latch contention if thery is any
SELECT latch#, name, gets, misses, sleeps FROM v$latch WHERE sleeps>0 ORDER BY sleeps;

prompt the latch which is sleeping
select name, sleeps,latch# from v$latch_children where sleeps>4 order by sleeps;
