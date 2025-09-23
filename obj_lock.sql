set lines 200
set pages 1000
col OBJECTNAME for a60;
--col object_name for a60;
col OBJECTID for 9999999;
col FILEID for 9999;
col BLOCKID for 9999999;
col lmode for 99;
col request for 99;
Select do.object_name "OBJECTNAME",row_wait_obj# "OBJECTID", row_wait_file# "FILEID", row_wait_block# "BLOCKID", row_wait_row#
"ROWID",l.lmode,l.request,l.id1 from v$session s, dba_objects do,v$lock l where s.sid=l.sid and s.ROW_WAIT_OBJ# = do.OBJECT_ID
and do.object_name='&object_name';
