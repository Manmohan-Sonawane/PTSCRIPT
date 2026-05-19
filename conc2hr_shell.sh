##Set the Oracle environment variables for this database instance...
#this will show the requect running from 2hr in order 
#----------------------------------------------------------------------------
. /ebsprod/oracle/EBSPRD/EBSapps.env run
#
#----------------------------------------------------------------------------
# Connect via SQL*Plus and product the report...
#----------------------------------------------------------------------------
sqlplus /nolog << __EOF__ > /oci_stage/clover/crontab/alert/long_running_morethan2hr.log  2>&1
whenever oserror exit 2
whenever sqlerror exit 2
connect system/H1LSYS#1KAAYA9
whenever oserror exit 3
whenever sqlerror exit 4
set echo off timi off pau off pages 60 lines 500 trimsp on
set lines 600
set pages 5000
set markup html on
spool /oci_stage/clover/crontab/alert/long_running_morethan2hr.html
@/oci_stage/clover/crontab/alert/long_running_morethan2hr.sql
__EOF__
#
#----------------------------------------------------------------------------
# If SQL*Plus exited with a failure status, then exit the script also...
#----------------------------------------------------------------------------
#
#----------------------------------------------------------------------------
# If the report contains anything, then notify the authorities!
#----------------------------------------------------------------------------
if grep -is 'no rows selected' /oci_stage/clover/crontab/alert/long_running_morethan2hr.html >/dev/null
then
echo "No rows selected"
elif
grep -is 'PROGRAM_NAME' /oci_stage/clover/crontab/alert/long_running_morethan2hr.html >/dev/null
then
sed -i '1d;$d' /oci_stage/clover/crontab/alert/long_running_morethan2hr.html
mailx  -r "hilekaayan.alert@adityabirla.com" -s "HIL EBSPRD Long Running Request running since 2 Hrs ${ORACLE_SID}" hil-ebs.support@adityabirla.com  < /oci_stage/clover/crontab/alert/long_running_morethan2hr.html
fi
#
#----------------------------------------------------------------------------
# Return the exit status from SQL*Plus...
#----------------------------------------------------------------------------
exit 0 > /dev/null 2>&1





script:- 
SQL> !cat /oci_stage/clover/crontab/alert/long_running_morethan2hr.sql
set lines 400 pages 400
set colsep '|'
COL request_id          FOR 9999999999
COL start_time          FOR a20
COL user_name           FOR a20
COL phase_code          FOR a5
COL status_code         FOR a6
COL hrs                 FOR 99999
COL mins                FOR 99999
COL secs                FOR 99999
COL tot_mins            FOR 99999.9
COL program_name        FOR a60
COL sid                 FOR 99999
COL serial#             FOR 9999999
COL sql_id              FOR a15

select
    r.request_id                                                            request_id,
    to_char(r.actual_start_date, 'DD-MON-YY HH24:MI:SS')                   start_time,
    u.user_name                                                             user_name,
    r.phase_code                                                            phase_code,
    r.status_code                                                           status_code,
    floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)                  hrs,
    floor(
        (((SYSDATE - r.actual_start_date)*24*60*60)
        - floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600
        )/60
    )                                                                       mins,
    round(
        ((SYSDATE - r.actual_start_date)*24*60*60)
        - floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600
        - floor(
            (((SYSDATE - r.actual_start_date)*24*60*60)
            - floor(((SYSDATE - r.actual_start_date)*24*60*60)/3600)*3600
            )/60
          )*60
    )                                                                       secs,
    round((SYSDATE - r.actual_start_date)*24*60, 1)                        tot_mins,
    decode(p.user_concurrent_program_name,
           'Request Set Stage', 'RSS - '||r.description,
           'Report Set',        'RS - '||r.description,
           p.user_concurrent_program_name
    )                                                                       program_name,
    s.sid                                                                   sid,
    s.serial#                                                               serial#,
    s.sql_id                                                                sql_id
from
    gv$session                      s,
    apps.fnd_user                   u,
    apps.fnd_concurrent_processes   pr,
    apps.fnd_concurrent_programs_vl p,
    apps.fnd_concurrent_requests    r
where
    s.process                    = pr.os_process_id
    and pr.concurrent_process_id = r.controlling_manager
    and r.phase_code             = 'R'
    and r.status_code            = 'R'
    and r.requested_by           = u.user_id
    and p.concurrent_program_id  = r.concurrent_program_id
    and (SYSDATE - r.actual_start_date)*24*60 >= 120
order by
    hrs  desc,
    mins desc;

