select tablespace_name,status,count(extent_id) "Extent Count",
sum(blocks) "Total Blocks",sum(bytes)/(1024*1024*1024) spaceInGB
from   dba_undo_extents
where  tablespace_name in ('UNDOTBS1','UNDOTBS2')
group by  tablespace_name,status;

