select
   ss.username,
   se.SID,
   ss.module,
   to_char(ss.logon_time,'DD-MM-YY hh24:mi:ss'),
   VALUE/100 cpu_usage_seconds
from
   v$session ss,
   v$sesstat se,
   v$statname sn
where
   se.STATISTIC# = sn.STATISTIC#
and
   NAME like '%CPU used by this session%'
and
   se.SID = ss.SID
and
   ss.SID = '&SID'
and
   ss.username is not null order by VALUE asc;

