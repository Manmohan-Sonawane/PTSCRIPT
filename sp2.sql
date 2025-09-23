select sid,inst_id, serial#, username, SQL_ID, osuser, machine,action, last_call_et,status,module,program,event,p1,p2,p3,to_char(logon_time,'DD-MM-YY hh24:mi:ss'),action from gv$session where sid=&sid order by logon_time
/
