select maxquerylen from v$undostat where maxqueryid='&MAXQUERYID' order by maxquerylen desc;

