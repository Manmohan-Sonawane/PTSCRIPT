set lines 200
col VALUE for a30
select x.ksppinm name, y.ksppstvl value
from sys.x$ksppi x, sys.x$ksppcv y
where x.inst_id= userenv('Instance')
and y.inst_id=  userenv('Instance')
and x.indx= y.indx
and x.ksppinm like '%&parameter%'
order by translate(x.ksppinm,'_',' ');

