##Set the Oracle environment variables for this database instance...
#this will show the enq sessions
#----------------------------------------------------------------------------
. /ebsprod/oracle/EBSPRD/EBSapps.env run
#
#----------------------------------------------------------------------------
# Connect via SQL*Plus and product the report...
#----------------------------------------------------------------------------
sqlplus /nolog << __EOF__ > /oci_stage/clover/crontab/alert/enq.log  2>&1
whenever oserror exit 2
whenever sqlerror exit 2
connect system/H1LSYS#1KAAYA9
whenever oserror exit 3
whenever sqlerror exit 4
set echo off timi off pau off pages 60 lines 500 trimsp on
set lines 600
set pages 5000
set markup html on
spool /oci_stage/clover/crontab/alert/enq.html
@/oci_stage/clover/crontab/alert/enq.sql
__EOF__
#
#----------------------------------------------------------------------------
# If SQL*Plus exited with a failure status, then exit the script also...
#----------------------------------------------------------------------------
#
#----------------------------------------------------------------------------
# If the report contains anything, then notify the authorities!
#----------------------------------------------------------------------------
if grep -is 'no rows selected' /oci_stage/clover/crontab/alert/enq.html >/dev/null
then
echo "No rows selected"
elif
grep -is 'PROGRAM_NAME' /oci_stage/clover/crontab/alert/enq.html >/dev/null
then
sed -i '1d;$d' /oci_stage/clover/crontab/alert/eqn.html
mailx  -r "hilekaayan.alert@adityabirla.com" -s "HIL EBSPRD enq sessions ${ORACLE_SID}" hil-ebs.support@adityabirla.com  < /oci_stage/clover/crontab/alert/enq.html
fi
#
#----------------------------------------------------------------------------
# Return the exit status from SQL*Plus...
#----------------------------------------------------------------------------
exit 0 > /dev/null 2>&1





script:- 


SQL> !cat /oci_stage/clover/crontab/alert/enq.sql
set lines 400 pages 400
set colsep '|'
select inst_id,sid,event,p1,p2,p3,wait_time,seconds_in_wait from gv$session_wait where event like 'enq%' order by 8 desc;

