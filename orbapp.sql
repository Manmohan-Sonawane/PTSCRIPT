set linesize 178
set pages 2000
col SID_SERIAL for a12;
col USERNAME for a12;
col OSUSER for a12;
col MODULE for a12;
col PROGRAM for a12;
SELECT
    S.sid || ',' || S.serial# AS sid_serial,
    S.username,
    S.osuser,
    P.spid,
    S.module,
    P.program,
    SUM(T.blocks) * TBS.block_size / 1024 / 1024 /1024 AS gb_used,
    T.tablespace,
    COUNT(*) AS statements
FROM
    v$sort_usage T
    JOIN v$session S ON T.session_addr = S.saddr
    JOIN v$process P ON S.paddr = P.addr
    JOIN dba_tablespaces TBS ON T.tablespace = TBS.tablespace_name
WHERE
    S.osuser = 'orbapp'
GROUP BY
    S.sid, S.serial#, S.username, S.osuser, P.spid, S.module, P.program, TBS.block_size, T.tablespace
ORDER BY
    gb_used;
