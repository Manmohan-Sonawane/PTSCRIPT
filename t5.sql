conn hosys/ADNPP5237461Q
SELECT year "Year",
         month "Month",
         c.br_cd,
         (SELECT br_nm
            FROM branch_ebs br
           WHERE br.br_cd = c.BR_CD)
            "Branch",
         (SELECT DISTINCT bccdname
            FROM bccdmaster
           WHERE BCCDCODE = b.BCCDID)
            "BCCD",
         b.COMPLAINTCODE,
         CLOSURE_NO_OF_HRS_AFTER_ADJ "Clousure No Of Hrs",
         PYT_SLAB "PYT SLAB",
         (NVL (BASE_RATE, 0) + NVL (ADDL_RATE, 0)) "Payment as per slab",
         DECODE (NVL (ADDL_RATE_LAST_SLAB, '0'),  '0', '0',  '5', 'Rs5/-')
            "Additional 5 Rs Incentive",
         NVL (ATUAL_CALL_AMT_TOBE_PAID, 0) "Total amount Paid",
         DECODE (NVL (CALL_ELIGIBILE, 'E'),
                 'E', 'Regular Call',
                 'DS', 'Duplicate Calls Validated by SIC as Regular',
                 'PS', 'Penalty Calls Validated by SIC',
                 'IS', 'Invalid Calls Validated by SIC',
                 'R', 'Tag Calls verified by SIC',
                 'N', 'Not Eligible',
                 'DP', 'Dupliacte Call Validated by SIC As Penalty',
                 'PP', 'Penalty Call Validated by SIC As Penalty',
                 'IP', 'Invalid SrNo. Call Validated by SIC As Penalty',
                 'D', 'Dupliacte Call',
                 'P', 'Penalty Call',
                 'I', 'Invalid SrNo. Call')
            "Call Status",
         PAYABLE_REASON "NON-Payable Reason",
         TO_CHAR (CALL_CLOSURE_DT, 'dd-mm-yyyy hh24:mi:ss') "Call Closure date",
         TO_CHAR (b.ACTIVEDATE, 'dd-mm-yyyy hh24:mi:ss') "Complaint Date",
         REALLOCATEDATE "Reallocated date",
         SOFT_CLOSUREDT "Soft Closure Date",
         DECODE (b.TYPEOFCALL,
                 '3', 'Demo',
                 '4', 'Out Warranty',
                 '6', 'Under Warranty',
                 '7', 'Installation',
                 '9', 'Stock Set',
                 'R', 'Reaplacement Tag Call')
            "Type Of Call Desc",
         DECODE (b.GURANTEESTATUS,  '1', 'Yes',  '2', 'Yes',  '4', 'No')
            "Warranty Status",
         PRODUCTSNO,
         DECODE (SERVICECITY,  '1', 'Incity',  '2', 'Outcity')
            "SERVICECITYDESC",
         DECODE (SIC_ACTION,
                 '1', 'Call paid as per slab Validation',
                 '2', 'No Payment',
                 '3', 'Penalty')
            "SIC Action",
         sic_remark "SIC Remark"
    FROM BCCD_PYT_DTL b, BCCD_COMPLAINTPRODUCT_DETAILS c
   WHERE     year IN (2016)
         AND month IN (7)
         AND c.COMPLAINTCODE = b.COMPLAINTCODE
         AND b.activestatus = '0'
ORDER BY c.br_cd, b.bccdid, TRUNC (CLOSURE_NO_OF_HRS_AFTER_ADJ);
