set lines 155
col sql_text for a50 trunc
col last_executed for a28
col enabled for a7
col plan_hash_value for a16
col last_executed for a16
select spb.sql_handle, spb.plan_name, spb.sql_text,
spb.enabled, spb.accepted, spb.fixed,
to_char(spb.last_executed,'dd-mon-yy HH24:MI') last_executed
from
dba_sql_plan_baselines spb;
