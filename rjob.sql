col owner for a40
col job_name for a50
select owner,job_name,state from dba_scheduler_jobs where job_name like '%TOC_VENDOR_BPR%';
