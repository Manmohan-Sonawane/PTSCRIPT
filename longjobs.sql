set linesize 180 ;
set pagesize 200 ;
set feedback on ;
column REQ_ID format 999999999;
column PROGRAM format a50 ;
column PHASE format a10 ;
column REQUESTOR format a20 ;
column STARTED_AT format a20 ;
column R_TIME format a8 ;
select 
REQUEST_ID REQ_ID,
USER_CONCURRENT_PROGRAM_NAME PROGRAM,
decode( phase_code, 'C','Completed','R','Running','P','Pending') PHASE, 
requestor REQUESTOR,
to_char(ACTUAL_START_DATE,'DD-Mon-YYYY HH:MI:SS') STARTED_AT,
substr(numtodsinterval(sysdate-ACTUAL_START_DATE,'DAY'),12,8) R_TIME
from 
apps.FND_CONC_REQ_SUMMARY_V  
where
phase_code ='R' and
ACTUAL_COMPLETION_DATE IS NULL 
order by ACTUAL_START_DATE
/



