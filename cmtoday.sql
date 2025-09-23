REM ******************************************************************************************
REM * Filename          : cmtoday.sql 
REM * Author            : Prashant Gotmare
REM * Original          : 25-Dec-2010
REM * Last Update       : 21-Jan-2011
REM * Description       : Information about the Concurrent requests run Per day
REM * Usage             : For finding out total concurrent request on server during the day
REM * Note		: Please pass those module or day which you want to check .
REM *        		  Other wise it take more time for execution
REM **************************************************************************************************

clear columns
set pages 23
set lines 125
col os form A6
col program head "Program Name" form A70 trunc
col shrtnm head "Shortname" format a9
col time head Elapsed form 9999.99
col request_id head "Req Id" form 9999999999
col cprogid head "Prg Id" form 999999
col "Started On" format a10
col "Finished On" format a11
col "Submitted By" format a30 trunc
col argument_text head "Arguments" format a50 trunc
col statustxt head Status format a10 trunc
col phasetxt head Phase format a10 trunc
spool cmtoday.txt
set recsep wrap
set verify off
accept trgtprog char default all prompt 'What is the concurrent program short name <all> : '
accept offsetdays num default 0 prompt 'How many days back (0 for today, 1 for yesterday etc) : '
select a.request_id
      ,c.concurrent_program_name shrtnm
      ,c.concurrent_program_id cprogid
      ,ctl.user_concurrent_program_name "program"
      ,l2.meaning phasetxt
      ,l1.meaning statustxt
      ,to_char(a.actual_start_date,'hh:mi:ssAM') "Started On"
      ,to_char(a.actual_completion_date,'hh:mi:ssAM') "Finished On"
      ,(nvl(actual_completion_date,sysdate)-actual_start_date)*1440 "Time"
      ,a.argument_text
      ,u.user_name || ' - ' || u.description "Submitted By"
from APPLSYS.fnd_Concurrent_requests a
    ,applsys.fnd_user u
    ,applsys.fnd_lookup_values l1
    ,applsys.fnd_lookup_values l2
    ,APPLSYS.fnd_concurrent_programs c
    ,APPLSYS.fnd_concurrent_programs_tl ctl
where u.user_id = a.requested_by
  and (upper(c.concurrent_program_name) = upper('&trgtprog') or upper('&trgtprog') = 'ALL')
  and  trunc(a.actual_start_date) = trunc(sysdate) - &offsetdays
  and l1.lookup_type = 'CP_STATUS_CODE'
  and l1.lookup_code = a.status_code
  and l1.language = 'US'
  and l1.enabled_flag = 'Y'
  and nvl(l1.start_date_active,sysdate) <= sysdate
  and (l1.end_date_active > sysdate or l1.end_date_active is null)        
  and l2.lookup_type = 'CP_PHASE_CODE'
  and l2.lookup_code = a.phase_code
  and l2.language = 'US'
  and l2.enabled_flag = 'Y'
  and nvl(l2.start_date_active,sysdate) <= sysdate
  and (l2.end_date_active > sysdate or l2.end_date_active is null) 
  and a.concurrent_program_id = c.concurrent_program_id
  and ctl.concurrent_program_id = c.concurrent_program_id
  and ctl.language = 'US'
  and a.program_application_id = c.application_id
  and ctl.application_id = c.application_id
 order by actual_start_date;

spool off;


