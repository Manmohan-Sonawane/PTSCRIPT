spool mysid.log
SELECT sys_context('userenv','sid') AS sid   FROM dual;
select sysdate from dual; 
spool off;
