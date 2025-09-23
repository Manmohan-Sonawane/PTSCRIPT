set linesize 300
set pages 200
col owner for a20
col object_name for a30
col object_type for a20
select status,owner,object_name,object_type,created from dba_objects where object_name like '& objectname';
