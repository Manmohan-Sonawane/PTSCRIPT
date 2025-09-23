select trunc(first_time) on_date,
thread# thread,
min(sequence#) min_sequence,
max(sequence#) max_sequence,
max(sequence#) - min(sequence#)+1 nos_archives,
(max(sequence#) - min(sequence#)+1) * log_avg_mb req_space_mb
from v$log_history,
(select avg(bytes/1024/1024) log_avg_mb
from v$log)
group by trunc(first_time), thread#, log_avg_mb
order by on_date;
