set echo off
set feedback off
set linesize 97
set verify off
col request_id format 9999999999    heading "Request ID"
     col exec_time format 999999999 heading "Exec Time|(Minutes)"
    col start_date format a10       heading "Start Date"
     col conc_prog format a20       heading "Conc Program Name"
col user_conc_prog format a40 trunc heading "User Program Name"

spool long_running_cr.lst
SELECT 
   fcr.request_id request_id,
   TRUNC(((fcr.actual_completion_date-fcr.actual_start_date)/(1/24))*60) exec_time,
   fcr.actual_start_date start_date,
   fcp.concurrent_program_name conc_prog,
   fcpt.user_concurrent_program_name user_conc_prog
FROM
  fnd_concurrent_programs fcp,
  fnd_concurrent_programs_tl fcpt,
  fnd_concurrent_requests fcr
WHERE 
   TRUNC(((fcr.actual_completion_date-fcr.actual_start_date)/(1/24))*60) > NVL('&min',45)
and 
   fcr.concurrent_program_id = fcp.concurrent_program_id
and 
   fcr.program_application_id = fcp.application_id
and 
   fcr.concurrent_program_id = fcpt.concurrent_program_id
and 
   fcr.program_application_id = fcpt.application_id
and 
   fcpt.language = USERENV('Lang')
ORDER BY 
   TRUNC(((fcr.actual_completion_date-fcr.actual_start_date)/(1/24))*60) desc;
