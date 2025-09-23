select count(*) from v$session where status = 'ACTIVE' and last_call_et > (3600);
