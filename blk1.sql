SELECT sid, serial#, blocking_session_status, blocking_session
FROM   v$session
WHERE  blocking_session IS NOT NULL and blocking_session=&blocking_session;
