select sid, serial#,process,program ,username, SQL_ID, sql_hash_value,osuser, machine, last_call_et,status,module,event,p1,p2,p3,to_char(logon_time,'DD-MM-YY hh24:mi:ss'),action from v$session where sid=&sid order by logon_time
/
