set lines 300
col table_name for a30
col column_name for a30
col segment_name for a30
SELECT table_name, a.TABLESPACE_NAME, column_name, segment_name, a.bytes/1024/1024 "size" FROM dba_segments a JOIN dba_lobs b USING (owner, segment_name) WHERE b.table_name = 'BCCD_PRODUCTIMAGES';
