set lines 700 pages 800
col machine for a15
col username for a10
col MODULE for a20
col action for a20
col sql_text for a40
col redo_MB for 999G990 heading "Redo |Size MB"
column sid_serial for a13;
        select * from (select
       lpad((b.SID || ',' || lpad(b.serial#,5)),11) sid_serial,
       b.username,
       machine,
       b.status,
       round(s.value/1024/1024) redo_mb ,
      b.module,
      b.action,
      v.sql_text
      ,v.SQL_ID
     from gv$statname n, gv$sesstat s,
     gv$session b ,v$sqltext v
where b.inst_id=s.inst_id
and b.sql_id=v.sql_id and
n.inst_id=s.inst_id
              and n.name = 'redo size'
              and s.statistic# = n.statistic#
  and s.sid = b.sid and b.username is not null
    order by v.piece ,s.value desc) where  rownum <= 10  ;

