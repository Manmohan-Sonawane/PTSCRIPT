select sid , serial#,(last_call_et/60) last_call_et_mins,wait_time,(seconds_in_wait/60) waiting_mins   from gv$session
where sid in ( select sid from gv$lock where block=1);
