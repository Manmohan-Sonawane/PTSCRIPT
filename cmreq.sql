rem ********************************************************************
rem * Filename          : jobs.sql - Version 1.4
rem * Author            : Virag Saksena
rem * Original          : 02-APR-95
rem * Last Update       : 20-DEC-95
rem * Description       : Information about jobs running on the system
rem * Usage             : start jobs.sql
rem *   Note: added request_date and requested by info SDR 8/10/98
rem *         renamed to cmreq.sql 
rem ********************************************************************
 
col os form A6
col program form A40
set pages 38
set verify off
col time head Elapsed form 9999.99
col "Req Id" form 9999999
col "Prg Id" form 999999
col "Started On" format a10
col "Finished On" format a10
col "Submitted By" format a30 trunc
col argument_text head "Arguments" format a40
col statustxt head Status format a10 trunc
col phasetxt head Phase format a10 trunc
set recsep off
accept cmreqid number prompt 'What is the concurrent request id : '
select l2.meaning phasetxt
      ,l1.meaning statustxt
      ,(nvl(actual_completion_date,sysdate)-actual_start_date)*1440 "Time"
      ,to_char(a.actual_start_date,'mm/dd/yy  hh:mi:ssAM') "Started On"
      ,to_char(a.actual_completion_date,'mm/dd/yy  hh:mi:ssAM') "Finished On"
      ,u.user_name || ' - ' || u.description "Submitted By"
      ,a.argument_text
from APPLSYS.fnd_Concurrent_requests a
    ,applsys.fnd_user u
    ,applsys.fnd_lookup_values l1
    ,applsys.fnd_lookup_values l2
where u.user_id = a.requested_by
  and a.request_id = &cmreqid
  and l1.lookup_type = 'CP_STATUS_CODE'
  and l1.lookup_code = a.status_code
  and l1.language = 'US'
  and l1.enabled_flag = 'Y'
  -- and (l1.start_date_active <= sysdate and l1.start_date_active is not null)
  and (l1.end_date_active > sysdate or l1.end_date_active is null)
  and l2.lookup_type = 'CP_PHASE_CODE'
  and l2.lookup_code = a.phase_code
  and l2.language = 'US'
  and l2.enabled_flag = 'Y'
  -- and (l2.start_date_active <= sysdate and l2.start_date_active is not null)
  and (l2.end_date_active > sysdate or l2.end_date_active is null)
/
