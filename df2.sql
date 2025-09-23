 select FILE_NAME,autoextensible aut,BYTES/1024/1024,MAXBYTES/1024/1024 from dba_data_files
 where tablespace_name='&A' order by FILE_ID;
