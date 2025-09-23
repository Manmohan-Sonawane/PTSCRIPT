select sql_text,SQL_ID from gv$sqltext where hash_value in (select sql_hash_value from gv$session where sid=&sid) order by piece;
