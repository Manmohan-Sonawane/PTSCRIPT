   (SELECT 
           Emp_cd,
           "Name",
           "Designation",
           grade_new,
           "HOD",
           "Division Name",
           "Cost Center",
           "Description",
           "Branch",
           "Location",
           posid,
           "Position Desc",
           "Qualification",
           Resigned,
           "Birth Date",
           "Age as on date",
           "Total exp in Years",
           "Total exp in Months",
           "Last Employer Name",
           "Join Date",
           "Actual Confirmation Date",
           "Retirement Date",
           "Site Flag",
           "Super Annuation Flag",
           "NPS Flag",
           "Conveyance Scheme",
           "Basic",
           "HRA",
           "Add. Allowance",
           "Conveyance",
           "Medical",
           "Car Allowance",
           "Payroll OA",
           "Fuel and Maint",
           "Driver Allowance",
           "Phone",
           "Annual Health Check Up",
           "NPS @ 10% basic",
           "Site Allowance",
           "Site Accommodation Amt",
           "Total Monthly Gross",
           "PF @ 12% Basic",
           "Gratuity @ 5% Basic",
           "SA @ 15% Basic",
           "LTA",
           "Bonus/ Ex-gratia",
           "Ins.Prem (Approx)",
           ROUND (
                (  "Total Monthly Gross"
                 + (  "PF @ 12% Basic"
                    + "SA @ 15% Basic"
                    + "Gratuity @ 5% Basic"
                    + "LTA"
                    --   + "Medical"                       -- as per discuss with Divya Nayar and Nupur Bhatia
                    + "Bonus/ Ex-gratia"
                    + "Ins.Prem (Approx)"))
              * 12,
              0)
              "Annual CTC before Incentive",
           ROUND (INCENTIVE, 0) "Incentive @ Excellent Rating",
           ROUND (
                (  (  "Total Monthly Gross"
                    + (  "PF @ 12% Basic"
                       + "SA @ 15% Basic"
                       + "Gratuity @ 5% Basic"
                       + "LTA"
                       --  + "Medical"
                       + "Bonus/ Ex-gratia"
                       + "Ins.Prem (Approx)"))
                 * 12)
              + INCENTIVE,
              0)
              "Total CTC",
           "LY Rating",
           "LLY Rating",
           "LLLY Rating",
           "Last Promotion Date",
           "Resigned Date",
           "Relieved Date",
           brcode,
           STRUCTURE_CODE
      FROM (SELECT a.Emp_cd emp_cd,
                   INITCAP (a.name) "Name",
                   a.DESIGNATION "Designation",
                   a.GRADE_NEW grade_new,
                   DECODE ( (SELECT emp_cd
                               FROM hosys.cmc
                              WHERE emp_cd = a.emp_cd),
                           '', 'No',
                           'Yes')
                      "HOD",
                   DECODE (
                      A.COST_CENTER,
                      '040010', 'Inst. and Malls',
                      '040006', 'Appliances Support',
                      '040008', 'Appliances Support',
                      '201009', 'Consumer Products',
                      '201015', 'Consumer Products',
                      '201016', 'Consumer Products',
                      DECODE (SUBSTR (A.COST_CENTER, 1, 2),
                              '01', 'Lighting',
                              '02', 'Illumination - S',
                              '03', 'Illumination - P',
                              '04', 'DAP',
                              '05', 'Fans',
                              '08', 'Morphy Richards',
                              '09', 'Exports',
                              '20', 'Support Function',
                              '10', 'KAP',
                              '13', 'EPC-TLT',
                              '14', 'EPC-Power Distribution',
                              '15', 'EPC-Corporate',
                              '16', 'Consumer Products'))
                      "Division Name",
                   a.COST_CENTER AS "Cost Center",
                   DECODE ( (c.DESCRIPTION),
                           'Dap', 'Domestic Appliances',
                           'Kap', 'Kitchen Appliances',
                           'Tlt', 'Transmission Lines Tower',
                           'Epc-Corporate', 'EPC-Corporate',
                           'Cp', 'Consumer Products',
                           (DESCRIPTION))
                      "Description",
                   INITCAP (br_nm) "Branch",
                   (SELECT DISTINCT INITCAP (Office)
                      FROM office
                     WHERE ID = a.OFFICEID)
                      "Location",
                   a.posid posid,
                   POSDESC "Position Desc",
                   a.QUALIFICATION "Qualification",
                   DECODE (a.RESIGNED,  'Y', 'Yes',  'N', 'No') Resigned,
                   TO_CHAR (a.BIRTH_DATE, 'DD-Mon-YYYY') "Birth Date",
                      TRUNC (MONTHS_BETWEEN (SYSDATE, a.BIRTH_DATE) / 12)
                   || '.'
                   || TRUNC (
                         MOD (MONTHS_BETWEEN (SYSDATE, a.BIRTH_DATE), 12))
                      "Age as on date",
                   (CASE
                       WHEN (  TRUNC (
                                  MOD (MONTHS_BETWEEN (SYSDATE, a.Join_date),
                                       12))
                             + NVL (a.XEMPR_EXPMM, 0)) > 12
                       THEN
                            (  TRUNC (
                                  MONTHS_BETWEEN (SYSDATE, a.Join_date) / 12)
                             + NVL (a.XEMPR_EXPYY, 0))
                          + 1
                       ELSE
                          (  TRUNC (
                                MONTHS_BETWEEN (SYSDATE, a.Join_date) / 12)
                           + NVL (a.XEMPR_EXPYY, 0))
                    END)
                      "Total exp in Years",
                   (CASE
                       WHEN (  TRUNC (
                                  MOD (MONTHS_BETWEEN (SYSDATE, a.Join_date),
                                       12))
                             + NVL (a.XEMPR_EXPMM, 0)) > 12
                       THEN
                            (  TRUNC (
                                  MOD (MONTHS_BETWEEN (SYSDATE, a.Join_date),
                                       12))
                             + NVL (a.XEMPR_EXPMM, 0))
                          - 12
                       ELSE
                          (  TRUNC (
                                MOD (MONTHS_BETWEEN (SYSDATE, a.Join_date),
                                     12))
                           + NVL (a.XEMPR_EXPMM, 0))
                    END)
                      "Total exp in Months",
                   a.XEMPR_NAME "Last Employer Name",
                   TO_CHAR (a.JOIN_DATE, 'DD-Mon-YYYY') "Join Date",
                   TO_CHAR (a.ACTUAL_CONF_DATE, 'DD-Mon-YYYY')
                      "Actual Confirmation Date",
                   TO_CHAR (a.RETDATE, 'DD-Mon-YYYY') "Retirement Date",
                   DECODE (a.SITE_FLAG,  NULL, 'No',  'Y', 'Yes',  'N', 'No')
                      "Site Flag",
                   DECODE (a.SUPERANN_FLAG,
                           'Y', 'Yes',
                           'N', 'No',
                           NULL, 'No')
                      "Super Annuation Flag",
                   DECODE (a.NPS_FLAG,  NULL, 'No',  'Y', 'Yes',  'N', 'No')
                      "NPS Flag",
                   a.CONVEYANCE_SCHEME "Conveyance Scheme",
                   a.Basic "Basic",
                   NVL (a.HRA, 0) "HRA",
                   NVL (a.ADDN_ALLOW, 0) "Add. Allowance",
                   NVL (a.CONVEYANCE, 0) "Conveyance",
                   DECODE (A.BRCODE,
                           '100', 0,
                           '101', 0,
                           DECODE ( (SELECT UPPER (GRADE_CATEGORY)
                                       FROM grade
                                      WHERE grade = A.GRADE_NEW),
                                   'PSG', 0,
                                   ROUND (15000 / 12)))
                      "Medical",
                   NVL (CAR_ALLOW, 0) "Car Allowance",
                   NVL (a.SPL_ALLOW, 0) "Payroll OA",
                  -- (SELECT fnc_fetcFuelamt (a.emp_Cd) FROM DUAL)
                  --    "Fuel and Maint",
                   (SELECT fnc_fetcDRIVERamt (a.emp_Cd) FROM DUAL)
                      "Driver Allowance",
                   (SELECT fnc_fetcPhoneamt (a.emp_Cd) FROM DUAL) "Phone",
                   (SELECT fnc_fetcHealthamt (a.emp_cd) FROM DUAL)
                      "Annual Health Check Up",
                   NVL (SITE_ALL, 0) "Site Allowance",
                   NVL (SITE_ACCM_ALLOW, 0) "Site Accommodation Amt",
                   ROUND (
                      (  a.Basic
                       + NVL (a.HRA, 0)
                       + NVL (a.SPL_ALLOW, 0)
                       + DECODE (a.NPS_FLAG,
                                 'Y', ROUND (a.Basic * (10 / 100), 0),
                                 0)
                       + NVL (a.ADDN_ALLOW, 0)
                       + NVL (a.CONVEYANCE, 0)
                       + NVL (CAR_ALLOW, 0)
                       + (SELECT fnc_fetcFuelamt (a.emp_Cd) FROM DUAL)
                       + (SELECT fnc_fetcDRIVERamt (a.emp_Cd) FROM DUAL)
                       + (SELECT fnc_fetcPhoneamt (a.emp_Cd) FROM DUAL)
                       + (SELECT fnc_fetcHealthamt (a.emp_cd) FROM DUAL)
                       + NVL (SITE_ALL, 0)
                       + NVL (SITE_ACCM_ALLOW, 0)
                       + DECODE (A.BRCODE,
                                 '100', 0,
                                 '101', 0,
                                 DECODE ( (SELECT UPPER (GRADE_CATEGORY)
                                             FROM grade
                                            WHERE grade = A.GRADE_NEW),
                                         'PSG', 0,
                                         ROUND (15000 / 12)))),
                      0)
                      "Total Monthly Gross",
                  CASE
                     WHEN NVL (a.basic, 0) <= 15000 THEN 1800
                     ELSE ROUND (a.basic * (12 / 100), 0)
                  END   
                   "PF @ 12% Basic",
                                     ROUND (a.basic * (5 / 100), 0) "Gratuity @ 5% Basic",
                   DECODE (a.SUPERANN_FLAG,
                           'Y', ROUND (a.basic * (15 / 100), 0),
                           0)
                      "SA @ 15% Basic",
                   DECODE (a.NPS_FLAG,
                           'Y', ROUND (a.Basic * (10 / 100), 0),
                           0)
                      "NPS @ 10% basic",
                   ROUND (
                        (SELECT NVL (MAX (value_g), 0)
                           FROM paydb.TNP022
                          WHERE     EDCODE_ = 'E009'
                                AND (PRMM_GR =
                                        (SELECT MAX (PRMM_GR)
                                           FROM paydb.TNP022
                                          WHERE PRYY_GR =
                                                   (SELECT MAX (PRYY_GR)
                                                      FROM paydb.TNP022)))
                                AND (PRYY_GR =
                                        (SELECT MAX (PRYY_GR)
                                           FROM paydb.TNP022))
                                AND grade_g = '10' || a.GRADE_NEW)
                      / 12)
                      "LTA",
                   ROUND (16800 / 12) "Bonus/ Ex-gratia",
                   (SELECT NVL (SUM (PREMIUM_AMT), 0)
                      FROM ctc_Insurance_Premium
                     WHERE     grade = a.GRADE_NEW
                           AND from_dt = (SELECT MAX (from_dt)
                                            FROM ctc_Insurance_Premium
                                           WHERE grade = a.GRADE_NEW))
                      "Ins.Prem (Approx)",
                   FINAL_RATING "LY Rating",
                   (SELECT FINAL_RATING
                      FROM APPRAISAL_rating
                     WHERE     emp_cd = a.emp_cd
                           AND fin_year =
                                  (SELECT MAX (FIN_YEAR) - 1
                                     FROM APPRAISAL_rating))
                      "LLY Rating",
                   (SELECT FINAL_RATING
                      FROM APPRAISAL_rating
                     WHERE     emp_cd = a.emp_cd
                           AND fin_year =
                                  (SELECT MAX (FIN_YEAR) - 2
                                     FROM APPRAISAL_rating))
                      "LLLY Rating",
                   TO_CHAR (a.LST_PROMO_DT, 'DD-Mon-YYYY')
                      "Last Promotion Date",
                   (SELECT hris.fnc_fetcIncentive (a.emp_cd) FROM DUAL) INCENTIVE,
                   a.RESIGN_DATE "Resigned Date",
                   RELIEVED_DATE "Relieved Date",
                   a.brcode brcode,
                   STRUCTURE_CODE
              FROM emp_master a,
                   hosys.division_ebs b,
                   hosys.COST_CENTER_EBS c,
                   hosys.branch_ebs br,
                   position p,
                   --  emp_eligibility elig,
                   APPRAISAL_rating ly
             WHERE     SUBSTR (a.COST_CENTER, 0, 2) = B.DVSN_CD
                   AND a.COST_CENTER = c.STRUCTURE_CODE(+)
                   AND TO_NUMBER (a.brcode) = TO_NUMBER (br_cd)
                   AND a.brcode NOT IN (100, 101)
                   AND a.posid = p.posid(+)
                   AND a.emp_cd = ly.emp_cd(+)
                   AND ly.FIN_Year(+) = 2019 -- (select max(FIN_YEAR) from APPRAISAL_rating)
                                            ) a) ;
