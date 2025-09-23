set lines 200 pages 700
col object_name for a40
col object_type for a20 
select object_name,object_type,created from dba_objects where status='INVALID' order by created ;


