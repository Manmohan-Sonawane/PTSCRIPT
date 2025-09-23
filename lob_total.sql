select b.segment_name,sum(b.bytes)/1024/1024 "Total Size MB" from dba_lobs a, dba_segments b 
where a.table_name=b.segment_name and b.segment_name='&tab_name' group by b.segment_name;
