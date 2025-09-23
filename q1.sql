/* Formatted on 2013/01/30 10:22 (Formatter Plus v4.8.8) */

WITH sawith0 AS
     (SELECT d1.c1 AS c1, d1.c2 AS c2, d1.c3 AS c3, d1.c4 AS c4, d1.c5 AS c5,
             d1.c6 AS c6, d1.c7 AS c7, d1.c8 AS c8, d1.c9 AS c9,
             d1.c10 AS c10
        FROM (SELECT   /*+ index(T578022, INDX_ITM_CD) index (T578070, INDX_BR_CD_EBS) */
                       SUM (t578098.sale_amt) AS c1, SUM (t578098.qty) AS c2,
                       CASE
                          WHEN t578022.dvsn_cd = '001'
                             THEN 'LIGHTING'
                          WHEN t578022.dvsn_cd = '002'
                             THEN 'LUMINAIRES'
                          WHEN t578022.dvsn_cd = '003'
                             THEN 'EPBU'
                          WHEN t578022.dvsn_cd = '004'
                             THEN 'APPLIANCES'
                          WHEN t578022.dvsn_cd = '005'
                             THEN 'FANS'
                          WHEN t578022.dvsn_cd = '006'
                             THEN 'CORPORATE'
                          WHEN t578022.dvsn_cd = '007'
                             THEN 'MORPHY RICHARDS'
                          WHEN t578022.dvsn_cd = '009'
                             THEN 'EXPORT'
                       END AS c3,
                       t578070.br_nm AS c4, t578022.diq_pg_cd AS c5,
                       t578022.diq_pg_desc AS c6, t578022.itm_cd AS c7,
                       t578022.itm_nm AS c8, t578070.br_cd_ebs AS c9,
                       t579902.cal_year AS c10,
                       ROW_NUMBER () OVER (PARTITION BY t578022.itm_cd, t578070.br_cd_ebs, t579902.cal_year ORDER BY t578022.itm_cd ASC,
                        t578070.br_cd_ebs ASC,
                        t579902.cal_year ASC) AS c11
                  FROM item_ebs t578022,
                       region_br_obi t578070,
                       w_day_dim t579902,
                       saletran t578098
                 WHERE (t578022.itm_cd = t578098.item_cd
                        AND t578022.diq_pg_desc = 'FTL'
                        --AND t578070.br_nm = 'MUMBAI'
                        AND t578070.br_cd_ebs = t578098.tery_cd
                        AND t578098.doc_dt = t579902.day_dt
                        AND CASE
                               WHEN t578022.dvsn_cd = '001'
                                  THEN 'LIGHTING'
                               WHEN t578022.dvsn_cd = '002'
                                  THEN 'LUMINAIRES'
                               WHEN t578022.dvsn_cd = '003'
                                  THEN 'EPBU'
                               WHEN t578022.dvsn_cd = '004'
                                  THEN 'APPLIANCES'
                               WHEN t578022.dvsn_cd = '005'
                                  THEN 'FANS'
                               WHEN t578022.dvsn_cd = '006'
                                  THEN 'CORPORATE'
                               WHEN t578022.dvsn_cd = '007'
                                  THEN 'MORPHY RICHARDS'
                               WHEN t578022.dvsn_cd = '009'
                                  THEN 'EXPORT'
                            END = 'LIGHTING'
                        AND CASE
                               WHEN SUBSTR (t578022.itm_cd, 1, 1) = '9'
                                  THEN 'Spares'
                               WHEN SUBSTR (t578022.itm_cd, 1, 1) <> '9'
                                  THEN 'Regular'
                            END = 'Regular'
                        AND CASE
                               WHEN SUBSTR (t578098.item_cd, 1, 1) = '9'
                                  THEN 'Spares'
                               WHEN SUBSTR (t578098.item_cd, 1, 1) <> '9'
                                  THEN 'Regular'
                            END = 'Regular'
                        AND (t578070.reg_cd IN
                                         ('01', '02', '03', '04', '05', '06')
                            )
                        AND (t578098.fin_year IN (2011, 2012, 2013))
                        AND (t578022.dvsn_cd IN
                                ('001',
                                 '002',
                                 '003',
                                 '004',
                                 '005',
                                 '006',
                                 '007',
                                 '009'
                                )
                            )
                        AND (t578070.br_cd_ebs IN
                                ('1026',
                                 '1027',
                                 '1028',
                                 '1029',
                                 '1030',
                                 '1031',
                                 '1032',
                                 '2026',
                                 '2027',
                                 '2028',
                                 '2029',
                                 '2030',
                                 '3026',
                                 '3027',
                                 '3028',
                                 '3029',
                                 '3030',
                                 '4026',
                                 '4027',
                                 '4028',
                                 '4029',
                                 '4030',
                                 '4031',
                                 '4032',
                                 '4033',
                                 '4034',
                                 '5001',
                                 '5002',
                                 '5003',
                                 '5004',
                                 '5005',
                                 '5006',
                                 '5007',
                                 '5008',
                                 '5011',
                                 '5014',
                                 '6001',
                                 '6003',
                                 '7001',
                                 '7002',
                                 '7003'
                                )
                            )
                        AND TRUNC (t578098.doc_dt)
                               BETWEEN TO_DATE ('2013-01-01', 'YYYY-MM-DD')
                                   AND TO_DATE ('2013-01-31', 'YYYY-MM-DD')
                        AND TRUNC (t579902.day_dt)
                               BETWEEN TO_DATE ('2013-01-01', 'YYYY-MM-DD')
                                   AND TO_DATE ('2013-01-31', 'YYYY-MM-DD')
                       )
              GROUP BY t578022.itm_cd,
                       t578022.itm_nm,
                      t578022.diq_pg_cd,
                       t578022.diq_pg_desc,
                       t578070.br_nm,
                       t578070.br_cd_ebs,
                       t579902.cal_year,
                       CASE
                          WHEN t578022.dvsn_cd = '001'
                             THEN 'LIGHTING'
                          WHEN t578022.dvsn_cd = '002'
                             THEN 'LUMINAIRES'
                          WHEN t578022.dvsn_cd = '003'
                             THEN 'EPBU'
                          WHEN t578022.dvsn_cd = '004'
                             THEN 'APPLIANCES'
                          WHEN t578022.dvsn_cd = '005'
                             THEN 'FANS'
                          WHEN t578022.dvsn_cd = '006'
                             THEN 'CORPORATE'
                          WHEN t578022.dvsn_cd = '007'
                             THEN 'MORPHY RICHARDS'
                          WHEN t578022.dvsn_cd = '009'
                             THEN 'EXPORT'
                       END) d1
       WHERE (d1.c11 = 1))
SELECT   sawith0.c3 AS c1, sawith0.c4 AS c2, sawith0.c5 AS c3,
         sawith0.c6 AS c4, sawith0.c7 AS c5, sawith0.c8 AS c6,
         sawith0.c2 AS c7, sawith0.c1 AS c8, sawith0.c9 AS c9,
         sawith0.c10 AS c10
    FROM sawith0
ORDER BY c5, c9, c10
