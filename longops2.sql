select
  vl.*, vsql.sql_fulltext
from
  v$session_longops vl,
  v$sqlarea vsql
where
  vl.sql_id = vsql.sql_id
  AND
  vl.username = '&USERNAME'
  AND
  vl.time_remaining > 30
  AND
  vl.elapsed_seconds > 30
;
