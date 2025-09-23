set lines 150 pages 50
select substr(OWNER,1,15) "OWNER",
substr(segment_NAME,1,30) "NAME",
substr(segment_type,1,12)"TYPE",
bytes/1024/1024/1024 "GBYTES",
extents "EXTENTS"
from sys.dba_segments where
segment_type in ('INDEX','TABLE') and
bytes > 100000000 and owner not in ('SYS') order by bytes desc;
