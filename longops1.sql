select
  vl.*, vsql.sql_fulltext
from
  v$session_longops vl,
  v$sqlarea vsql
where
  vl.sql_id = vsql.sql_id
  AND
  vl.sql_id = vsql.sql_id
ORDER BY
  vl.elapsed_seconds desc
;
