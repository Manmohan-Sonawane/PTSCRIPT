select sum(ACTIVEBLKS),sum(UNEXPIREDBLKS),sum(EXPIREDBLKS) from v$undostat where MAXQUERYID='&sql_id';
