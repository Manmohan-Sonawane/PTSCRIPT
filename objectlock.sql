col oracle_username for a30;
col os_user_name for a30;
col process for a40;
col .object_name for a40;
select lo.session_id,lo.oracle_username,lo.os_user_name,
lo.process,do.object_name,
decode(lo.locked_mode,0, 'None',1, 'Null',2, 'Row Share (SS)',
3, 'Row Excl (SX)',4, 'Share',5, 'Share Row Excl (SSX)',6, 'Exclusive',
to_char(lo.locked_mode)) mode_held
from gv$locked_object lo, dba_objects do
where lo.object_id = do.object_id
order by 1,5
/

