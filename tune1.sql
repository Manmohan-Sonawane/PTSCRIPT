explain plan for
/* Formatted on 2015/12/31 19:32 (Formatter Plus v4.8.8) */
SELECT          /*+ INDEX_COMBINE(CCM) */
       DISTINCT INITCAP (br.br_nm) AS "Branch",
                --(SELECT INITCAP (NAME)
                 --  FROM hris.v_emp_master
-- WHERE emp_cd = bm.cc_emp_cd) "SIC/ASIC Name",
                DECODE (excl,
                        'Y', 'Exclusive',
                        'N', 'Non Exclusive'
                       ) "Excl/Non Excl BCCD",
                bm.bccdname AS "BCCD Name", bm.bccdcode "BCCD Code",
                town AS "BCCD Town", cpd.pincode AS "Pin Code",
                area AS "Pin Code Area", dvsn_abbr AS "BU",
                itm.diq_pg_desc AS "PG Desc", TYPE AS "Product Type",
                itm_nm "Product Name", TO_CHAR (itm.itm_cd) "Item Code",
                cpd.complaintcode AS "Complaint Number",
                INITCAP (customername) AS "Customer Name",
                ccm.mobilenumber AS "Calling Number",
                ccm.mobilenumber AS "Mobile Number",
                ccm.homephone AS "Home Phone",
                ccm.officephone AS "Office Phone",
                ccm.emailaddress AS "Email Address",
                TO_CHAR (cpd.activedate,
                         'DD-Mon-YYYY  HH:MI:SS AM'
                        ) "Complaint Date",
                CASE
                   WHEN TRUNC
                          (cpd.reassigneddate
                          ) > TRUNC (cpd.assigneddate)
                      THEN TO_CHAR (cpd.reassigneddate,
                                    'DD-Mon-YYYY  HH:MI:SS AM'
                                   )
                   ELSE TO_CHAR (cpd.assigneddate, 'DD-Mon-YYYY  HH:MI:SS AM')
                END AS "Assigned / Re-assigned  Date",
                TO_CHAR (updatedate,
                         'DD-Mon-YYYY  HH:MI:SS AM'
                        ) AS "Attended Date",
                TO_CHAR (cpd.purchasedate,
                         'DD-Mon-YYYY  HH:MI:SS AM'
                        ) AS "Purchase Date",
                cpd.productsno AS "Product Sr.No.", cpd.problem AS "Problem",
                cpd.technicianactiontaken AS "Technician Remarks",
                (SELECT defect_name
                   FROM primary_defect_master
                  WHERE primary_defect_id = cpd.primary_defect_id)
                                                                  AS "Defect",
                NULL AS "Repair Description ",
                (bmp.firstname || ' ' || bmp.lastname || ' ' || bmp.middlename
                ) AS "Technician Name",
                (SELECT MAX (reallocatedate)
                   FROM bccd_wrongallocatedate
                  WHERE ID =
                           (SELECT MAX (ID)
                              FROM bccd_wrongallocatedate
                             WHERE complaintproductid = cpd.complaintproductid
                               AND ROWNUM = 1)
                    AND ROWNUM = 1) AS "Reallocated Date",
                bcal.servicetypedescription AS "Call Type",
                customer_type AS "Customer Type",
                DECODE (servicecity,
                        '1', 'INCITY',
                        '2', 'OUTCITY'
                       ) AS "Nature of Call",
                serviceplace AS "Repair Location",
                DECODE (cpd.activestatus,
                        '0', 'Closed Call',
                        '7', 'Soft Closed Calls',
                        '8', 'Cancelled Call'
                       ) AS "Call Status",
                DECODE (cpd.guranteestatus,
                        1, 'Dealer Stock Set',
                        2, 'Yes',
                        3, 'Not Known',
                        4, 'No'
                       ) "Warranty Status",
                TO_CHAR
                   (closuredate_servicetechnician,
                    'DD-Mon-YYYY  HH:MI:SS AM '
                   ) AS "Call Closure date with time",
                ROUND
                   ((  (closuredate_servicetechnician)
                     - CASE
                          WHEN (reassigneddate) > (assigneddate)
                             THEN (reassigneddate)
                          ELSE (assigneddate)
                       END
                    ),
                    2
                   ) AS "No of days for closure",
                ROUND
                   (  (  (closuredate_servicetechnician)
                       - CASE
                            WHEN (reassigneddate) > (assigneddate)
                               THEN (reassigneddate)
                            ELSE (assigneddate)
                         END
                      )
                    * 24,
                    2
                   ) AS "No of hours for closure",
                (SELECT func_calldayscal
                                   (cpd.complaintid,
                                    cpd.complaintcode
                                   )
                   FROM DUAL) AS "Slab closure (TAT)",
                sanc.last_upd_by AS "ReplApprvdBy",
                DECODE (NVL (repl_tag_flag, 'N'),
                        'Y', cpd.complaintproductid,
                        NULL
                       ) AS "ReplTagNo"
           FROM bccd_complaintproduct_details cpd,
                bccd_complaintcustomermaster ccm,
                bccd_complaintmaster cm,
                bccdmaster bm,
                division_ebs div,
                item_ebs itm,
                servicecenterservicetypemaster bcal,
                bccd_customertype_hdr cust,
                bccdmanpower bmp,
                branch_ebs br,
                bccd_complaintsanction_dtl sanc
          WHERE cpd.activestatus IN ('0')
            AND cpd.complaintid = cm.complaintmasterid
            AND cm.customerid = ccm.customerid
            AND bm.bccdcode = cpd.bccdid
            AND div.dvsn_cd_ebs = cpd.businessunitid
            AND itm.diq_pg_cd = cpd.pg_cd
            AND cpd.itm_cd = itm.itm_cd
            AND bmp.manpowerid = cpd.assignedtechician
            AND cpd.typeofcall = bcal.servicetypeid
            AND sanc.complaint_product_id(+) = cpd.complaintproductid
            AND cust.customer_type_id = ccm.customertype
            AND br.br_cd = cpd.br_cd
            AND TRUNC (cpd.closuredate_servicetechnician) BETWEEN ('01-Dec-2015'
                                                                  )
                                                              AND ('31-Dec-2015'
                                                                  )
       ORDER BY bccdcode;
