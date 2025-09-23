select a.name, (b.value)/1024/1024
from v$statname a, v$sesstat b
where b.STATISTIC# = a.STATISTIC#
and a.name like 'redo%'
and b.sid = &sid
and b.value != 0 ;

