set pages 1000
set line 400
set head on
col START_TIME for a25
col END_TIME for a25
col status_code for a5
col ARGUMENT_TEXT for a60
select  r.request_id,to_char(r.actual_start_date, 'DD-MON-YY HH24:MI:SS') start_time,r.phase_code,r.status_code,to_char(r.actual_completion_date, 'DD-MON-YY HH24:MI:SS') end_time,argument_text,(r.actual_completion_date - r.actual_start_date)*24*60 Tot_Mins from
apps.fnd_concurrent_programs_vl p, apps.fnd_concurrent_requests r
where p.concurrent_program_id = r.concurrent_program_id
and p.application_id = r.program_application_id
and p.user_concurrent_program_name like '%Gather Schema Statistics%'
and  r.actual_start_date >= sysdate-30 order by r.requested_start_date;

