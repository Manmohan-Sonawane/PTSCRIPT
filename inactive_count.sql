select count(*) from v$session where status = 'INACTIVE' and last_call_et > (3600);
