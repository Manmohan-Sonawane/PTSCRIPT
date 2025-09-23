set head off

set timing off

set time off

select '--Lock checking--' from dual;

SELECT   DECODE(request,0,'Holder: ','Waiter: ')|| sid sess, id1, id2, lmode,request, TYPE FROM V$LOCK WHERE (id1, id2, TYPE) IN (SELECT id1, id2, TYPE FROM V$LOCK WHERE request>0) ORDER BY id1, request ;

select '--Database status checking--' from dual;

select open_mode from v$database;

select '--Tablespace status check--' from dual;

select unique status from dba_tablespaces;

select '--Invalid Objects Count--' from dual;

select count(*) from dba_objects where status='INVALID';
