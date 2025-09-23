select CONCURRENT_QUEUE_NAME, RUNNING_PROCESSES "Actual",TARGET_PROCESSES "Target",SLEEP_SECONDS,CONCURRENT_PROCESS_ID,PROCESS_STATUS_CODE from apps.fnd_concurrent_queues a,apps.fnd_concurrent_processes b
where a.CONCURRENT_QUEUE_ID=b.CONCURRENT_QUEUE_ID
and b.os_process_id like '&Process';
