col TABLE_NAME for a30
col INDEX_NAME for a30
SELECT v.index_name, v.table_name,
 v.monitoring, v.used,
 start_monitoring, end_monitoring
 FROM v$object_usage v, user_indexes u
 WHERE v.index_name = u.index_name;
