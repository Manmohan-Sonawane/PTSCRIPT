-----------------------------Code begins here-------------------------------

REM #########################################################################
REM Purpose:  Retrieve only the ICM log file location
REM Author:   Brian Kerr
REM Email:    brian.kerr@oracle.com
REM Filename: icmlog.sql
REM Cert:     11 & 11.5
REM Note:
REM Usage:    sqlplus apps/<psswd> @icmlog.sql
REM Output:   Reference the <ICM_LOG_NAME> location after execuation
REM Notes:
REM   a.      Extracted from 'cmlogs.txt' script for Unix & NT use as 
REM           to provide a location for the ICM log retrieval.
REM 
REM #########################################################################

SELECT 'ICM_LOG_NAME=' || fcp.logfile_name
FROM    apps.fnd_concurrent_processes fcp, apps.fnd_concurrent_queues fcq
WHERE   fcp.concurrent_queue_id = fcq.concurrent_queue_id
AND     fcp.queue_application_id = fcq.application_id
AND     fcq.manager_type = '0'
AND     fcp.process_status_code = 'A';

--------------------------------Code ends here-------------------------------
