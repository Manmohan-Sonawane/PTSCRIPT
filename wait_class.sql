SELECT a.wait_class, sum(b.time_waited)/1000000 time_waited
FROM   v$event_name a
       JOIN v$system_event b ON a.name = b.event
GROUP BY a.wait_class;
