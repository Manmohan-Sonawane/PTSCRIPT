procedure prc_emp_dtls
(
vempcd varchar2,
vempdtls out sys_refcursor
)is
begin
open vempdtls for
 
--SELECT A.*,c.title,case when substr(A.COST_CENTER,0,2)='20' then h.description else B.DVSN_NM end dvsn_nm,C.NAME  || '(' || C.EMP_CD || ')' "REPORTING_MGR",D.NAME || '(' || D.EMP_CD || ')' "REVIEWING_MGR",
--g.br_nm,to_char(a.join_date,'dd/mm/yyyy') join_date_frmt ,
--to_char(a.LST_PROMO_DT,'dd/mm/yyyy') lst_promo_dt_frmt
--FROM EMP_MASTER a , hosys.division_ebs b ,EMP_MASTER C ,EMP_MASTER D,
--hosys.branch_ebs g,hosys.cost_center_ebs h
--WHERE a.EMP_CD=vempcd and substr(A.COST_CENTER,0,2)=B.DVSN_CD
--AND A.REP_MGR=C.EMP_CD
--AND A.REV_MGR=D.EMP_CD
--and a.BRCODE=G.BR_CD
--and a.COST_CENTER=H.STRUCTURE_CODE;
 
/*
SELECT A.*,--c.title,
 
(select mst.TITLE  from HR_AUTHORITY_MASTER rep,emp_master mst
where rep.APPRAISEE_EMP_CD=a.EMP_CD and rep.APPRAISER_EMP_CD=MST.EMP_CD) "TITLE1",
 
case when substr(A.COST_CENTER,0,2)='20' then h.description else B.DVSN_NM end dvsn_nm,
--C.NAME  || '(' || C.EMP_CD || ')' "REPORTING_MGR",D.NAME || '(' || D.EMP_CD || ')' "REVIEWING_MGR",
 
(select mst.NAME  || '(' || rep.APPRAISER_EMP_CD  || ')'  from HR_AUTHORITY_MASTER rep,emp_master mst
where rep.APPRAISEE_EMP_CD=a.EMP_CD and rep.APPRAISER_EMP_CD=MST.EMP_CD) "REPORTING_MGR",
 
(select mstt.NAME  || '(' || rev.REVIEWER_EMP_CD  || ')' from HR_AUTHORITY_MASTER rev,emp_master mstt
where rev.APPRAISEE_EMP_CD=a.EMP_CD and rev.REVIEWER_EMP_CD=MSTT.EMP_CD) "REVIEWING_MGR",
 
g.br_nm,to_char(a.join_date,'dd/mm/yyyy') join_date_frmt ,
to_char(a.LST_PROMO_DT,'dd/mm/yyyy') lst_promo_dt_frmt
FROM EMP_MASTER a , hosys.division_ebs b ,--EMP_MASTER C ,EMP_MASTER D,
hosys.branch_ebs g,hosys.cost_center_ebs h
WHERE a.EMP_CD=vempcd and substr(A.COST_CENTER,0,2)=B.DVSN_CD
--AND A.REP_MGR=C.EMP_CD
--AND A.REV_MGR=D.EMP_CD
and a.BRCODE=G.BR_CD
and a.COST_CENTER=H.STRUCTURE_CODE;
 
*/
 
SELECT A.*,c.title "TITLE1",
 
--(select mst.TITLE  from HR_AUTHORITY_MASTER rep,emp_master mst
--where rep.APPRAISEE_EMP_CD=a.EMP_CD and rep.APPRAISER_EMP_CD=MST.EMP_CD) "TITLE1",
 
case when substr(A.COST_CENTER,0,2)='20' then h.description else B.DVSN_NM end dvsn_nm,
C.NAME  || '(' || C.EMP_CD || ')' "REPORTING_MGR",D.NAME || '(' || D.EMP_CD || ')' "REVIEWING_MGR",
 
--(select mst.NAME  || '(' || rep.APPRAISER_EMP_CD  || ')'  from HR_AUTHORITY_MASTER rep,emp_master mst
--where rep.APPRAISEE_EMP_CD=a.EMP_CD and rep.APPRAISER_EMP_CD=MST.EMP_CD) "REPORTING_MGR",
 
--(select mstt.NAME  || '(' || rev.REVIEWER_EMP_CD  || ')' from HR_AUTHORITY_MASTER rev,emp_master mstt
-- where rev.APPRAISEE_EMP_CD=a.EMP_CD and rev.REVIEWER_EMP_CD=MSTT.EMP_CD) "REVIEWING_MGR",
 
g.br_nm,to_char(a.join_date,'dd/mm/yyyy') join_date_frmt ,
-- to_char(a.LST_PROMO_DT,'dd/mm/yyyy') lst_promo_dt_frmt
to_char(PROMO.LAST_PROMO_DATE,'dd/mm/yyyy') lst_promo_dt_frmt
FROM EMP_MASTER a , hosys.division_ebs b ,EMP_MASTER C ,EMP_MASTER D,
hosys.branch_ebs g,hosys.cost_center_ebs h,(SELECT EMP_CD,LAST_PROMO_DATE FROM APPRAISAL WHERE FIN_YR=2016 ) PROMO
WHERE a.EMP_CD=vempcd and substr(A.COST_CENTER,0,2)=B.DVSN_CD
AND A.REP_MGR=C.EMP_CD
AND A.REV_MGR=D.EMP_CD
and a.BRCODE=G.BR_CD
and a.COST_CENTER=H.STRUCTURE_CODE AND A.EMP_CD=PROMO.EMP_CD(+);
 
end;
