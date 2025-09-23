PROMPT  Resource Utilization
set lines 300 pages 300
col INITIAL_ALLOCATION for a20
col LIMIT_VALUE for a20
select * from v$resource_limit;
PROMPT  
PROMPT

select ( select sum(bytes)/1024/1024/1024 data_size from dba_data_files ) +
( select nvl(sum(bytes),0)/1024/1024/1024 temp_size from dba_temp_files ) +
( select sum(bytes)/1024/1024/1024 redo_size from sys.v_$log ) +
( select sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024 controlfile_size from v$controlfile) "Physical_Size in GB" from dual;

PROMPT  
PROMPT

select sum(bytes)/1024/1024/1024 Logical_size_in_gb from dba_segments;

PROMPT
