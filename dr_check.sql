select current_timestamp from dual;
select name from v$database;
select sum(A) "PROD",sum(B) "DR",nvl(sum(A-B),0) "Difference to sync" from (select ARCHIVED_SEQ# A,0 B
from v$archive_dest_status where DEST_ID = 1 and STATUS='VALID' union all select 0 A,APPLIED_SEQ# B FROM
v$archive_dest_status WHERE DEST_ID= 2);
exit
