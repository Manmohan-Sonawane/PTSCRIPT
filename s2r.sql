select f.request_id "Request Id" ,s.sid "Database Session ID",f.oracle_process_id "Database OS Process",s.process "Concurrent OS Process" from v$session s,apps.fnd_concurrent_requests f
where s.sid='&sid' and f.os_process_id=s.process and f.PHASE_CODE='R';
