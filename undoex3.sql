select tablespace_name,status, sum(bytes) from dba_undo_extents
group by tablespace_name,status order by tablespace_name, status; 
