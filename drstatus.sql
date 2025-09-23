select systimestamp from dual


set line 180
col dest_name for a30
col destination for a20
col error for a40
break on thread# skip 1

--select thread#, dest_id, dest_name, destination, last_sequence, last_sequence - first_value (last_sequence) over (partition by thread# order by dest_id) diff,
--STATUS,ERROR
--from (select al.thread#, al.dest_id, ad.dest_name, ad.destination,ad.STATUS,ad.ERROR, max(al.sequence#) last_sequence from gv$archived_log al, gv$archive_dest
-- ad
--where al.dest_id=ad.dest_id and al.thread#=ad.inst_id
--group by al.thread#, al.dest_id, ad.dest_name, ad.destination ,ad.STATUS,ad.ERROR
--order by 1,2 ) ;

select al.thread#, al.dest_id, ad.dest_name, ad.destination,ad.STATUS,ad.ERROR
from gv$archived_log al, gv$archive_dest ad
where al.dest_id=ad.dest_id and al.thread#=ad.inst_id
group by al.thread#, al.dest_id, ad.dest_name, ad.destination ,ad.STATUS,ad.ERROR
order by 1,2;
CLEAR BREAKS


--select thread#, max(case when dest_id = 1 then SEQUENCE# end) dest_1,
--max(case when dest_id = 1 then SEQUENCE# end) - max(case when dest_id = 2  and applied = 'YES' then SEQUENCE# end) dest_2,
--max(case when dest_id = 1 then SEQUENCE# end) - max(case when dest_id = 3  and applied = 'YES' then SEQUENCE# end) dest_3,
--max(case when dest_id = 1 then SEQUENCE# end) - max(case when dest_id = 4  and applied = 'YES' then SEQUENCE# end) dest_4,
--max(case when dest_id = 1 then SEQUENCE# end) - max(case when dest_id = 5  and applied = 'YES' then SEQUENCE# end) dest_5,
--max(case when dest_id = 1 then SEQUENCE# end) - max(case when dest_id = 6  and applied = 'YES' then SEQUENCE# end) dest_6
--from v$archived_log group by thread#;

set line 180
break on  dest_id skip 1
set pagesize 50
select b.dest_id,a.thread#,a.log_archived,b.log_applied,(a.log_archived-b.log_applied) log_gap
from
(
select thread#,max(sequence#)log_archived from gv$archived_log where archived='YES' group by thread#
)a,
(
select thread#,dest_id,max(sequence#)log_applied from gv$archived_log where applied='YES' and dest_id >1 group by dest_id,thread#
)b
where a.thread#=b.thread#
order by dest_id,thread#;
clear breaks

