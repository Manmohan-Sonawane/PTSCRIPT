set lines 900 pages 900
col END_INTERVAL_TIME for a30
col BEGIN_INTERVAL_TIME for a30
select
   s.begin_interval_time,
   s.end_interval_time ,
   q.snap_id,
   q.plan_hash_value,
   q.optimizer_cost,
   q.ROWS_PROCESSED_TOTAL,
   floor((q.ELAPSED_TIME_TOTAL / (1000 * 60 * 60)) / 24) " Time "
from
   dba_hist_sqlstat q,
   dba_hist_snapshot s
where
   q.sql_id = '&sql_id'
and q.snap_id = s.snap_id
order by 3 desc;

