select sid, serial#, username, schemaname, osuser, machine, terminal,status,module,event,to_char(logon_time,'DD-MM-YY hh24:mi:ss'),action from v$session where action like '%FRM%';
