SELECT sysdate -1, COUNT(*)
FROM apps.fnd_concurrent_requests
WHERE to_char(actual_completion_date,'YYYYMMDD') =
(SELECT to_char(sysdate -1,'YYYYMMDD') FROM dual);
