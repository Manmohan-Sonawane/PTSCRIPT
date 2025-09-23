select 'alter system kill session '||''''||sid||','||serial#||',@'||inst_id||''''||' immediate;' from gv$session where sid= 
(SELECT d.sid FROM apps.fnd_concurrent_requests a, apps.fnd_concurrent_processes b, v$process c, v$session d
WHERE a.controlling_manager = b.concurrent_process_id AND c.pid = b.oracle_process_id AND b.session_id=d.audsid AND a.request_id = &Request_ID AND a.phase_code = 'R');
update apps.fnd_concurrent_requests set phase_code='C' , status_code='X' where request_id='&REQUEST_ID';

