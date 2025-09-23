select * from (
SELECT b.sid,a.REQUEST_ID, a.REQUESTED_BY ReqBy,a.STATUS_CODE,
to_char(a. ACTUAL_START_DATE,'DD-MM-YYYY HH24:MI:SS') StartTime , to_char(ACTUAL_COMPLETION_DATE,'  DD-MM HH24:MI:SS') CompDT,
((ACTUAL_COMPLETION_DATE - ACTUAL_START_DATE)*24*60*60) TimeSecs, ((ACTUAL_COMPLETION_DATE - ACTUAL_START_DATE)*24*60) TimeMin, c.USER_CONCURRENT_PROGRAM_NAME,a.DESCRIPTION
FROM fnd_concurrent_requests a,v$session b, dual, fnd_concurrent_programs_tl c, fnd_user d
WHERE a.status_code='C' and a.os_process_id=b.process and a.CONCURRENT_PROGRAM_ID=c.CONCURRENT_PROGRAM_ID
and a.requested_by=d.user_id and trunc(a.ACTUAL_COMPLETION_DATE)=trunc(sysdate)
order by TimeSecs desc) where rownum < 26;
