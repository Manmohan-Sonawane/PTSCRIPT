set lines 300 pages 400;
 col OWNER for a30;
 col SEGMENT_NAME for a40;
 select owner,segment_name,segment_type,bytes/1024/1024 from dba_segments where segment_name='&segment_name';

