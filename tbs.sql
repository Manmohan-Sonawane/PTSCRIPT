set pages 55
set lines 120
set heading on
column tablespace_name for a30
column tbsize    for 999999.999
column tbfree    for 99999.999
column Largest   for 99999.999
column ratio     for  9999.99
column Required  for 99999.999
select
        a.tablespace_name ,
        tbsize  ,
        (tbsize - tbfree) Used_ts_size,
        tbfree ,
         b.tbfree/a.tbsize*100 "ratio" ,
         b.Largest "Largest space"
from
        ( select tablespace_name,sum(bytes)/1024/1024 tbsize
                from dba_data_files
                group by tablespace_name) a,
        ( select tablespace_name,sum(bytes)/1024/1024 tbfree,
                 max(bytes)/1024/1024 Largest
                from dba_free_space
                group by tablespace_name) b
where a.tablespace_name=b.tablespace_name
order by 5  ;
