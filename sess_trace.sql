column c_sid            format 99999999 heading 'sid';
column c_serial         format 99999999 heading 'serial';
column c_module         format a12      heading 'module';
column c_logon_time     format a18      heading 'logon time';

set term on ver off feed off;
prompt;

select
s.sid     c_sid,
s.serial# c_serial,
s.module  c_module,
to_char(s.logon_time,'DD-MON-YY HH24:MI:SS') c_logon_time
from
v$session s,
v$process p
where
s.sid = &&session_id
and p.addr = s.paddr
and s.module is not null;

prompt;
accept sid    prompt 'Enter <sid> corresponding to your Form: ';
accept serial prompt 'Enter corresponding <serial>          : ';
prompt;

pause Click <Enter> to START tracing;

-- exec dbms_support.start_trace_in_session(&&sid,&&serial,true,true);
EXEC DBMS_SYSTEM.SET_EV(&&sid,&&serial,10046,12,'');

prompt Tracing your Form with Event 10046;
prompt;
pause Click <Enter> to STOP tracing;

-- exec dbms_support.stop_trace_in_session(&sid,&serial);
EXEC DBMS_SYSTEM.SET_EV(&&sid,&&serial,10046,0,'');

select
value||'/*'||'&VERSION_DATABASE_PROCESS'||'*'
"Raw SQL Trace File"
from
v$parameter
where
name = 'user_dump_dest';

prompt;
undef version_database_process sid serial;
set ver on feed on;
