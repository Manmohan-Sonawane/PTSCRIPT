SELECT sid,inst_id,module, serial#,sql_id, blocking_session_status, blocking_session, CLIENT_IDENTIFIER, event,LAST_CALL_ET
FROM   gv$session
WHERE  blocking_session IS NOT NULL
/
