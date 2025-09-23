set pages 500
select t.tablespace_name "TABLESPACE", t.TOTAL "TOTAL SIZE",
nvl(f.FREE,0) "FREE SPACE",round(nvl(f.FREE,0)*100/t.TOTAL) "% FREE"
FROM
(select tablespace_name,trunc(sum(bytes)/1024/1024) as "TOTAL" from dba_data_files group by tablespace_name) t,
(select tablespace_name,trunc(sum(bytes)/1024/1024) as "FREE" from dba_free_space group by tablespace_name) f
where t.tablespace_name=f.tablespace_name(+)
order by 4;
