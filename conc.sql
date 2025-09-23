set linesize 178
set pages 2000
set verify off
COLUMN ACTUAL_START_DATE FORMAT a18
COLUMN PROG.USER_CONCURRENT_PROGRAM_NAME||'-'||REQ.DESCRIPTION FORMAT a50
COLUMN REQUEST_ID FORMAT 999999999 HEADING 'Request|ID'
COLUMN TIME_TAKEN FORMAT 9999999 HeaDING "Total|Run-Time|in Mins"
COLUMN hrs FORMAT 99999 HEADING "Running|Hrs"
COLUMN mins FORMAT 99999 HEADING "Running|Mins"
COLUMN secs FORMAT 99999 HEADING "Running|Secs"
COLUMN user_name FORMAT a12
COLUMN sid FORMAT 99999
COLUMN serial# FORMAT 9999999
COLUMN phase_code FORMAT a5 HEADING "Phase|Code"
COLUMN status_code FORMAT a6 HEADING "Status|Code"

select req.request_id,u.user_name,req.CONCURRENT_PROGRAM_ID,prog.USER_CONCURRENT_PROGRAM_NAME || ' - ' || req.DESCRIPTION,
(sysdate - req.ACTUAL_START_DATE)*(24*60) time_taken,sysdate,req.ACTUAL_START_DATE,  
req.status_code,req.phase_code from fnd_concurrent_requests req,fnd_user u,
fnd_concurrent_programs_tl prog    
where req.phase_code='R' and req.status_code='R' and req.requested_by = u.user_id 
and req.CONCURRENT_PROGRAM_ID=prog.CONCURRENT_PROGRAM_ID order by time_taken desc;
