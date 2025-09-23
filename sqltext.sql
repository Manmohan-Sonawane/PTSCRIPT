select sql_text,SQL_ID from v$sqltext where hash_value=&hash_value order by piece;
