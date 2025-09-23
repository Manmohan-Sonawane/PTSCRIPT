select tablespace_name,status,count(*)
from dba_undo_extents
group by tablespace_name,status;
