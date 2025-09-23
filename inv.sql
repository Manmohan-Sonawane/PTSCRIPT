set linesize 200
col OBJECT_NAME for a40
col OBJECT_TYPE for a40
select object_name,OBJECT_TYPE from dba_objects where status='INVALID';
