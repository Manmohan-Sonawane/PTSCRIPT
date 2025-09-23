select 'alter system kill session '||''''||s.sid||','||s.serial#||''''||' immediate;' from v$session s, v$process p where p.spid = '&process' and p.addr = s.paddr;
