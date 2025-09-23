set lines 150 pages 50
SELECT s.sid, s.serial#, s.username, s.program,
i.block_changes
FROM v$session s, v$sess_io i
WHERE s.sid = i.sid
ORDER BY 5;
