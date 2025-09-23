col object_name for a40
select object_name,owner,object_type,status,TO_CHAR(created,'DD-MON-YYYY HH24:MI:SS'),TO_CHAR(last_ddl_time,'DD-MON-YYYY HH24:MI:SS') from dba_objects where object_name like '&Object_name';

