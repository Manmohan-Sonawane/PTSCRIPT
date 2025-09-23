spool /export/ebizdb/clover/invobj.txt
select owner,count(*) from dba_objects where status='INVALID' group by owner;
spool off
exit;
