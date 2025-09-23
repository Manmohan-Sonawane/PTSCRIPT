set lines 160 pages 2000
column PROGRAM format a40
column NAME format a40
column TERMINAL format a15
column OSUSER format a10
col status for a10
SELECT   v$session.sid, v$session.serial#, osuser, terminal,program, v$sysstat.NAME,v$session.status,
round(V$sesstat.VALUE / 1024/1024 ) as "MB Memory"
    FROM v$session, V$SESSTAT, V$SYSSTAT
   WHERE v$sesstat.SID = v$session.SID
     AND v$sysstat.STATISTIC# = v$sesstat.STATISTIC#
     AND v$sysstat.NAME LIKE '%ga %'
     AND round(V$sesstat.VALUE/1024/1024) > 20
ORDER BY v$sesstat.VALUE, osuser; 
