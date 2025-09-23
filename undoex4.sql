 select SSOLDERRCNT,undoblks,maxquerylen,MAXQUERYID FROM v$undostat where SSOLDERRCNT!=0 order by begin_time;
