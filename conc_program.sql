SELECT r.request_id reqid,
       TO_CHAR(r.actual_start_date, 'DD-MON-YY HH24:MI:SS') start_time,
       u.user_name,
       r.phase_code phase,
       r.status_code status,
       FLOOR(((SYSDATE - r.actual_start_date)*24*60*60)/3600) hrs,
       FLOOR((((SYSDATE - r.actual_start_date)*24*60*60) - FLOOR(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600)/60) mins,
       ROUND((((SYSDATE - r.actual_start_date)*24*60*60) - FLOOR(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600 - (FLOOR((((SYSDATE - r.actual_start_date)*24*60*60) - FLOOR(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600)/60)*60))) secs,
       (SYSDATE - r.actual_start_date)*24*60 tot_mins,
       DECODE(p.user_concurrent_program_name,
              'Request Set Stage', 'RSS - ' || r.description,
              'Report Set', 'RS - ' || r.description,
              p.user_concurrent_program_name) program_name,
       s.sid,
       s.serial#
FROM   gv$session s,
       apps.fnd_user u,
       apps.fnd_concurrent_processes pr,
       apps.fnd_concurrent_programs_vl p,
       apps.fnd_concurrent_requests r
WHERE  s.process = pr.os_process_id
AND    pr.concurrent_process_id = r.controlling_manager
AND    r.phase_code = 'R'
AND    r.status_code = 'R'
AND    r.requested_by = u.user_id
AND    p.concurrent_program_id = r.concurrent_program_id
AND    p.user_concurrent_program_name = '&PROGRAM_NAME'
ORDER BY r.request_id
/
