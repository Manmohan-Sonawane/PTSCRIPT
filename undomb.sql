select s.sid, sql.sql_id, t.used_urec records, t.used_ublk blocks,
(t.used_ublk*8192/1024/1024) mb from v$transaction t,
v$session s, v$sql sql
where t.addr=s.taddr
and s.sql_id = sql.sql_id
order by records desc;
