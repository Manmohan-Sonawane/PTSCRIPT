set lines 180
 set pages 100
 col Parameters for a20 WORD_WRAPPED
 set pages 100
 col "Conc Program Name" for a30 WORD_WRAPPED
 col "Started at" for a20
 col "Completed at" for a20
 col "Username" for a10 WORD_WRAPPED
 SELECT distinct t.user_concurrent_program_name "Conc Program Name",
 r.REQUEST_ID "Request ID",
 to_char(r.ACTUAL_START_DATE,'dd-MON-yy hh24:mi:ss') "Started at",
 to_char(r.ACTUAL_COMPLETION_DATE,'dd-MON-yy hh24:mi:ss') "Completed at",
 decode(r.PHASE_CODE,'C','Completed','I','Inactive','P','Pending','R','Running','NA') "Phasecode",
 decode(r.STATUS_CODE, 'A','Waiting', 'B','Resuming', 'C','Normal', 'D','Cancelled', 'E','Error', 'F','Scheduled', 'G','Warning', 'H','On Hold', 'I','Normal', 'M',
 'No Manager', 'Q','Standby', 'R','Normal', 'S','Suspended', 'T','Terminating', 'U','Disabled', 'W','Paused', 'X','Terminated', 'Z','Waiting') "Status",r.argument_text "Parameters",
 u.user_name "Username",
 --ROUND ((v.actual_completion_date - v.actual_start_date) * 1440,
 --              2
  --            ) "Runtime (in Minutes)" 
 round(((nvl(v.actual_completion_date,sysdate)-v.actual_start_date)*24*60),2) "ElapsedTime(Mins)"
 FROM
 xxhil_audit.fnd_concurrent_requests r ,
 xxhil_audit.fnd_concurrent_programs p ,
 xxhil_audit.fnd_concurrent_programs_tl t,
 apps.fnd_user u, apps.fnd_conc_req_summary_v v
 WHERE 
 r.CONCURRENT_PROGRAM_ID = p.CONCURRENT_PROGRAM_ID
 AND r.actual_start_date >= (sysdate - &NO_DAYS)
 --AND r.requested_by=22378
 AND   r.PROGRAM_APPLICATION_ID = p.APPLICATION_ID
 AND t.concurrent_program_id=r.concurrent_program_id
 AND r.REQUESTED_BY=u.user_id
 AND v.request_id=r.request_id
 --AND r.request_id ='2260046' in ('13829387','13850423')
 and t.user_concurrent_program_name like '&USER_CONC_PROG_NAME'
 order by to_char(r.ACTUAL_COMPLETION_DATE,'dd-MON-yy hh24:mi:ss') desc;
