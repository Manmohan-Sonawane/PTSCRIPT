set lines 200 pages 300
col NAME for a55
select SEQUENCE#,NAME,REGISTRAR,APPLIED, to_char(COMPLETION_TIME,'dd-mm-yyyy HH24:mm:ss'), stamp from  v$archived_log where SEQUENCE#='&sequence';

