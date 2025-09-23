select
   ses.sid,
   ses.username,
   substr(ses.program,1,20),
   tra.used_ublk
from
   v$session     ses,
   v$transaction tra
where
   ses.saddr = tra.ses_addr;
