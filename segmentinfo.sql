col owner format a20
col segment_name format a35
col tablespace_name format a30
col partition_name format a20
set lines 150

select owner,segment_name,partition_name,segment_type,tablespace_name,bytes/1024/1024
from dba_segments where segment_name like upper('%&segment_name%')
/


