select * from (select sum((undoblks*8192)/1024/1024) mb,MAXQUERYID FROM v$undostat group by MAXQUERYID ) order by mb desc ;
