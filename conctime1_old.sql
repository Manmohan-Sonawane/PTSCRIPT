set lines 200
col ARGUMENT_TEXT for a80
col user_name for a20
set pages 2000

SELECT   request_id,user_name,argument_text,to_char(actual_completion_date, 'DD-MON-YYYY HH24:MI:SS')
        , (actual_completion_date -
           actual_start_date)                           *
          24                                            *
          60  "Duration", Status_code,phase_code 
FROM     apps.fnd_concurrent_requests fcr,apps.fnd_user fu
WHERE    TO_CHAR (actual_start_date, 'yyyymmddhh24mi') BETWEEN
'201810010000'
                                                           AND
'202312310000'
AND      concurrent_program_id in
(SELECT CONCURRENT_PROGRAM_ID
FROM
APPS.FND_CONC_REQ_SUMMARY_V
WHERE request_id in ('&request_id'))
AND      fu.user_id=fcr.REQUESTED_BY
--AND      (actual_completion_date - actual_start_date)*24*60 > &duration
ORDER BY actual_completion_date;


