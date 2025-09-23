nes 150 pages 1000
col module for a50
col "START TIME" for a30
col "END TIME" for a30
select MODULE,to_char(START_TIME,'DD-MON-YY hh24:mi:ss') "START TIME",to_char(END_TIME,'DD-MON-YY hh24:mi:ss') "END TIME",MIN from hosys.toc_execution_log
where module not in ('TOC PROCESS STARTED',
'TOC','TOC_INV_CAP','sp_toc_po',
'SP_TOC_MIT','VENDOR_BPR','DEALERS_BPR','SUPPLIER BPR','LUM_VENDOR_BPR',
'LUM_MTO_BPR_REPORT','LUM_RESERVATION_DATE','lum_bi_report_obi','DBM','Xxbel_Toc.MANUAL_ISO_CANCEL','pkg_toc_project_lum.sp_lum_excess_po') and
START_TIME > sysdate-5 order by START_TIME;
