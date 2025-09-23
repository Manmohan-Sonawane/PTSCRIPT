col OBJECT_NAME for a50
select object_id, object_name from dba_objects where object_name like '%&obj_name%' and object_type='TABLE';
