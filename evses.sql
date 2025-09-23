SELECT sid, serial#, event, (seconds_in_wait/1000000) seconds_in_wait
FROM   v$session
where status='ACTIVE'
ORDER BY sid;
