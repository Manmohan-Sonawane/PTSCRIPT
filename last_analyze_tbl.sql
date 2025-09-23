select owner, table_name, last_analyzed, num_rows,sample_size, round(sample_size/num_rows*100,2) estimate_percent 
from dba_tables where table_name in ('&table_name') order by num_rows;
select owner, index_name table_name, last_analyzed, num_rows,sample_size, round(sample_size/num_rows*100,2) estimate_percent 
from dba_indexes where table_name in ('&table_name') order by num_rows;


