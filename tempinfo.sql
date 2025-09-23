set lines 150 pages 50
col FILE_NAME for a50
select FILE_NAME,TABLESPACE_NAME,BYTES/1024/1024,MAXBYTES/1024/1024,AUTOEXTENSIBLE from dba_temp_files order by tablespace_name;
