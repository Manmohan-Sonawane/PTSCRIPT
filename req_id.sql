select f.request_id,s.sid from v$session s,fnd_concurrent_requests f where f.os_process_id=s.process and  request_id='&request_id';
