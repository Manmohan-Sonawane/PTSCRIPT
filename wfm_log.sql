
col logfile_name for a50 
SELECT logfile_name
FROM apps.fnd_concurrent_processes
WHERE process_status_code = 'A'
AND concurrent_queue_id in
(SELECT concurrent_queue_id from apps.fnd_concurrent_queues
WHERE concurrent_queue_name = 'WFMLRSVC');
