REM****************************************************************************
REM****************************************************************************
REM                     IDLE_TIME MONITOR SCRIPT
REM****************************************************************************
REM****************************************************************************
REM
REM
REM     THIS SCRIPT PROVIDES AN EASY WAY FOR THE DBA TO MONITOR
REM     SESSION IDLE TIMES. THE OUTPUT OF THE SCRIPT SHOWS THE
REM     SID FOR EACH SESSION RUNNING AGAINST THE DATABASE, THE
REM     LAST TIME THIS SESSION WAS ACTIVE (INCLUDING DATE AND TIME),
REM     THE CURRENT TIME AND THE AMOUNT OF TIME (IN SECONDS AS WELL
REM     AS MINUTES) ELAPSED SINCE THE SESSION BECAME INACTIVE.
REM     THIS SCRIPT IS WRITTEN TO BE RUN FROM THE SYS ACCOUNT
REM     IN SQLPLUS.


column sid format 9999
column last format a22 heading "Last non-idle time"
column curr format a22 heading "Current time"
column secs format 99999999.999 heading "idle-time |(seconds)"
column mins format 999999.99999 heading "idle-time |(minutes)"
set pages 900


select sid, to_char((sysdate - (hsecs - value)/(100*60*60*24)),
'dd-mon-yy hh:mi:ss') last, to_char(sysdate, 'dd-mon-yy hh:mi:ss') curr,
(hsecs - value)/(100) secs, (hsecs - value)/(100*60) mins
from v$timer, v$sesstat
where statistic# = (select statistic# from v$statname
                        where name = 'process last non-idle time') order by 2 desc;

REM****************************************************************************
REM****************************************************************************
REM****************************************************************************
