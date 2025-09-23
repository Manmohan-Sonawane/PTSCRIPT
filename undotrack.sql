--This sql script will show the session SID and undo space used by it.Ordered by highest used undo.
--set pau on;
--prompt "Press enter to continue"
set pages 400
SELECT  a.sid, a.username, b.used_urec, b.used_ublk
FROM v$session a, v$transaction b
WHERE a.saddr = b.ses_addr
ORDER BY b.used_ublk; 

