col column_name for a50
set lines 500
select index_name,column_name,column_position,table_name,table_owner from dba_ind_columns where column_name='&column' and table_name='&table';
