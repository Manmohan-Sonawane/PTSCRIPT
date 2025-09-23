set lines 200
col object_name for a80;
col row_wait_obj# for 999999999;
col  row_wait_file# for 999999999;
col row_wait_block# for 9999999999;
col row_wait_row# for 9999999999;
select do.object_name,row_wait_obj#, row_wait_file#, row_wait_block#, row_wait_row#
--dbms_rowid.rowid_create ( 1, ROW_WAIT_OBJ#, ROW_WAIT_FILE#, ROW_WAIT_BLOCK#, ROW_WAIT_ROW# )
 from v$session s, dba_objects do where sid=&sid and s.ROW_WAIT_OBJ# = do.OBJECT_ID ;
