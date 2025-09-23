set lines 200
col FILE_NAME for a60
col TABLESPACE_NAME for a20
select FILE_NAME,TABLESPACE_NAME,autoextensible aut
,BYTES/1024/1024,MAXBYTES/1024/1024
from dba_data_files where TABLESPACE_NAME like '&tbs' order by tablespace_name,file_name;