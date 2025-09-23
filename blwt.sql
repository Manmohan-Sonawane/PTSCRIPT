set feed on

select DECODE(request,0,'HOLDER','Waiter')||sid sess,id1,id2,lmode,request,type from v$lock where (id1,id2,type)
IN (select id1,id2,type from v$lock where request>0) order by id1,request
/

