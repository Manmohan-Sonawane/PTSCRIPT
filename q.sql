explain plan for
SELECT TCLID "Tclid",
       REG_NM "Region",
       BR_NM "Branch",
       CUST_CODE "Code",
       Customer "Name",
       DVSN_NM SBU,
       tcl_sought_for "Amount",
       PendingWith "Pending With",
       TO_CHAR (tclstartdt, 'dd-mon-yyyy') "StartDate",
       TO_CHAR (tclenddt, 'dd-mon-yyyy') "Enddate",
       amname "ByAM",
       audisp "AMAction",
       TO_CHAR (TRUNC (amsancdate), 'dd-mon-yyyy') "Am Sancdate",
       bssmname "By Bssm",
       bssmdisp "Bssm Action",
       TO_CHAR (TRUNC (bssmsancdate), 'dd-mon-yyyy') "Bssm Sancdate",
       rmname "By RM",
       rmdisp "RM Action",
       rmsancdate "RM Sancdate",
       nsmname "By NSM",
       nsmdisp "NSM Action",
       TO_CHAR (TRUNC (nsmsancdate), 'dd-mon-yyyy') "NSSM Sancdate",
       buheadname "By BU Head",
       buheaddisp "BUHEAD Action",
       TO_CHAR (TRUNC (buheadsancdate), 'dd-mon-yyyy') "BUHead Sancdate",
       Commercialname "By Comm. Head",
       Commercialdisp "CommHd. Action",
       TO_CHAR (TRUNC (CommercialSancdate), 'dd-mon-yyyy') "Comm. Sancdate",
       edname "By ED",
       eddisp "ED Action",
       TO_CHAR (TRUNC (edsancdate), 'dd-mon-yyyy') "ED Sancdate"
  FROM (SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM hosys.Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM hosys.TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '08'
               AND sbu IN ('02')
        UNION
        SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '07'
               AND sbu IN ('02')
        UNION
        SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '06'
               AND sbu IN ('02')
        UNION
        SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '04'
               AND sbu IN ('02')
        UNION
        SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '02'
               AND sbu IN ('02')
        UNION
        SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '03'
               AND sbu IN ('02')
        UNION
        SELECT DISTINCT
               YYMM,
               TCLID,
               REG_NM,
               BR_NM,
               CUST_CODE,
               Customer,
               DVSN_NM,
               tcl_sought_for,
               DECODE (x.Sanc_Flag, 'PD', 'Pending', x.SANC_AMT) SancAmt,
               PendingWith,
               TCL_START_DATE tclstartdt,
               TCL_END_DATE tclenddt,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  audisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  amsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '08')
                  bssmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '07')
                  bssmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '06')
                  rmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '04')
                  nsmsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheaddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '02')
                  buheadsancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  Commercialdisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '03')
                  CommercialSancdate,
               (SELECT name
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edname,
               (SELECT au_disp
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  eddisp,
               (SELECT sanc_date
                  FROM Tclsanctiondetails
                 WHERE pid = x.tclid AND sanc_by = '01')
                  edsancdate
          FROM TCLstatus X
         WHERE     0 = 0
               AND SUBSTR (yymm, 1, 4) IN (2016)
               AND SUBSTR (yymm, 5, 2) IN (03)
               AND x.Sanc_Flag = 'UP'
               AND au_type = '01'
               AND sbu IN ('02'));
