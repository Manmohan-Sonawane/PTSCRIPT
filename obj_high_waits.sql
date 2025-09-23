set lines 200;
set pages 1000;
col OBJID for 999999;
col OBJNAME for a50;
col TYPE for a15;
col EVENT for a35;
SELECT a.current_obj# "OBJID", o.object_name "OBJNAME", o.object_type "TYPE", a.event "EVENT",
SUM(a.wait_time +a.time_waited) TOTALWAITTIME FROM v$active_session_history a,dba_objects o 
WHERE a.sample_time between sysdate-30/2880 and sysdate AND a.current_obj# = o.object_id 
GROUP BY a.current_obj#, o.object_name, o.object_type, a.event ORDER BY TOTALWAITTIME;
