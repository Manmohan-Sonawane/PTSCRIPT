spool '&' 
SELECT sys_context('userenv','sid') AS sid   FROM dual;
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
select sysdate from dual; 
spool off;
