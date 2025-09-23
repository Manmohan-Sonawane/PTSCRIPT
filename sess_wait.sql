select p1,p2,p3,event,SECONDS_IN_WAIT,WAIT_TIME,STATE  from v$session_wait where sid=&sid;
