col name     format a32
col size_mb  format 999,999,999
col used_mb  format 999,999,999
col pct_used format 999
select
   name,
   ceil( space_limit / 1024 / 1024 / 1024) size_GB,
   ceil( space_used / 1024 / 1024 / 1024) used_GB,
   decode( nvl( space_used, 0),0, 0,
   ceil ( ( space_used / space_limit) * 100) ) pct_used
from
    v$recovery_file_dest
order by
   name desc;
