SET SERVEROUTPUT ON
DECLARE
  my_sqltext CLOB;
  task_name VARCHAR2(30);
BEGIN
  my_sqltext := 'select ab.prd_seg as grpcode,ab.prd_desc as grpdesc,ab.subtotal as RegionCode,ab.grp_name as RegionName,ab.DIQ_PG_CD_EBS diq_pg_cd_ebs,'||
		'ab.diq_pg_desc as productname,round(nvl(MTDTARGETSALES,0),0) as mtdtargetsales,nvl(mtdactualsales,0) as mtdactualsales  from'||
		'( SELECT prd_seg,prd_desc,b.subtotal ,b.grp_name, DIQ_PG_CD_EBS ,DIQ_PG_DESC, ( select sum(nvl(trgt_value,0)) tgt'||
		'from sls_area_target_ebs x , SALES_AREA_EBS TSI,pg_seq z  ,BRANCH_EBS BR  where x.year=2012 and  month= 08'||
		'AND x.BR_CD in(select br_cd from branch_ebs where reg_cd='03' and br_type='B' and status='A' and br_Cd_ebs is not null)'||
		'and tsi.dvsn_cd='002' and tsi.status='A'||
		'AND TSI.SA_CD=X.SA_CD AND BR.BR_CD_EBS=TSI.BR_CD AND BR.BR_CD=X.BR_CD AND A.DIQ_PG_CD_EBS= X.MIPG_CD'||
		'AND A.DIQ_PG_CD_EBS= Z.DIQ_PG_CD AND Z.DVSN_CD='002' and subtotal in(2001,2002) and tsi.PRD_SEG=c.prd_seg'||
		'GROUP BY X.MIPG_CD ) AS MTDTARGETSALES fROM  DIQ_PRD_GRP_EBS_VYP A,pg_seq b,prd_seg c WHERE a.DVSN_CD='002' and a.DIQ_PG_CD_EBS=b.diq_pg_cd'||
		'and b.subtotal in(2001,2002) and c.prd_seg in(1,2) group by  prd_seg,prd_desc,b.subtotal ,b.grp_name, DIQ_PG_CD_EBS ,DIQ_PG_DESC) ab,'||
		'(SELECT  prd_seg,prd_desc,b.subtotal ,b.grp_name, DIQ_PG_CD_EBS ,DIQ_PG_DESC,( select nvl(round(sum(sale_amt)/1000,0),0) samt'||
		'from saletran x, SALES_AREA_EBS Y,pg_seq z  where fin_year=2012 and  month= 08 and x.dvsn_cd='002'and'||
		'x.tery_cd in(select br_cd_ebs from branch_ebs where reg_cd='03' and br_type='B' and status='A' and br_Cd_ebs is not null)'||
		'AND A.DIQ_PG_CD_EBS=X.PG_CD AND y.sa_cd=x.sa_cd and y.br_cd=x.tery_cd and y.status='A' and y.dvsn_cd='002' and z.dvsn_Cd='002' and z.subtotal in(2001,2002)'||
		'and z.DIQ_PG_CD=x.pg_cd and z.diq_pg_cd=a.DIQ_PG_CD_EBS and y.PRD_SEG=c.prd_seg group by x.pg_Cd ) AS MTDActualSales'||
		'FROM DIQ_PRD_GRP_EBS_VYP A,pg_seq b,prd_seg c WHERE a.DVSN_CD='002' and a.DIQ_PG_CD_EBS=b.diq_pg_cd and b.subtotal in(2001,2002)'||
		'and c.prd_seg in(1,2) group by  prd_seg,prd_desc,b.subtotal ,b.grp_name, DIQ_PG_CD_EBS ,DIQ_PG_DESC) ab1 where 1=1 and ab.prd_seg=ab1.prd_seg'||
		'and ab.prd_desc=ab1.prd_desc and ab.subtotal=ab1.subtotal and ab.grp_name=ab1.grp_name and ab.diq_pg_Cd_ebs=ab1.diq_pg_cd_ebs and ab.diq_pg_desc=ab1.diq_pg_desc'||
		'order by ab.prd_seg, ab.prd_desc,ab.subtotal,ab.grp_name,ab.diq_pg_cd_ebs,ab.diq_pg_desc';
task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK( sql_text => my_sqltext,
                                   bind_list => sql_binds(anydata.ConvertNumber(100)),
                                   scope => 'COMPREHENSIVE',
                                   time_limit => 60,
                                   task_name => 'sql_tuning_task1');
END;
/
