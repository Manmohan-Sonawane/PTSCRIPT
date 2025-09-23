set lines 200 pages 3000
col NAME for a40
col DISPLAY_NAME for a40
col EMAIL_ADDRESS for a50
select NAME,DISPLAY_NAME,EMAIL_ADDRESS from apps.wf_local_roles where name='&name';
