col COMPONENT_NAME for a50
col STARTUP_MODE for a20
col COMPONENT_STATUS for a20
select fsc.COMPONENT_NAME,fsc.STARTUP_MODE,fsc.COMPONENT_STATUS,to_char(fcq.last_update_date,'DD-MON-YY HH24:MI:SS') "Last Updated"
from APPS.FND_CONCURRENT_QUEUES_VL fcq, apps.fnd_svc_components fsc
where fsc.concurrent_queue_id = fcq.concurrent_queue_id(+)
order by COMPONENT_STATUS , STARTUP_MODE , COMPONENT_NAME;
