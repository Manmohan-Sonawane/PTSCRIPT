set lines 500 pages 1000
col module for a50
col "START TIME" for a30
col "END TIME" for a30
select MODULE,to_char(START_TIME,'DD-MON-YY hh24:mi:ss') "START TIME",to_char(END_TIME,'DD-MON-YY hh24:mi:ss') "END TIME", MIN 
from  hosys.pnl_execution_log where  START_TIME > sysdate-10 order by START_TIME;
