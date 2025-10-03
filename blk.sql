set lines 300 pages 400
col module for a50
col event for a30
SELECT sid,inst_id,module, serial#,sql_id, blocking_session_status, blocking_session,event,LAST_CALL_ET
FROM   gv$session
WHERE  blocking_session IS NOT NULL;
