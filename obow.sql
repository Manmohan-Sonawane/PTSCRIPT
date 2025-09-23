ne size 200
col object_name for a30
col owner for a30
col object_type for a30
select object_name,object_type,owner from dba_objects where object_name='&object_name';
