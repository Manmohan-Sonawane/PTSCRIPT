set pages 1000
set line 200
set head on
col status_code for a5
col phase_code for a5
col ARGUMENT_TEXT for a50
COL USER_NAME FOR a20
col user_concurrent_program_name for a50
select distinct(r.request_id),to_char(r.actual_start_date, 'DD-MON-YY HH24:MI:SS') start_time,u.user_name,p.user_concurrent_program_name,r.argument_text,r.phase_code,r.status_code from
apps.fnd_concurrent_programs_vl p, apps.fnd_concurrent_requests r, apps.fnd_concurrent_requests b, apps.fnd_user u
where p.concurrent_program_id = r.concurrent_program_id
and p.application_id = r.program_application_id
and r.phase_code = 'R' -- and r.status_code = 'R'
and r.argument_text = b.argument_text
and r.requested_by = u.user_id
and r.request_id <> b.request_id
and REQUEST_SET_FLAG='N'
and  r.actual_start_date >= sysdate-30 order by r.argument_text;

