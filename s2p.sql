select p.pid,p.spid,s.sid,s.osuser,s.process from v$session s,v$process p where s.paddr=p.addr and sid=&sid;
