SET AUTOTRACE TRACEONLY EXPLAIN;
explain plan set STATEMENT_ID = 'HINT' for
SELECT  /*+ index (fcm IND_FIX_CST_DRILL) */ BR_CD,DVSN_CD,COST_CENTER,FC_HEAD,FC_HEAD2,SUM(AMT) AMT
FROM
(
SELECT /*+ index (fcm IND_FIX_CST_DRILL) */ gcc.segment2 br_cd,
DECODE(gcc.segment4,'020','005',gcc.segment3) dvsn_cd,
DECODE(gcc.segment6,'507052','004',gcc.segment4) cost_center,
fc_head,
UPPER(fc_head2)fc_head2,
sum(CASE WHEN ((gcc.segment3='003' AND gcc.segment6='502028') OR (gcc.segment3!='006' AND (gcc.segment6 In ('502026','507052'))))
THEN 0 ELSE (NVL(period_net_dr,0) - NVL(period_net_cr,0)) END) Amt
FROM APPS.gl_balances@CRP2 glb,
APPS.gl_code_combinations@CRP2 gcc,
APPS.gl_periods@CRP2 glp,
FIXED_COST_MASTER_EBS fcm
WHERE TO_CHAR(fcm.flex_value)=gcc.segment6
AND
glb.code_combination_id = gcc.code_combination_id AND
glp.period_name = glb.period_name AND
glp.period_type = glb.period_type AND
glp.period_year = glb.period_year AND
glp.end_date BETWEEN '01-APR-2011' AND '31-JAN-2012'
AND fc_head NOT IN ('EMPLOYEE COST')
AND ACTUAL_FLAG='A'
AND  gcc.segment8='0000000000'
AND currency_code='INR'
AND gcc.segment4 NOT IN('026')
AND start_date != DECODE(SUBSTR('31-JAN-2012',1,6),'31-MAR','28-MAR-2010','31-JAN-2012')
GROUP BY fcm.fc_hdr,fcm.fc_ord,gcc.segment2,gcc.segment3,gcc.segment4,fc_head,fc_head2,gcc.segment6
union all
SELECT /*+ index (fcm IND_FIX_CST_DRILL) */ gcc.segment2 br_cd,
DECODE(gcc.segment4,'020','005',gcc.segment3)  dvsn_cd,
gcc.segment4 cost_center,
fc_head,
UPPER(fc_head2)fc_head2,
sum(CASE WHEN (gcc.segment3='003' AND gcc.segment6='502028') THEN 0 ELSE (NVL(period_net_dr,0) - NVL(period_net_cr,0)) END) Amt
FROM APPS.gl_balances@CRP2 glb,
APPS.gl_code_combinations@CRP2 gcc,
APPS.gl_periods@CRP2 glp,
FIXED_COST_MASTER_EBS fcm
WHERE 
gcc.segment6 IN (SELECT DISTINCT FLEX_VALUE FROM apps.FND_FLEX_VALUE_CHILDREN_V@crp2 WHERE PARENT_FLEX_VALUE =TO_CHAR(fcm.flex_value))
 AND
glb.code_combination_id = gcc.code_combination_id AND
glp.period_name = glb.period_name AND
glp.period_type = glb.period_type AND
glp.period_year = glb.period_year AND
glp.end_date BETWEEN '01-APR-2011' AND '31-JAN-2012'
AND fc_head NOT IN ('EMPLOYEE COST')
AND ACTUAL_FLAG='A' AND  gcc.segment8='0000000000'
AND currency_code='INR'
AND gcc.segment4 !='026'
AND start_date != DECODE(SUBSTR('31-JAN-2012',1,6),'31-MAR','28-MAR-2010','31-JAN-2012')
GROUP BY fcm.fc_hdr,fcm.fc_ord,gcc.segment2,gcc.segment3,gcc.segment4,fc_head,fc_head2,gcc.segment6
)GROUP BY BR_CD,DVSN_CD,COST_CENTER,FC_HEAD,FC_HEAD2;
