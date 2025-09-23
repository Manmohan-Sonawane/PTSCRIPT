set linesize 178
set pages 2000
set verify off
COLUMN start_time FORMAT a18
COLUMN program_name FORMAT a50
COLUMN reqid FORMAT 999999999 HEADING 'Request|ID'
COLUMN tot_mins FORMAT 9999999 HeaDING "Total|Run-Time|in Mins"
COLUMN hrs FORMAT 99999 HEADING "Running|Hrs"
COLUMN mins FORMAT 99999 HEADING "Running|Mins"
COLUMN secs FORMAT 99999 HEADING "Running|Secs"
COLUMN user_name FORMAT a20
COLUMN sid FORMAT 99999
COLUMN serial# FORMAT 9999999
COLUMN phase FORMAT a5 HEADING "Phase|Code"
COLUMN status FORMAT a6 HEADING "Status|Code"
select distinct s.inst_id, r.request_id reqid,
to_char(r.actual_start_date, 'DD-MON-YY HH24:MI:SS') start_time,
u.user_name,
r.phase_code phase,
r.status_code status,
floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600) hrs,
floor((((SYSDATE - r.actual_start_date)*24*60*60) - floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600)/60) mins,
round((((SYSDATE - r.actual_start_date)*24*60*60) - floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600 - (floor((((SYSDATE - r.actual_start_date)*24*60*60) - floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600)/60)*60) )) secs,
(SYSDATE - r.actual_start_date)*24*60 Tot_Mins,
/* p.concurrent_program_id progid,*/
decode(p.user_concurrent_program_name,
       'Request Set Stage', 'RSS - '||r.description,
       'Report Set', 'RS - '||r.description,
       p.user_concurrent_program_name ) program_name,
       s.sid
from   gv$session s,
       apps.fnd_user u,
       apps.fnd_concurrent_processes pr,
       apps.fnd_concurrent_programs_vl p,
       apps.fnd_concurrent_requests r
where s.process = pr.os_process_id
and pr.concurrent_process_id = r.controlling_manager
and r.phase_code = 'R' -- and r.status_code = 'R'
and r.requested_by = u.user_id
and p.concurrent_program_id = r.concurrent_program_id
order by 2
/

