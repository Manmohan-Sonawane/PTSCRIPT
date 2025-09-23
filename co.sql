explain plan for INSERT INTO hosys.complaintproduct_dtlshistory
            (complainthistoryproductid, complaintproductid,
             complaintid, complaintcode, dvsn_cd, pg_cd, prd_typeid, itm_cd,
             problem, servicecity, activedate, pincode, typeofcall,
             activestatus, ref_complaintcode, closureid, homeservice,
             workshopservice, dealerplaceservice, sourcename, area_id,
             bccdid, br_cd, regionid, serviceplace, assignedtechician,
             assigneddate, purchasedate, technicianactiontaken, productsno,
             guranteestatus, guranteecardno, updatedate, closureidstatus,
             warrantydate, billcopyno, primary_defect_id,
             secondary_defect_id, teritary_defect_id, softclosuredate, posid,
             history_remark, ip
            )
     VALUES ((SELECT NVL (MAX (complainthistoryproductid), 0) + 1
                FROM hosys.complaintproduct_dtlshistory), :b41,
             :b40, :b39, :b38, :b37, :b36, :b35,
             :b34, :b33, :b32, :b31, :b30,
             :b29, :b28, :b27, :b26,
             :b25, :b24, :b23, :b22,
             :b21, :b20, :b19, :b18, :b17,
             :b16, :b15, :b14, :b13,
             :b12, :b11, SYSDATE, :b10,
             :b9, :b8, :b7,
             :b6, :b5, :b4, :b3,
             :b2, :b1
            );
set lines 500 pages 700
@?/rdbms/admin/utlxpls
