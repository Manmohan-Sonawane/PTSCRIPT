set lines 250 pages 3000
col "Concurrent Manager Name" for a50
col "Manager Node" for a20
col "Target" for 99999999
select user_concurrent_queue_name "Concurrent Manager Name", target_node "Manager Node", running_processes "Actual", max_processes "Target", decode(max_processes-running_processes,0,'Manager Active','Manager Inactive') "Manager Status"
from apps.fnd_concurrent_queues_vl where max_processes<>0 and control_code is null;
