set lines 300
col COLUMN_NAME for a30
col INDEX_NAME for a30
col TABLE_NAME  for a30
col TABLE_OWNER for a30
select index_name,column_name,column_position,table_name,table_owner from dba_ind_columns where  index_name like '&ind';

