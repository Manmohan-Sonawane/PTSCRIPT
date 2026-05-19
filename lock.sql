SELECT
    sid,
    serial#,
    (last_call_et / 60) AS last_call_et_mins,
    wait_time,
    (seconds_in_wait / 60) AS waiting_mins,
    CLIENT_IDENTIFIER
FROM
    gv$session
WHERE
    sid IN (SELECT sid FROM gv$lock WHERE block = 1)
/

