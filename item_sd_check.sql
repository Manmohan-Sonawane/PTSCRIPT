undefine v_headerinfo
Define   v_headerinfo =  '$Header: item_sd_check.sql 1.0  13-AUG-2003 support $'
undefine v_testlongname
Define   v_testlongname = 'Item Supply/Demand Check'

REM   =========================================================================
REM   Copyright © 2002 Oracle Corporation Redwood Shores, California, USA
REM   Oracle Support Services.  All rights reserved.
REM   =========================================================================
REM   PURPOSE:           To provide support analysts with information to debug
REM                      issues with the Item Supply/Demand form (INVDVDSD)
REM   PRODUCT:           Oracle Master Scheduling/MRP (MRP) 
REM   PRODUCT VERSIONS:  11.5.10
REM   PLATFORM:          Any
REM   PARAMETERS:        Plan Name, Organization Code
REM   =========================================================================


REM   =========================================================================
REM   USAGE:             sqlplus <apps user>/<apps pw> @item_sd_check.sql
REM   EXAMPLE:           sqlplus apps/apps @item_sd_check.sql
REM   OUTPUT:            Output will display the current setups as they relate
REM                      to the Item Supply/Demand for and its output.
REM   =========================================================================


REM   =========================================================================
REM   CHANGE HISTORY:
REM     22-JAN-007   BRFOX     Created
REM     
REM   =========================================================================



REM  ================SQL PLUS Environment setup================================
set serveroutput on size 1000000
set verify off
set feedback off


REM ============== Define SQL Variables for input parameters ==================
VARIABLE    v_username     VARCHAR2(100);
VARIABLE    v_org_code     VARCHAR2(5);
VARIABLE    v_plan_name    VARCHAR2(50);

REM ============Validate SQL*Plus Version Character Set Combination============
REM =======NOTE - This section only needed for tests using HTML API's==========

DECLARE
  l_nls_characterset    nls_database_parameters.value%TYPE;
  l_sql_release_int     INTEGER(20) :=  to_number('&_SQLPLUS_RELEASE');
  l_sql_release_chr     VARCHAR2(50) := '&_SQLPLUS_RELEASE';

BEGIN

  SELECT value 
    INTO  l_nls_characterset
    FROM  nls_database_parameters
    WHERE parameter = 'NLS_CHARACTERSET';
    
  FOR i IN 1..4 LOOP
    l_sql_release_chr := substr(l_sql_release_chr,1,(2*i)-1)||'.'||
      substr(l_sql_release_chr,(2*i)+1);
  END LOOP;
  
 
  IF l_nls_characterset LIKE 'UTF%' THEN
    IF l_sql_release_int IS null THEN 
      DBMS_OUTPUT.PUT_LINE(chr(10));
      DBMS_OUTPUT.PUT_LINE('ATTENTION - Cannot determine version of SQL*plus being used for test run.');
      DBMS_OUTPUT.PUT_LINE('.           This test may fail if not run using version 8.1.X or higher of SQL*Plus.');
      DBMS_OUTPUT.PUT_LINE('Attempting to run the test.......');
      DBMS_OUTPUT.PUT_LINE(chr(10));
    ELSIF l_sql_release_int < 801000000 THEN
      DBMS_OUTPUT.PUT_LINE(chr(10));
      DBMS_OUTPUT.PUT_LINE('ERROR - Invalid SQL*plus Version '||l_sql_release_chr);
      DBMS_OUTPUT.PUT_LINE('ACTION - On databases using the '||l_nls_characterset||' NLS characterset this test should not be run using this ');
      DBMS_OUTPUT.PUT_LINE('.        SQL*Plus Version.  Please rerun this test using version 8.1.X  or higher of SQL*Plus.');
      DBMS_OUTPUT.PUT_LINE('.        Type Ctrl-C <Enter> to exit the test.');
      DBMS_OUTPUT.PUT_LINE(chr(10));
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(chr(10));
    DBMS_OUTPUT.PUT_LINE('ERROR - SQL*plus Version check error : '|| sqlerrm);
    DBMS_OUTPUT.PUT_LINE('ACTION - Please report the above error to Oracle Support Services.');
    DBMS_OUTPUT.PUT_LINE('.        Type Ctrl-C <Enter> to exit the test.');
    DBMS_OUTPUT.PUT_LINE(chr(10));
END;
/

REM ================Show responsibilities assigned to given user===============
DECLARE
  l_applversion  fnd_product_groups.release_name%TYPE;
  l_counter      INTEGER;
  l_cursor       INTEGER;
  sqltxt         VARCHAR2(3000);
  l_resp_id      INTEGER;
  l_resp_name    VARCHAR2(300);

BEGIN
  

  SELECT substr(release_name,1,4)  
    INTO l_applversion 
    FROM fnd_product_groups;
  
/*  IF l_applversion = '11.5' THEN
    sqltxt := 'select to_char(a.responsibility_id) id, '||
              '       b.responsibility_name name '||
              'from   fnd_user_resp_groups a, '||
              '       fnd_responsibility_vl b, '||
              '       fnd_user u '||
              'where  a.user_id = u.user_id '||
              'and    a.responsibility_id = b.responsibility_id '||
              'and    a.responsibility_application_id = b.application_id '||
              'and    sysdate between '||
              '          a.start_date and nvl(a.end_date,sysdate+1) '||
              'and    upper(u.user_name) = '''|| :v_username ||''''||
              'order  by b.responsibility_name';
  ELSE
     DBMS_OUTPUT.PUT_LINE(chr(10));
     DBMS_OUTPUT.PUT_LINE('ERROR  - Invalid Application Version  '|| l_applversion);
     DBMS_OUTPUT.PUT_LINE('ACTION - This test is not intended for this Application version.');
     DBMS_OUTPUT.PUT_LINE('.        Type Ctrl-C <Enter> to exit the test.');
     DBMS_OUTPUT.PUT_LINE(chr(10));
  END IF;
  DBMS_OUTPUT.PUT_LINE(chr(10));
  DBMS_OUTPUT.PUT_LINE('Responsibilities assigned to User:  '|| :v_username);
  DBMS_OUTPUT.PUT_LINE('=================================================================' || chr(10) );
  
  l_cursor := dbms_sql.open_cursor; 
  dbms_sql.parse(l_cursor, sqltxt, dbms_sql.native);
  dbms_sql.define_column(l_cursor, 1, l_resp_id);
  dbms_sql.define_column(l_cursor, 2, l_resp_name,100);
  l_counter := dbms_sql.EXECUTE(l_cursor); 
  l_counter := 0;
  WHILE dbms_sql.fetch_rows(l_cursor) > 0 LOOP
    l_counter := l_counter + 1;
    dbms_sql.column_value(l_cursor, 1, l_resp_id);
    dbms_sql.column_value(l_cursor, 2, l_resp_name);
    DBMS_OUTPUT.PUT_LINE(to_char(l_resp_id)||' ... '||l_resp_name);
  END LOOP;
  
    
  IF l_counter = 0 THEN
    RAISE no_data_found;
  END IF;
  dbms_sql.close_cursor(l_cursor);
*/

EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('ERROR  - Could not retrieve any responsibilities for this User');
    DBMS_OUTPUT.PUT_LINE('ACTION - Ensure User is valid and has at least one responsibility assigned.');
    DBMS_OUTPUT.PUT_LINE('.        Type Ctrl-C <Enter> to exit the test.  Rerun the test with a valid user name.');
    DBMS_OUTPUT.PUT_LINE(chr(10));
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('ERROR  - Responsibility error : '|| sqlerrm);
    DBMS_OUTPUT.PUT_LINE('ACTION - Please report the above error to Oracle Support Services.');
    DBMS_OUTPUT.PUT_LINE('.        Type Ctrl-C <Enter> to exit the test.');
    DBMS_OUTPUT.PUT_LINE(chr(10));
END;
/

/*
PROMPT 
undefine v_respid
accept v_respid number PROMPT  'Please choose a Responsibility ID from the list : '
PROMPT 
*/

REM ============= Accept other Input Parameters ===============================
undefine inp_item_name
ACCEPT inp_item_name PROMPT 'Enter Inventory Item Name: '
REM Define inp_item_name = &inp_item_name

undefine inp_org_code
ACCEPT inp_org_code PROMPT 'Enter Organization Code: '
REM Define inp_org_code = &inp_org_code

undefine inp_nonnet_sub
ACCEPT inp_nonnet_sub PROMPT 'Include Non-nettable Subinventories (1 - ATP Subs, 2 - Net Subs, 3 - All Subs): '
REM Define inp_nonnet_sub

undefine inp_trace
ACCEPT inp_trace PROMPT 'Are you experiencing a performance issue? (Y/N): '
REM Define inp_trace = &inp_trace

--undefine inp_po_issue
--ACCEPT inp_po_issue PROMPT 'Is this an issue with missing purchasing data? (Y/N): '
--REM Define inp_po_issue = &inp_po_issue

--undefine inp_so_issue
--ACCEPT inp_so_issue PROMPT 'Is this an issue with missing sales order data? (Y/N): '
--REM Define inp_so_issue = &inp_so_issue

--undefine inp_resv_issue
--ACCEPT inp_resv_issue PROMPT 'Is this an issue with missing reservation data? (Y/N): '
--REM Define inp_resv_issue = &inp_resv_issue



REM ============ Spooling the output file======================================
Define v_spoolfilename  = 'Item_SD_Check.txt'

PROMPT  =======================================================================
PROMPT  Output will be spooled to &v_spoolfilename
PROMPT  =======================================================================
PROMPT
PROMPT Running.....
PROMPT 
--spool  D:\Applications\Scripts\MRP\INVDVDSD\Diagnostic\&v_spoolfilename
--spool D:\TARS\7000262.994\&v_spoolfilename
spool  &v_spoolfilename


REM =================Run the Pl/SQL api file ==================================
@@CoreApiTxt.sql
BEGIN  -- begin (block 1) 

  DECLARE -- declare (block 2) 
    p_username     VARCHAR2(100);
    p_respid       NUMBER;
  -- ------------------------ Test Declare Section ---------------------- 
  BEGIN  -- begin (block 2) 
    p_username := :v_username;

    IF &v_respid IS NULL THEN
        p_respid := -10;
    ELSE
        p_respid := &v_respid;
    END IF;


   -- Set_Client(p_username,p_respid);
    Show_Header('404459.1', '&v_testlongname');

  -- -------------------- Test Execution Section ----------------------- 
     DECLARE
     -- Concurrent Manager Variables
        v_conc_queue_name         VARCHAR2(30);
        v_run_process             NUMBER;
        v_max_process             NUMBER;
        
        v_rpc_prof                NUMBER;
        v_conc_wait               NUMBER;
        v_index_count             NUMBER;
        v_apps_ver                VARCHAR2(15);
        v_trace_dir               V$PARAMETER.VALUE%TYPE; --VARCHAR2(500);
        v_gen_trace               VARCHAR2(1);
        
     -- Checking Stats
        num_rows                  NUMBER;
        sqltxt                    VARCHAR2(2000);
        disp_lengths              LENGTHS;
        col_headers               HEADERS;
    
     -- Onhand Quantity Variables
        v_nonnet_sub      NUMBER := 1;
        v_level           NUMBER := 1;
        v_subinv          VARCHAR2(20);
        l_moq_qty         NUMBER := 0;
	l_mmtt_qty_src    NUMBER := 0;
	l_mmtt_qty_dest   NUMBER := 0;
	l_qoh             NUMBER := 0;
	l_lot_control     NUMBER := 1;
        l_lpn_qty         NUMBER := 0; 
     
        group_id                  NUMBER;
        rule_id                   NUMBER;
        item_name                 VARCHAR2(150);
        item_id                   NUMBER;
        org_code                  VARCHAR2(3);
        org_id                    NUMBER;
        inf_fence                 NUMBER;
        oh_source                 NUMBER;
        sys_seq_num               NUMBER;
        reqt_date                 DATE;
        TYPE int_arr IS TABLE OF NUMBER;
        TYPE float_arr IS TABLE OF NUMBER;
        TYPE char19_arr IS TABLE OF VARCHAR2(19);
        TYPE char31_arr IS TABLE OF VARCHAR2(31);
        TYPE date_arr IS TABLE OF DATE;
     
            rsv_type      int_arr;
            src_type      int_arr;
            trx_type      int_arr;
            src_id        int_arr;
            sd_type       int_arr;
            sd_item       int_arr; -- Item ID from SQL
            sd_org        int_arr; -- Org ID from SQL
            sd_date       int_arr; -- Requirement date from SQL
            osd_date      int_arr; -- Requirement date from SQL
     
            onhand        float_arr;
            sd_qty        float_arr; -- S/D quantit from SQL
     
            sd_rowid      char19_arr; -- Unique row from ATP request
            src_name      char31_arr; -- Demand source name
            
            rollup_bug    int_arr;
            rollup_date   date_arr;
     
        CURSOR sd_rollup IS
           SELECT bug_number, creation_date
           FROM   ad_bugs
           WHERE  bug_number in ('5597626','5599699','5739238','5874516','6430320','6877183');
           
        CURSOR dmd_stmt IS
           SELECT D.RESERVATION_TYPE
           , DECODE(D.DEMAND_SOURCE_TYPE, 2, DECODE(D.RESERVATION_TYPE, 1, 2, 3, 23, 9), 8, DECODE(D.RESERVATION_TYPE, 1, 21, 22), D.DEMAND_SOURCE_TYPE)
           , DECODE(D.DEMAND_SOURCE_TYPE, 8, 2, D.DEMAND_SOURCE_TYPE), D.DEMAND_SOURCE_HEADER_ID , 1
           , -1*(D.PRIMARY_UOM_QUANTITY-GREATEST(NVL(D.RESERVATION_QUANTITY, 0), D.COMPLETED_QUANTITY))
           , TO_NUMBER(TO_CHAR(C.PRIOR_DATE, 'J')) 
           , CHARTOROWID('0') , V.INVENTORY_ITEM_ID , V.ORGANIZATION_ID 
           , DECODE(D.RESERVATION_TYPE, 2, to_number(sys_seq_num), C.PRIOR_SEQ_NUM)
           , D.DEMAND_SOURCE_NAME
           FROM 
             MTL_GROUP_ITEM_ATPS_VIEW V,
             MTL_PARAMETERS P ,
             MTL_SYSTEM_ITEMS I ,
             MTL_ATP_RULES R ,
             BOM_CALENDAR_DATES C ,
             MTL_DEMAND_OMOE D ,
             BOM_CALENDAR_DATES C1
           WHERE 
             D.OPEN_FLAG = 'Y' 
           AND D.ORGANIZATION_ID = V.ORGANIZATION_ID  
           AND D.PRIMARY_UOM_QUANTITY > GREATEST(NVL(D.RESERVATION_QUANTITY,0),D.COMPLETED_QUANTITY)  
           AND D.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  
           AND D.AVAILABLE_TO_ATP = 1  
           AND D.RESERVATION_TYPE != DECODE(NVL(V.N_COLUMN1,R.INCLUDE_ONHAND_AVAILABLE), 2, 2, -1)  
           AND D.RESERVATION_TYPE != DECODE(R.DEMAND_CLASS_ATP_FLAG, 1, 2, -1)  
           AND D.DEMAND_SOURCE_TYPE != DECODE(R.INCLUDE_SALES_ORDERS, 2, 2, -1)  
           AND D.DEMAND_SOURCE_TYPE != DECODE(R.INCLUDE_INTERNAL_ORDERS, 2, 8, -1)  
           AND (D.SUBINVENTORY IS NULL OR D.SUBINVENTORY IN 
               (SELECT S.SECONDARY_INVENTORY_NAME 
                FROM MTL_SECONDARY_INVENTORIES S 
                WHERE S.ORGANIZATION_ID=D.ORGANIZATION_ID 
                AND S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE) 
                AND S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)))   
           AND V.AVAILABLE_TO_ATP = 1  
           AND V.ATP_RULE_ID = R.RULE_ID  
           AND V.ATP_GROUP_ID = group_id  
           AND I.ORGANIZATION_ID = V.ORGANIZATION_ID  
           AND I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  
           AND NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  
           AND P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  
           AND C1.SEQ_NUM = greatest(1, sys_seq_num -R.PAST_DUE_DEMAND_CUTOFF_FENCE)  
           AND D.REQUIREMENT_DATE >= C1.CALENDAR_DATE  
           AND D.RESERVATION_TYPE != 2  
           AND R.PAST_DUE_DEMAND_CUTOFF_FENCE is not null  
           AND C.PRIOR_SEQ_NUM < DECODE(D.RESERVATION_TYPE,2,C.PRIOR_SEQ_NUM+1,NVL(sys_seq_num + (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, R.INFINITE_SUPPLY_TIME_FENCE)), C.PRIOR_SEQ_NUM+1))  
           AND P.CALENDAR_CODE = C.CALENDAR_CODE  
           AND P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  
           AND P.CALENDAR_CODE = C1.CALENDAR_CODE  
           AND P.CALENDAR_EXCEPTION_SET_ID = C1.EXCEPTION_SET_ID  
           AND C.CALENDAR_DATE = TRUNC(D.REQUIREMENT_DATE)  
           AND V.INVENTORY_ITEM_ID=DECODE(D.RESERVATION_TYPE,1,DECODE(D.PARENT_DEMAND_ID, NULL,V.INVENTORY_ITEM_ID,-1),2,V.INVENTORY_ITEM_ID,3,DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 1,V.INVENTORY_ITEM_ID,DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 1,V.INVENTORY_ITEM_ID, -1)),-1)  
           AND V.INVENTORY_ITEM_ID=DECODE(R.INCLUDE_SALES_ORDERS, 2,DECODE(R.INCLUDE_INTERNAL_ORDERS, 2,DECODE(R.INCLUDE_ONHAND_AVAILABLE, 2,DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 2,DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 2, -1,V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID);
        
        CURSOR dmd2_stmt IS
           SELECT 
               D.RESERVATION_TYPE
             , DECODE(D.DEMAND_SOURCE_TYPE, 2, DECODE(D.RESERVATION_TYPE, 1, 2, 3, DECODE(D.SUPPLY_SOURCE_TYPE, 5, 23, 31), 9), 8,   DECODE(D.RESERVATION_TYPE, 1, 21, 22), D.DEMAND_SOURCE_TYPE)
             , DECODE(D.DEMAND_SOURCE_TYPE, 8, 2, D.DEMAND_SOURCE_TYPE) 
             , D.DEMAND_SOURCE_HEADER_ID , 1 
             , -1*(D.PRIMARY_UOM_QUANTITY-GREATEST(NVL(D.RESERVATION_QUANTITY, 0), D.COMPLETED_QUANTITY)) 
             , TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) 
             , D.ROWID 
             , V.INVENTORY_ITEM_ID ,    V.ORGANIZATION_ID , DECODE(D.RESERVATION_TYPE, 2, to_number(sys_seq_num), C.PRIOR_SEQ_NUM) , D.DEMAND_SOURCE_NAME
           FROM 
             MTL_GROUP_ITEM_ATPS_VIEW V,
             MTL_PARAMETERS P ,
             MTL_SYSTEM_ITEMS I ,
             MTL_ATP_RULES R ,
             BOM_CALENDAR_DATES C ,
             MTL_DEMAND D
           WHERE 
             D.ORGANIZATION_ID = V.ORGANIZATION_ID 
           AND  D.PRIMARY_UOM_QUANTITY > GREATEST(NVL(D.RESERVATION_QUANTITY,0),D.COMPLETED_QUANTITY)  
           AND  D.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  
           AND  D.AVAILABLE_TO_ATP = 1  
           AND  D.RESERVATION_TYPE != DECODE(NVL(V.N_COLUMN1,R.INCLUDE_ONHAND_AVAILABLE), 2, 2, -1)  
           AND  D.RESERVATION_TYPE != DECODE(R.DEMAND_CLASS_ATP_FLAG, 1, 2, -1)  
           AND  D.DEMAND_SOURCE_TYPE != DECODE(R.INCLUDE_SALES_ORDERS, 2, 2, -1)  
           AND  D.DEMAND_SOURCE_TYPE != DECODE(R.INCLUDE_INTERNAL_ORDERS, 2, 8, -1)  
           AND  (D.SUBINVENTORY IS NULL OR D.SUBINVENTORY IN 
                (SELECT S.SECONDARY_INVENTORY_NAME 
                 FROM MTL_SECONDARY_INVENTORIES S 
                 WHERE S.ORGANIZATION_ID=D.ORGANIZATION_ID 
                 AND S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE) 
                 AND S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)))   
           AND  V.AVAILABLE_TO_ATP = 1  
           AND  V.ATP_RULE_ID = R.RULE_ID  
           AND  V.ATP_GROUP_ID = group_id  
           AND  I.ORGANIZATION_ID = V.ORGANIZATION_ID  
           AND  I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  
           AND  NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  
           AND  P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  
           AND  C.PRIOR_SEQ_NUM >= DECODE(D.RESERVATION_TYPE,2,C.PRIOR_SEQ_NUM,DECODE(R.PAST_DUE_DEMAND_CUTOFF_FENCE, NULL, C.PRIOR_SEQ_NUM, sys_seq_num -R.PAST_DUE_DEMAND_CUTOFF_FENCE))  
           AND  C.PRIOR_SEQ_NUM < DECODE(D.RESERVATION_TYPE,2,C.PRIOR_SEQ_NUM+1,NVL(sys_seq_num + (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, R.INFINITE_SUPPLY_TIME_FENCE)), C.PRIOR_SEQ_NUM+1))  
           AND  P.CALENDAR_CODE = C.CALENDAR_CODE  
           AND  P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  
           AND  C.CALENDAR_DATE = TRUNC(D.REQUIREMENT_DATE)  
           AND  V.INVENTORY_ITEM_ID=DECODE(D.RESERVATION_TYPE,1,DECODE(D.PARENT_DEMAND_ID, NULL,V.INVENTORY_ITEM_ID,-1),2,V.INVENTORY_ITEM_ID,3,DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 1,V.INVENTORY_ITEM_ID,DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 1,V.INVENTORY_ITEM_ID, -1)),-1)  
           AND  V.INVENTORY_ITEM_ID=DECODE(R.INCLUDE_SALES_ORDERS, 2,DECODE(R.INCLUDE_INTERNAL_ORDERS, 2,DECODE(R.INCLUDE_ONHAND_AVAILABLE, 2,DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 2,DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 2, -1,V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID);
        
        CURSOR DMD3_stmt IS
        SELECT D.RESERVATION_TYPE, DECODE(D.DEMAND_SOURCE_TYPE,2,
          DECODE(D.RESERVATION_TYPE,1,2,3,23,9),8,DECODE(D.RESERVATION_TYPE,1,21,22),
          D.DEMAND_SOURCE_TYPE) , DECODE(D.DEMAND_SOURCE_TYPE,8,2,
          D.DEMAND_SOURCE_TYPE) , D.DEMAND_SOURCE_HEADER_ID , 1 , 
          -1*(D.PRIMARY_UOM_QUANTITY-D.TOTAL_RESERVATION_QUANTITY-D.COMPLETED_QUANTITY) , TO_NUMBER(TO_CHAR(  decode(nvl(D.mfg_lead_time,0),         0, 
          C.PRIOR_DATE,        decode(I.BOM_Item_Type,               1, C.PRIOR_DATE, 
                        MRP_CALENDAR.DATE_OFFSET (                 D.ORGANIZATION_ID, 
                           1,                  C.PRIOR_DATE,                  
          -1*(D.mfg_lead_time))))              , 'J'))  , CHARTOROWID('0') , 
          V.INVENTORY_ITEM_ID , V.ORGANIZATION_ID , DECODE(D.RESERVATION_TYPE, 2, 
          to_number(sys_seq_num), C.PRIOR_SEQ_NUM) , D.DEMAND_SOURCE_NAME  
        FROM
         MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_SYSTEM_ITEMS I , 
          MTL_ATP_RULES R , BOM_CALENDAR_DATES C , MRP_DEMAND_OM_RESERVATIONS_V D  
          WHERE D.OPEN_FLAG = 'Y' AND D.RESERVATION_TYPE != 2  AND 
          R.PAST_DUE_DEMAND_CUTOFF_FENCE is null  AND D.ORGANIZATION_ID = 
          V.ORGANIZATION_ID  AND D.PRIMARY_UOM_QUANTITY > 
          (D.TOTAL_RESERVATION_QUANTITY+D.COMPLETED_QUANTITY)  AND 
          D.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND  (D.visible_demand_flag = 
          'Y'  OR  (NVL(D.visible_demand_flag,'N')='N'  AND D.ATO_Line_id IS NOT NULL 
           AND NOT EXISTS  (SELECT NULL   FROM    OE_Order_Lines_all ool,    
          mtl_demand md   WHERE    TO_CHAR(ool.line_id)=md.DEMAND_SOURCE_LINE    AND 
          ool.ATO_Line_id = D.ATO_Line_id    AND ool.Item_Type_Code = 'CONFIG'    AND 
          md.reservation_type IN (2,3))))   AND D.RESERVATION_TYPE != 
          DECODE(NVL(V.N_COLUMN1,R.INCLUDE_ONHAND_AVAILABLE), 2, 2, -1)  AND 
          D.RESERVATION_TYPE != DECODE(R.DEMAND_CLASS_ATP_FLAG, 1, 2, -1)  AND 
          D.DEMAND_SOURCE_TYPE != DECODE(R.INCLUDE_SALES_ORDERS, 2, 2, -1)  AND 
          D.DEMAND_SOURCE_TYPE != DECODE(R.INCLUDE_INTERNAL_ORDERS, 2, 8, -1)  AND  
          exists( SELECT null FROM MTL_SECONDARY_INVENTORIES S WHERE 
          S.ORGANIZATION_ID=D.ORGANIZATION_ID AND S.INVENTORY_ATP_CODE = 
          DECODE(R.DEFAULT_ATP_SOURCES,1, 1,NULL, 1, S.INVENTORY_ATP_CODE) AND 
          S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2,1,S.AVAILABILITY_TYPE) 
          AND S.SECONDARY_INVENTORY_NAME = D.SUBINVENTORY UNION ALL SELECT NULL FROM 
          DUAL where D.SUBINVENTORY IS NULL)   AND V.AVAILABLE_TO_ATP = 1  AND 
          V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = group_id  AND 
          I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND I.INVENTORY_ITEM_ID = 
          V.INVENTORY_ITEM_ID  AND NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,
          '@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,
          NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(D.DEMAND_CLASS, 
          NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  AND P.ORGANIZATION_ID = 
          NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND C.PRIOR_SEQ_NUM 
          >= DECODE(D.RESERVATION_TYPE,2,C.PRIOR_SEQ_NUM,
          DECODE(R.PAST_DUE_DEMAND_CUTOFF_FENCE, NULL, C.PRIOR_SEQ_NUM, sys_seq_num 
          -R.PAST_DUE_DEMAND_CUTOFF_FENCE))  AND C.PRIOR_SEQ_NUM < 
          DECODE(D.RESERVATION_TYPE,2,C.PRIOR_SEQ_NUM+1,NVL(sys_seq_num + 
          (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, 
          I.CUM_MANUFACTURING_LEAD_TIME,3, 
          I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, 
          R.INFINITE_SUPPLY_TIME_FENCE)), C.PRIOR_SEQ_NUM+1))  AND P.CALENDAR_CODE = 
          C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND 
          C.CALENDAR_DATE = TRUNC(D.REQUIREMENT_DATE)  AND V.INVENTORY_ITEM_ID=
          DECODE(D.RESERVATION_TYPE,1,DECODE(D.PARENT_DEMAND_ID, NULL,
          V.INVENTORY_ITEM_ID,-1),2,V.INVENTORY_ITEM_ID,3,
          DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 1,V.INVENTORY_ITEM_ID,
          DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 1,V.INVENTORY_ITEM_ID, -1)),-1)  AND 
          V.INVENTORY_ITEM_ID=DECODE(R.INCLUDE_SALES_ORDERS, 2,
          DECODE(R.INCLUDE_INTERNAL_ORDERS, 2,DECODE(R.INCLUDE_ONHAND_AVAILABLE, 2,
          DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 2,
          DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 2, -1,V.INVENTORY_ITEM_ID),
          V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),V.INVENTORY_ITEM_ID),
          V.INVENTORY_ITEM_ID) ;
     
        CURSOR ddj_stmt IS
          SELECT 1, DECODE(D.JOB_TYPE, 1, 5, 7) , 5 , D.WIP_ENTITY_ID , 1 , 
	    LEAST(-1*(O.REQUIRED_QUANTITY-O.QUANTITY_ISSUED),0) , 
	    TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) , O.ROWID , V.INVENTORY_ITEM_ID , 
	    V.ORGANIZATION_ID , C.PRIOR_SEQ_NUM , NULL  
	  FROM
	   MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_ATP_RULES R , 
	    MTL_SYSTEM_ITEMS I , BOM_CALENDAR_DATES C , WIP_REQUIREMENT_OPERATIONS O , 
	    WIP_DISCRETE_JOBS D , BOM_CALENDAR_DATES C1  WHERE 
	    R.PAST_DUE_DEMAND_CUTOFF_FENCE is not null AND O.ORGANIZATION_ID=
	    D.ORGANIZATION_ID  AND O.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID  AND 
	    O.WIP_ENTITY_ID=D.WIP_ENTITY_ID  AND O.ORGANIZATION_ID = V.ORGANIZATION_ID  
	    AND O.WIP_SUPPLY_TYPE NOT IN (5, 6)  AND O.REQUIRED_QUANTITY > 0  AND 
	    O.REQUIRED_QUANTITY <> (O.QUANTITY_ISSUED)  AND O.OPERATION_SEQ_NUM > 0  
	    AND O.DATE_REQUIRED >= c1.calendar_date  AND (O.SUPPLY_SUBINVENTORY IS NULL 
	    OR EXISTS (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S WHERE 
	    S.ORGANIZATION_ID=O.ORGANIZATION_ID AND O.SUPPLY_SUBINVENTORY=
	    S.SECONDARY_INVENTORY_NAME AND S.INVENTORY_ATP_CODE =
	    DECODE(R.DEFAULT_ATP_SOURCES,1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND 
	    S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, 
	    S.AVAILABILITY_TYPE)))   AND D.STATUS_TYPE IN (1,3,4,6)  AND 
	    D.ORGANIZATION_ID=V.ORGANIZATION_ID  AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND 
	    V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = 
	    group_id  AND I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND 
	    I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND C1.SEQ_NUM = greatest(1,
	    sys_seq_num-R.PAST_DUE_DEMAND_CUTOFF_FENCE)  AND P.CALENDAR_CODE = 
	    C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND 
	    P.CALENDAR_CODE = C1.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = 
	    C1.EXCEPTION_SET_ID  AND C.CALENDAR_DATE = TRUNC(O.DATE_REQUIRED); 


           
        CURSOR ddj2_stmt IS
          SELECT /*+ index (C bom_calendar_dates_U1) index (O 
	    wip_requirement_operations_n3) */ 1, DECODE(D.JOB_TYPE, 1, 5, 7) , 5 , 
	    D.WIP_ENTITY_ID , 1 , LEAST(-1*(O.REQUIRED_QUANTITY-O.QUANTITY_ISSUED),0) , 
	    TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) , O.ROWID , V.INVENTORY_ITEM_ID , 
	    V.ORGANIZATION_ID , C.PRIOR_SEQ_NUM , NULL  
	  FROM
	   MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_ATP_RULES R , 
	    MTL_SYSTEM_ITEMS I , BOM_CALENDAR_DATES C , WIP_REQUIREMENT_OPERATIONS O , 
	    WIP_DISCRETE_JOBS D  WHERE R.PAST_DUE_DEMAND_CUTOFF_FENCE is null AND 
	    O.ORGANIZATION_ID=D.ORGANIZATION_ID  AND O.ORGANIZATION_ID = 
	    I.ORGANIZATION_ID  AND O.INVENTORY_ITEM_ID=I.INVENTORY_ITEM_ID  AND 
	    O.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID  AND O.WIP_ENTITY_ID=
	    D.WIP_ENTITY_ID  AND O.WIP_SUPPLY_TYPE NOT IN (5,6)  AND 
	    O.REQUIRED_QUANTITY > 0  AND O.REQUIRED_QUANTITY <> (O.QUANTITY_ISSUED)  
	    AND O.OPERATION_SEQ_NUM > 0  AND O.DATE_REQUIRED IS NOT NULL  AND 
	    (O.SUPPLY_SUBINVENTORY IS NULL OR EXISTS (SELECT 'X' FROM 
	    MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=O.ORGANIZATION_ID AND 
	    O.SUPPLY_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME AND S.INVENTORY_ATP_CODE =
	    DECODE(R.DEFAULT_ATP_SOURCES,1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND 
	    S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, 
	    S.AVAILABILITY_TYPE)))   AND D.STATUS_TYPE IN (1,3,4,6)  AND 
	    D.ORGANIZATION_ID=V.ORGANIZATION_ID  AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND 
	    V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = 
	    group_id  AND I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND 
	    I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND P.CALENDAR_CODE = 
	    C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND 
	    C.CALENDAR_DATE = TRUNC(O.DATE_REQUIRED) ;
	    

        
        CURSOR DRJ_stmt IS
        SELECT /*+ index (C bom_calendar_dates_n3) 
                   index (WRO WIP_REQUIREMENT_OPERATIONS_n3)*/ 
          1, 4 , 5 , WRS.WIP_ENTITY_ID , 
          1 , DECODE(SIGN(WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY*
          (C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM)-WRO.QUANTITY_ISSUED - 
          NVL(WRO.QUANTITY_ALLOCATED, 0)),-1,
          -1*(WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY*
              LEAST(C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM+1,
              WRS.PROCESSING_WORK_DAYS)-WRO.QUANTITY_ISSUED - 
          NVL(WRO.QUANTITY_ALLOCATED, 0)),
          GREATEST(C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM-WRS.PROCESSING_WORK_DAYS,-1)
          *WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY) , 
          TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) , WRS.ROWID , V.INVENTORY_ITEM_ID , 
          V.ORGANIZATION_ID , C.PRIOR_SEQ_NUM , NULL  
        FROM
         MTL_GROUP_ITEM_ATPS_VIEW V, MTL_ATP_RULES R , WIP_REQUIREMENT_OPERATIONS WRO 
          , WIP_REPETITIVE_SCHEDULES WRS , WIP_OPERATIONS WO , MTL_SYSTEM_ITEMS I , 
          MTL_PARAMETERS P , BOM_CALENDAR_DATES C1 , BOM_CALENDAR_DATES C  WHERE 
          WRO.ORGANIZATION_ID = V.ORGANIZATION_ID AND WRO.INVENTORY_ITEM_ID=
          V.INVENTORY_ITEM_ID  AND R.INCLUDE_REP_WIP_DEMAND <> 2  AND 
          WO.ORGANIZATION_ID = WRO.ORGANIZATION_ID  AND WRS.ORGANIZATION_ID = 
          WRO.ORGANIZATION_ID  AND WRO.WIP_SUPPLY_TYPE != 6  AND 
          WRO.REQUIRED_QUANTITY > 0  AND WRO.OPERATION_SEQ_NUM > 0  AND 
          WRO.OPERATION_SEQ_NUM = WO.OPERATION_SEQ_NUM  
          AND WRO.REPETITIVE_SCHEDULE_ID  > 0 -- ** NEW Condition **
          AND WRO.REPETITIVE_SCHEDULE_ID = WO.REPETITIVE_SCHEDULE_ID  AND 
          WRO.REPETITIVE_SCHEDULE_ID = WRS.REPETITIVE_SCHEDULE_ID  AND 
          WRS.WIP_ENTITY_ID = WRO.WIP_ENTITY_ID  AND WO.WIP_ENTITY_ID = 
          WRS.WIP_ENTITY_ID  AND (WRO.SUPPLY_SUBINVENTORY IS NULL 
          OR EXISTS (SELECT 'X' 
          FROM MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=
          WRO.ORGANIZATION_ID AND WRO.SUPPLY_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME 
          AND S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, 
          S.INVENTORY_ATP_CODE) AND S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES,
           2, 1, S.AVAILABILITY_TYPE)))   AND P.ORGANIZATION_ID = 
          NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND C1.CALENDAR_CODE=
          P.CALENDAR_CODE  AND C1.EXCEPTION_SET_ID=P.CALENDAR_EXCEPTION_SET_ID  AND 
          C1.CALENDAR_DATE=TRUNC(WO.FIRST_UNIT_START_DATE)  AND WRS.STATUS_TYPE IN (1,
          3,4,6)  AND C.CALENDAR_CODE=P.CALENDAR_CODE  AND C.EXCEPTION_SET_ID=
          P.CALENDAR_EXCEPTION_SET_ID  AND C.SEQ_NUM BETWEEN C1.PRIOR_SEQ_NUM AND 
          C1.PRIOR_SEQ_NUM + CEIL(WRS.PROCESSING_WORK_DAYS - 1)  AND 
          WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY*LEAST(C.PRIOR_SEQ_NUM-
          C1.PRIOR_SEQ_NUM+1,WRS.PROCESSING_WORK_DAYS)>(WRO.QUANTITY_ISSUED + 
          NVL(WRO.QUANTITY_ALLOCATED, 0))  AND V.AVAILABLE_TO_ATP = 1  AND 
          V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = group_id  AND 
          I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND I.INVENTORY_ITEM_ID = 
          V.INVENTORY_ITEM_ID ;
     
        CURSOR drj2_stmt IS
        SELECT 
          /*+ index (C bom_calendar_dates_n3) index(wro wip_requirement_operations_n3) */ 1,
          4 ,
          5 ,
          WRS.WIP_ENTITY_ID ,
          1 ,
          DECODE(SIGN(WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY*(C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM)-WRO.QUANTITY_ISSUED - NVL(WRO.QUANTITY_ALLOCATED,
          0)),
          -1,
          -1*(WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY*LEAST(C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM+1,
          WRS.PROCESSING_WORK_DAYS)-WRO.QUANTITY_ISSUED - NVL(WRO.QUANTITY_ALLOCATED,
          0)),
          GREATEST(C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM-WRS.PROCESSING_WORK_DAYS,
          -1)*WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY) ,
          TO_NUMBER(TO_CHAR(C.PRIOR_DATE,
          'J')) ,
          WRS.ROWID ,
          V.INVENTORY_ITEM_ID ,
          V.ORGANIZATION_ID ,
          C.PRIOR_SEQ_NUM ,
          NULL
        FROM 
          MTL_GROUP_ITEM_ATPS_VIEW V,
          MTL_PARAMETERS P ,
          MTL_ATP_RULES R ,
          MTL_SYSTEM_ITEMS I ,
          BOM_CALENDAR_DATES C ,
          BOM_CALENDAR_DATES C1 ,
          WIP_REPETITIVE_SCHEDULES WRS ,
          WIP_REQUIREMENT_OPERATIONS WRO
        WHERE 
          WRO.ORGANIZATION_ID = V.ORGANIZATION_ID AND
          WRO.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID  AND
          R.INCLUDE_REP_WIP_DEMAND <> 2  AND
          WRS.ORGANIZATION_ID = WRO.ORGANIZATION_ID  AND
          WRO.DEPARTMENT_ID IS NULL  AND
          WRO.WIP_SUPPLY_TYPE NOT IN (5,6)  AND
          WRO.REQUIRED_QUANTITY > 0  AND
          WRO.OPERATION_SEQ_NUM = 1  AND
          WRS.REPETITIVE_SCHEDULE_ID > 0  AND
          WRO.REPETITIVE_SCHEDULE_ID = WRS.REPETITIVE_SCHEDULE_ID  AND
          WRS.WIP_ENTITY_ID = WRO.WIP_ENTITY_ID  AND
          (WRO.SUPPLY_SUBINVENTORY IS NULL OR EXISTS (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=WRO.ORGANIZATION_ID AND
          WRO.SUPPLY_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME AND
          S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND
          S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2,1, S.AVAILABILITY_TYPE)))   AND
          P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND
          C1.CALENDAR_CODE=P.CALENDAR_CODE  AND
          C1.EXCEPTION_SET_ID=P.CALENDAR_EXCEPTION_SET_ID  AND
          C1.CALENDAR_DATE=TRUNC(WRS.FIRST_UNIT_START_DATE)  AND
          WRS.STATUS_TYPE IN (1,3,4,6)  AND
          C.CALENDAR_CODE=P.CALENDAR_CODE  AND
          C.EXCEPTION_SET_ID=P.CALENDAR_EXCEPTION_SET_ID  AND
          C.SEQ_NUM BETWEEN C1.PRIOR_SEQ_NUM AND
          C1.PRIOR_SEQ_NUM + CEIL(WRS.PROCESSING_WORK_DAYS - 1)  AND
          WRS.DAILY_PRODUCTION_RATE*WRO.QUANTITY_PER_ASSEMBLY*LEAST(C.PRIOR_SEQ_NUM-C1.PRIOR_SEQ_NUM+1,WRS.PROCESSING_WORK_DAYS)> (WRO.QUANTITY_ISSUED + NVL(WRO.QUANTITY_ALLOCATED, 0))  AND
          V.AVAILABLE_TO_ATP = 1  AND
          V.ATP_RULE_ID = R.RULE_ID  AND
          V.ATP_GROUP_ID = group_id  AND
          I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
          I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID;
       
          CURSOR dud_stmt IS
             SELECT 
     	  1,
     	  17 ,
     	  U.SOURCE_TYPE_ID ,
     	  U.SOURCE_ID ,
     	  1 ,
     	  -1*U.PRIMARY_UOM_QUANTITY ,
     	  TO_NUMBER(TO_CHAR(C.PRIOR_DATE,
     	  'J')) ,
     	  CHARTOROWID('0') ,
     	  V.INVENTORY_ITEM_ID ,
     	  V.ORGANIZATION_ID ,
     	  C.PRIOR_SEQ_NUM ,
     	  U.SOURCE_NAME
     	FROM 
     	  MTL_GROUP_ITEM_ATPS_VIEW V,
     	  MTL_PARAMETERS P ,
     	  MTL_ATP_RULES R ,
     	  MTL_SYSTEM_ITEMS I ,
     	  MTL_USER_DEMAND U ,
     	  BOM_CALENDAR_DATES C
     	WHERE 
     	  U.ORGANIZATION_ID = V.ORGANIZATION_ID AND
     	  U.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
     	  V.AVAILABLE_TO_ATP = 1  AND
     	  V.ATP_RULE_ID = R.RULE_ID  AND
     	  V.INVENTORY_ITEM_ID = DECODE(R.INCLUDE_USER_DEFINED_DEMAND, 2, -1, V.INVENTORY_ITEM_ID)  AND
     	  V.ATP_GROUP_ID = group_id  AND
     	  I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
     	  I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
     	  NVL(U.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(U.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  AND
     	  P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND
     	  C.PRIOR_SEQ_NUM >= DECODE(R.PAST_DUE_DEMAND_CUTOFF_FENCE, NULL, C.PRIOR_SEQ_NUM, sys_seq_num-R.PAST_DUE_DEMAND_CUTOFF_FENCE)  AND
     	  C.PRIOR_SEQ_NUM < NVL(sys_seq_num + (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, R.INFINITE_SUPPLY_TIME_FENCE)), C.PRIOR_SEQ_NUM+1)  AND
     	  P.CALENDAR_CODE = C.CALENDAR_CODE  AND
     	  P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND
               C.CALENDAR_DATE = TRUNC(U.REQUIREMENT_DATE);
               
        CURSOR soh1_stmt IS
           SELECT 
             1,
             8 ,
             0 ,
             0 ,
             2 ,
             SUM(Q.PRIMARY_TRANSACTION_QUANTITY) ,
             TO_NUMBER(TO_CHAR(C.NEXT_DATE,
             'J')) ,
             CHARTOROWID('0') ,
             V.INVENTORY_ITEM_ID ,
             V.ORGANIZATION_ID ,
             C.NEXT_SEQ_NUM ,
             NULL
           FROM 
             MTL_SECONDARY_INVENTORIES S,
             BOM_CALENDAR_DATES C ,
             MTL_PARAMETERS P ,
             MTL_ONHAND_QUANTITIES_DETAIL Q ,
             MTL_ATP_RULES R ,
             MTL_SYSTEM_ITEMS I ,
             MTL_GROUP_ITEM_ATPS_VIEW V
           WHERE 
             I.ORGANIZATION_ID = V.ORGANIZATION_ID AND
             I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             Q.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
             Q.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             S.SECONDARY_INVENTORY_NAME = Q.SUBINVENTORY_CODE  AND
             S.ORGANIZATION_ID = Q.ORGANIZATION_ID  AND
             S.INVENTORY_ATP_CODE = DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE)  AND
             S.AVAILABILITY_TYPE = DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)  AND
             V.AVAILABLE_TO_ATP = 1  AND
             V.ATP_RULE_ID = R.RULE_ID  AND
             V.INVENTORY_ITEM_ID = DECODE(R.INCLUDE_ONHAND_AVAILABLE, 2, -1, V.INVENTORY_ITEM_ID)  AND
             V.ATP_GROUP_ID = group_id  AND
             R.DEMAND_CLASS_ATP_FLAG=2  AND
             P.CALENDAR_CODE = C.CALENDAR_CODE  AND
             P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND
             C.CALENDAR_DATE = TRUNC(SYSDATE)  AND
             P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)
           GROUP BY V.INVENTORY_ITEM_ID, V.ORGANIZATION_ID, C.NEXT_DATE, C.NEXT_SEQ_NUM;
           
        CURSOR soh2_stmt IS
           SELECT 
             1,
             8 ,
             0 ,
             0 ,
             2 ,
             SUM(decode(transaction_status,
             2,
             -1,
             sign(T.PRIMARY_QUANTITY)) * T.PRIMARY_QUANTITY) ,
             TO_NUMBER(TO_CHAR(C.NEXT_DATE,
             'J')) ,
             CHARTOROWID('0') ,
             V.INVENTORY_ITEM_ID ,
             V.ORGANIZATION_ID ,
             C.NEXT_SEQ_NUM ,
             NULL
           FROM 
             MTL_SECONDARY_INVENTORIES S,
             BOM_CALENDAR_DATES C ,
             MTL_PARAMETERS P ,
             MTL_MATERIAL_TRANSACTIONS_TEMP T ,
             MTL_SYSTEM_ITEMS I ,
             MTL_ATP_RULES R ,
             MTL_GROUP_ITEM_ATPS_VIEW V
           WHERE 
             I.ORGANIZATION_ID = V.ORGANIZATION_ID AND
             I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             T.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
             T.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             T.POSTING_FLAG = 'Y'  AND
             S.SECONDARY_INVENTORY_NAME = T.SUBINVENTORY_CODE  AND
             S.ORGANIZATION_ID = T.ORGANIZATION_ID  AND
             S.INVENTORY_ATP_CODE = DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE)  AND
             S.AVAILABILITY_TYPE = DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)  AND
             V.AVAILABLE_TO_ATP = 1  AND
             V.ATP_RULE_ID = R.RULE_ID  AND
             V.INVENTORY_ITEM_ID = DECODE(R.INCLUDE_ONHAND_AVAILABLE, 2, -1, V.INVENTORY_ITEM_ID)  AND
             V.ATP_GROUP_ID = group_id  AND
             R.DEMAND_CLASS_ATP_FLAG=2  AND
             P.CALENDAR_CODE = C.CALENDAR_CODE  AND
             P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND
             C.CALENDAR_DATE = TRUNC(SYSDATE)  AND
             P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)
           GROUP BY V.INVENTORY_ITEM_ID, V.ORGANIZATION_ID, C.NEXT_DATE, C.NEXT_SEQ_NUM;
           
        CURSOR spoin_stmt IS
          SELECT 1, DECODE(S.PO_HEADER_ID,NULL,DECODE(S.SUPPLY_TYPE_CODE,'REQ',
	    DECODE(S.FROM_ORGANIZATION_ID,NULL,18,20),12),DECODE(S.SUPPLY_TYPE_CODE, 
	    'SHIPMENT', 35, 'RECEIVING', 36, 1)) , DECODE(S.PO_HEADER_ID,NULL,
	    DECODE(S.SUPPLY_TYPE_CODE,'REQ',10, 8),1) , DECODE(S.PO_HEADER_ID,NULL,
	    DECODE(S.SUPPLY_TYPE_CODE,'REQ',REQ_HEADER_ID,SHIPMENT_HEADER_ID),
	    PO_HEADER_ID) , 2 , DECODE(S.SUPPLY_TYPE_CODE, 'SHIPMENT', 
	    S.TO_ORG_PRIMARY_QUANTITY,DECODE(NVL(V.N_COLUMN1,R.INCLUDE_DISCRETE_MPS), 1,
	    NVL(S.MRP_PRIMARY_QUANTITY, 0),S.TO_ORG_PRIMARY_QUANTITY)) , 
	    TO_NUMBER(TO_CHAR(C.NEXT_DATE,'J')) , S.ROWID , V.INVENTORY_ITEM_ID , 
	    V.ORGANIZATION_ID , C.NEXT_SEQ_NUM , NULL  
	  FROM
	   MTL_GROUP_ITEM_ATPS_VIEW V, MTL_ATP_RULES R , MTL_SYSTEM_ITEMS I , 
	    MTL_PARAMETERS P , BOM_CALENDAR_DATES C , MTL_SUPPLY S  WHERE 
	    V.ATP_GROUP_ID = group_id AND R.DEMAND_CLASS_ATP_FLAG=2  AND 
	    V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = R.RULE_ID  AND 
	    ((R.INCLUDE_INTERORG_TRANSFERS = 1 AND S.REQ_HEADER_ID IS NULL AND 
	    S.PO_HEADER_ID IS NULL) OR (S.REQ_HEADER_ID=DECODE(R.INCLUDE_INTERNAL_REQS,
	    1,S.REQ_HEADER_ID) AND S.FROM_ORGANIZATION_ID IS NOT NULL) OR 
	    (S.SUPPLY_TYPE_CODE=DECODE(R.INCLUDE_VENDOR_REQS,1,'REQ') AND 
	    S.FROM_ORGANIZATION_ID IS NULL) OR S.PO_HEADER_ID=
	    DECODE(R.INCLUDE_PURCHASE_ORDERS,1, S.PO_HEADER_ID))  AND 
	    S.TO_ORGANIZATION_ID=V.ORGANIZATION_ID  AND S.ITEM_ID = V.INVENTORY_ITEM_ID 
	     AND S.DESTINATION_TYPE_CODE='INVENTORY'  AND (S.TO_SUBINVENTORY IS NULL OR 
	    EXISTS (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S2 WHERE 
	    S2.ORGANIZATION_ID=S.TO_ORGANIZATION_ID AND S.TO_SUBINVENTORY=
	    S2.SECONDARY_INVENTORY_NAME AND S2.INVENTORY_ATP_CODE =
	    DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S2.INVENTORY_ATP_CODE) AND 
	    S2.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, 
	    S2.AVAILABILITY_TYPE)))   AND I.ORGANIZATION_ID= V.ORGANIZATION_ID  AND 
	    I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND C.NEXT_SEQ_NUM >=
	     DECODE(R.PAST_DUE_SUPPLY_CUTOFF_FENCE, NULL, C.NEXT_SEQ_NUM, 
	    sys_seq_num-R.PAST_DUE_SUPPLY_CUTOFF_FENCE)  AND C.NEXT_SEQ_NUM < 
	    NVL(sys_seq_num + (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, 
	    I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, 
	    I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, 
	    R.INFINITE_SUPPLY_TIME_FENCE)), C.NEXT_SEQ_NUM+1)  AND P.CALENDAR_CODE = 
	    C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND 
	    Not exists (SELECT 'X' FROM OE_DROP_SHIP_SOURCES ODSS WHERE 
	    DECODE(S.PO_HEADER_ID,NULL,S.REQ_LINE_ID,S.PO_LINE_LOCATION_ID) = 
	    DECODE(S.PO_HEADER_ID,NULL,ODSS.REQUISITION_LINE_ID,ODSS.LINE_LOCATION_ID)) 
	     AND C.CALENDAR_DATE = TRUNC(S.EXPECTED_DELIVERY_DATE) ;


             
        CURSOR sud_stmt IS
           SELECT 
             1,
             16 ,
             U.SOURCE_TYPE_ID ,
             U.SOURCE_ID ,
             2 ,
             U.PRIMARY_UOM_QUANTITY ,
             TO_NUMBER(TO_CHAR(C.NEXT_DATE,
             'J')) ,
             CHARTOROWID('0') ,
             V.INVENTORY_ITEM_ID ,
             V.ORGANIZATION_ID ,
             C.NEXT_SEQ_NUM ,
             U.SOURCE_NAME
           FROM 
             BOM_CALENDAR_DATES C,
             MTL_USER_SUPPLY U ,
             MTL_SYSTEM_ITEMS I ,
             MTL_PARAMETERS P ,
             MTL_ATP_RULES R ,
             MTL_GROUP_ITEM_ATPS_VIEW V
           WHERE 
             U.ORGANIZATION_ID = V.ORGANIZATION_ID AND
             U.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             V.AVAILABLE_TO_ATP = 1  AND
             V.ATP_RULE_ID = R.RULE_ID  AND
             V.INVENTORY_ITEM_ID = DECODE(R.INCLUDE_USER_DEFINED_SUPPLY, 2, -1, V.INVENTORY_ITEM_ID)  AND
             V.ATP_GROUP_ID = group_id  AND
             I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
             I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             NVL(U.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(U.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  AND
             P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND
             C.NEXT_SEQ_NUM >= DECODE(R.PAST_DUE_SUPPLY_CUTOFF_FENCE, NULL, C.NEXT_SEQ_NUM, sys_seq_num-R.PAST_DUE_SUPPLY_CUTOFF_FENCE)  AND
             C.NEXT_SEQ_NUM < NVL(sys_seq_num +(DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, R.INFINITE_SUPPLY_TIME_FENCE)), C.NEXT_SEQ_NUM+1)  AND
             P.CALENDAR_CODE = C.CALENDAR_CODE  AND
             P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND
             C.CALENDAR_DATE = TRUNC(U.EXPECTED_DELIVERY_DATE);
          
        CURSOR smps_stmt IS
           SELECT 
             /*+ index (C bom_calendar_dates_U1) */ 1,
             DECODE(I.REPETITIVE_PLANNING_FLAG,
             'Y',
             14,
             13) ,
             30 ,
             D2.MPS_TRANSACTION_ID ,
             2 ,
             DECODE(I.REPETITIVE_PLANNING_FLAG,
             'Y',
             D2.REPETITIVE_DAILY_RATE,
             D2.SCHEDULE_QUANTITY) ,
             TO_NUMBER(TO_CHAR(C.NEXT_DATE,
             'J')) ,
             D2.ROWID ,
             V.INVENTORY_ITEM_ID ,
             V.ORGANIZATION_ID ,
             C.NEXT_SEQ_NUM ,
             NULL
           FROM 
             MTL_GROUP_ITEM_ATPS_VIEW V,
             MTL_ATP_RULES R ,
             MTL_SYSTEM_ITEMS I ,
             MTL_PARAMETERS P ,
             BOM_CALENDAR_DATES C ,
             MRP_SCHEDULE_DESIGNATORS D1 ,
             MRP_SCHEDULE_DATES D2
           WHERE 
             DECODE(I.REPETITIVE_PLANNING_FLAG, 'Y', D2.REPETITIVE_DAILY_RATE, D2.SCHEDULE_QUANTITY) > 0 AND
             D1.INVENTORY_ATP_FLAG=1  AND
             D1.SCHEDULE_TYPE=2  AND
             D2.SUPPLY_DEMAND_TYPE=2  AND
             D2.SCHEDULE_DESIGNATOR=D1.SCHEDULE_DESIGNATOR  AND
             DECODE(NVL(D1.ORGANIZATION_SELECTION,1),1,D1.ORGANIZATION_ID,V.ORGANIZATION_ID)= V.ORGANIZATION_ID  AND
             D2.SCHEDULE_LEVEL=2  AND
             D2.ORGANIZATION_ID=V.ORGANIZATION_ID  AND
             D2.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID  AND
             ((I.REPETITIVE_PLANNING_FLAG = 'Y' AND
             R.INCLUDE_REP_MPS = 1) OR (I.REPETITIVE_PLANNING_FLAG = 'N' AND
             R.INCLUDE_DISCRETE_MPS = 1))   AND
             C.CALENDAR_CODE=P.CALENDAR_CODE  AND
             C.EXCEPTION_SET_ID=P.CALENDAR_EXCEPTION_SET_ID  AND
             C.CALENDAR_DATE BETWEEN D2.SCHEDULE_DATE AND
             NVL(D2.RATE_END_DATE, D2.SCHEDULE_DATE)  AND
             C.SEQ_NUM IS NOT NULL  AND
             I.ORGANIZATION_ID=V.ORGANIZATION_ID  AND
             I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             NVL(D1.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(D1.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  AND
             P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND
             V.AVAILABLE_TO_ATP = 1  AND
             V.ATP_RULE_ID = R.RULE_ID  AND
             V.ATP_GROUP_ID = group_id  AND
             C.NEXT_SEQ_NUM >= DECODE(R.PAST_DUE_SUPPLY_CUTOFF_FENCE, NULL, C.NEXT_SEQ_NUM, sys_seq_num-R.PAST_DUE_SUPPLY_CUTOFF_FENCE)  AND
             C.NEXT_SEQ_NUM < NVL(sys_seq_num + (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, R.INFINITE_SUPPLY_TIME_FENCE)), C.NEXT_SEQ_NUM+1);
             
        CURSOR sdj_stmt IS
          SELECT 1, DECODE(D.JOB_TYPE, 1, 5, 7) , 5 , D.WIP_ENTITY_ID , 2 , 
	    (DECODE(NVL(V.N_COLUMN1,R.INCLUDE_DISCRETE_MPS),1, DECODE(D.JOB_TYPE,1, 
	    DECODE(I.MRP_PLANNING_CODE,4, NVL(D.MPS_NET_QUANTITY,0),D.START_QUANTITY), 
	    D.START_QUANTITY),D.START_QUANTITY) 	- D.QUANTITY_COMPLETED - 
	    D.QUANTITY_SCRAPPED) , TO_NUMBER(TO_CHAR(C.NEXT_DATE,'J')) , D.ROWID , 
	    V.INVENTORY_ITEM_ID , V.ORGANIZATION_ID , C.NEXT_SEQ_NUM , NULL  
	  FROM
	   WIP_DISCRETE_JOBS D, BOM_CALENDAR_DATES C , MTL_PARAMETERS P , 
	    MTL_SYSTEM_ITEMS I , MTL_ATP_RULES R , MTL_GROUP_ITEM_ATPS_VIEW V  WHERE 
	    D.STATUS_TYPE IN (1,3,4,6) AND (D.START_QUANTITY-D.QUANTITY_COMPLETED) >0  
	    AND D.ORGANIZATION_ID=V.ORGANIZATION_ID  AND D.PRIMARY_ITEM_ID=
	    V.INVENTORY_ITEM_ID  AND (D.COMPLETION_SUBINVENTORY IS NULL OR EXISTS 
	    (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=
	    D.ORGANIZATION_ID AND D.COMPLETION_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME 
	    AND S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES,1, 1, NULL, 1, 
	    S.INVENTORY_ATP_CODE) AND S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES,
	     2, 1, S.AVAILABILITY_TYPE)))   AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND 
	    V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = 
	    group_id  AND I.ORGANIZATION_ID=V.ORGANIZATION_ID  AND I.INVENTORY_ITEM_ID 
	    = V.INVENTORY_ITEM_ID  AND P.CALENDAR_CODE = C.CALENDAR_CODE  AND 
	    P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND C.CALENDAR_DATE = 
	    TRUNC(D.SCHEDULED_COMPLETION_DATE); 


             
        CURSOR sdj1_stmt IS
          SELECT 1, DECODE(D.JOB_TYPE, 1, 5, 7) , 5 , D.WIP_ENTITY_ID , 2 , 
	    GREATEST(-1*(REQUIRED_QUANTITY-QUANTITY_ISSUED),0) , 
	    TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) , O.ROWID , V.INVENTORY_ITEM_ID , 
	    V.ORGANIZATION_ID , C.NEXT_SEQ_NUM , NULL  
	  FROM
	   MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_ATP_RULES R , 
	    MTL_SYSTEM_ITEMS I , BOM_CALENDAR_DATES C , WIP_REQUIREMENT_OPERATIONS O , 
	    WIP_DISCRETE_JOBS D  WHERE O.ORGANIZATION_ID=D.ORGANIZATION_ID AND 
	    O.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID  AND O.WIP_ENTITY_ID=
	    D.WIP_ENTITY_ID  AND O.ORGANIZATION_ID = V.ORGANIZATION_ID  AND 
	    O.WIP_SUPPLY_TYPE NOT IN (5,6)  AND O.REQUIRED_QUANTITY < 0  AND 
	    (O.REQUIRED_QUANTITY - O.QUANTITY_ISSUED) < 0  AND O.OPERATION_SEQ_NUM > 0  
	    AND (D.COMPLETION_SUBINVENTORY IS NULL OR EXISTS (SELECT 'X' FROM 
	    MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=D.ORGANIZATION_ID AND 
	    D.COMPLETION_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME AND 
	    S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, 
	    S.INVENTORY_ATP_CODE) AND S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES,
	     2, 1, S.AVAILABILITY_TYPE)))   AND (D.JOB_TYPE=
	    DECODE(R.INCLUDE_DISCRETE_WIP_RECEIPTS, 1, 1, -1)  OR D.JOB_TYPE =
	    DECODE(R.INCLUDE_NONSTD_WIP_RECEIPTS, 1, 3, -1))  AND D.STATUS_TYPE IN (1,3,
	    4,6)  AND D.ORGANIZATION_ID=V.ORGANIZATION_ID  AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND 
	    V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = 
	    group_id  AND I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND 
	    I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND P.CALENDAR_CODE = 
	    C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND 
	    C.CALENDAR_DATE = TRUNC(O.DATE_REQUIRED);
	    

             
        CURSOR srj_stmt IS
           SELECT 
             /*+ index (C bom_calendar_dates_n3)*/ 1,
             4 ,
             5 ,
             WRS.WIP_ENTITY_ID ,
             2 ,
             DECODE(SIGN(WRS.DAILY_PRODUCTION_RATE*(C.NEXT_SEQ_NUM-C1.NEXT_SEQ_NUM)-WRS.QUANTITY_COMPLETED),
             -1,
             WRS.DAILY_PRODUCTION_RATE*LEAST(C.NEXT_SEQ_NUM-C1.NEXT_SEQ_NUM+1,
             WRS.PROCESSING_WORK_DAYS)-WRS.QUANTITY_COMPLETED,
             LEAST(C1.NEXT_SEQ_NUM+WRS.PROCESSING_WORK_DAYS-C.NEXT_SEQ_NUM,
             1)*WRS.DAILY_PRODUCTION_RATE) ,
             TO_NUMBER(TO_CHAR(C.NEXT_DATE,
             'J')) ,
             WRS.ROWID ,
             V.INVENTORY_ITEM_ID ,
             V.ORGANIZATION_ID ,
             C.NEXT_SEQ_NUM ,
             NULL
           FROM 
             MTL_GROUP_ATPS_VIEW V,
             MTL_ATP_RULES R ,
             MTL_SYSTEM_ITEMS I ,
             MTL_PARAMETERS P ,
             BOM_CALENDAR_DATES C ,
             BOM_CALENDAR_DATES C1 ,
             WIP_REPETITIVE_SCHEDULES WRS ,
             WIP_REPETITIVE_ITEMS WRI
           WHERE 
             WRS.ORGANIZATION_ID = WRI.ORGANIZATION_ID AND
             WRS.STATUS_TYPE IN (1,3,4,6)  AND
             WRI.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
             WRI.PRIMARY_ITEM_ID=DECODE(R.INCLUDE_REP_WIP_RECEIPTS,2, -1, V.INVENTORY_ITEM_ID)  AND
             WRI.WIP_ENTITY_ID = WRS.WIP_ENTITY_ID  AND
             WRI.LINE_ID = WRS.LINE_ID  AND
             (WRI.COMPLETION_SUBINVENTORY IS NULL OR EXISTS (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=WRI.ORGANIZATION_ID AND
             WRI.COMPLETION_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME AND
             S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES,1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND
             S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)))   AND
             P.ORGANIZATION_ID =NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND
             C1.CALENDAR_CODE=P.CALENDAR_CODE  AND
             C1.EXCEPTION_SET_ID=P.CALENDAR_EXCEPTION_SET_ID  AND
             C1.CALENDAR_DATE=TRUNC(WRS.FIRST_UNIT_COMPLETION_DATE)  AND
             C.CALENDAR_CODE=P.CALENDAR_CODE  AND
             C.EXCEPTION_SET_ID=P.CALENDAR_EXCEPTION_SET_ID  AND
             C.SEQ_NUM BETWEEN C1.NEXT_SEQ_NUM AND
             C1.NEXT_SEQ_NUM + CEIL(WRS.PROCESSING_WORK_DAYS - 1)  AND
             WRS.DAILY_PRODUCTION_RATE*LEAST(C.NEXT_SEQ_NUM-C1.NEXT_SEQ_NUM+1,WRS.PROCESSING_WORK_DAYS) > WRS.QUANTITY_COMPLETED  AND
             V.AVAILABLE_TO_ATP = 1  AND
             V.ATP_RULE_ID = R.RULE_ID  AND
             V.ATP_GROUP_ID = group_id  AND
             I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
             I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID;
             
        CURSOR dmo_stmt IS
          SELECT 1, 32 , 31 , L.HEADER_ID , 1 , -1 * 
	    SUM(L.QUANTITY-NVL(L.QUANTITY_DETAILED,0)) , TO_NUMBER(TO_CHAR(C.PRIOR_DATE,
	    'J')) , CHARTOROWID('0') , V.INVENTORY_ITEM_ID , V.ORGANIZATION_ID , 
	    C.PRIOR_SEQ_NUM , NULL  
	  FROM
	   MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_ATP_RULES R , 
	    MTL_SYSTEM_ITEMS I , BOM_CALENDAR_DATES C , MTL_TRANSACTION_TYPES T , 
	    MTL_TXN_REQUEST_HEADERS H , MTL_TXN_REQUEST_LINES L  WHERE 
	    L.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID AND L.ORGANIZATION_ID = 
	    V.ORGANIZATION_ID  AND L.HEADER_ID = H.HEADER_ID  AND T.TRANSACTION_TYPE_ID 
	    = L.TRANSACTION_TYPE_ID  AND L.LINE_STATUS IN (3,7)  AND H.MOVE_ORDER_TYPE 
	    IN (1,2,5)  AND T.TRANSACTION_ACTION_ID <> 28   AND 
	    L.QUANTITY-NVL(L.QUANTITY_DETAILED,0) > 0  AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND 
	    (L.FROM_SUBINVENTORY_CODE IS NULL OR L.FROM_SUBINVENTORY_CODE IN (SELECT 
	    S.SECONDARY_INVENTORY_NAME FROM MTL_SECONDARY_INVENTORIES S WHERE 
	    S.ORGANIZATION_ID=L.ORGANIZATION_ID AND S.INVENTORY_ATP_CODE =
	    DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND 
	    S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, 
	    S.AVAILABILITY_TYPE)))   AND V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = 
	    R.RULE_ID  AND V.ATP_GROUP_ID = group_id  AND I.ORGANIZATION_ID = 
	    V.ORGANIZATION_ID  AND I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND 
	    P.CALENDAR_CODE = C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = 
	    C.EXCEPTION_SET_ID  AND C.CALENDAR_DATE = TRUNC(L.DATE_REQUIRED)  AND 
	    sys_seq_num = sys_seq_num  GROUP BY L.HEADER_ID,
	    TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')),CHARTOROWID('0'),V.INVENTORY_ITEM_ID,
	    V.ORGANIZATION_ID,C.PRIOR_SEQ_NUM;

           
        CURSOR amo_stmt IS
          SELECT 1, 33 , 31 , L.HEADER_ID , 1 , -1 * SUM(M.PRIMARY_QUANTITY) , 
	    TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) , CHARTOROWID('0') , 
	    V.INVENTORY_ITEM_ID , V.ORGANIZATION_ID , C.PRIOR_SEQ_NUM , NULL  
	  FROM
	   MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_ATP_RULES R , 
	    MTL_SYSTEM_ITEMS I , BOM_CALENDAR_DATES C , MTL_TRANSACTION_TYPES T , 
	    MTL_TXN_REQUEST_HEADERS H , MTL_TXN_REQUEST_LINES L , 
	    MTL_MATERIAL_TRANSACTIONS_TEMP M  WHERE L.INVENTORY_ITEM_ID=
	    V.INVENTORY_ITEM_ID AND L.ORGANIZATION_ID = V.ORGANIZATION_ID  AND 
	    L.HEADER_ID = H.HEADER_ID  AND T.TRANSACTION_TYPE_ID = 
	    L.TRANSACTION_TYPE_ID  AND L.LINE_STATUS IN (3,7)  AND H.MOVE_ORDER_TYPE IN 
	    (1,2,5)  AND T.TRANSACTION_ACTION_ID <> 28   AND L.LINE_ID = 
	    M.MOVE_ORDER_LINE_ID   AND P.ORGANIZATION_ID = 
	    NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND 
	    M.SUBINVENTORY_CODE IN (SELECT S.SECONDARY_INVENTORY_NAME FROM 
	    MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=L.ORGANIZATION_ID AND 
	    S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, 
	    S.INVENTORY_ATP_CODE) AND S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES,
	     2, 1, S.AVAILABILITY_TYPE))   AND V.AVAILABLE_TO_ATP = 1  AND 
	    V.ATP_RULE_ID = R.RULE_ID  AND V.ATP_GROUP_ID = group_id  AND 
	    I.ORGANIZATION_ID = V.ORGANIZATION_ID  AND I.INVENTORY_ITEM_ID = 
	    V.INVENTORY_ITEM_ID  AND P.CALENDAR_CODE = C.CALENDAR_CODE  AND 
	    P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND C.CALENDAR_DATE = 
	    TRUNC(SYSDATE)  AND sys_seq_num  = sys_seq_num  GROUP BY L.HEADER_ID,
	    TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')),CHARTOROWID('0'),V.INVENTORY_ITEM_ID,
	    V.ORGANIZATION_ID,C.PRIOR_SEQ_NUM;

           
        CURSOR smo_stmt IS
           SELECT 1, 34 , 31 , L.HEADER_ID , 2 , SUM(L.QUANTITY-NVL(L.QUANTITY_DELIVERED,
	     0)) , TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')) , CHARTOROWID('0') , 
	     V.INVENTORY_ITEM_ID , V.ORGANIZATION_ID , C.PRIOR_SEQ_NUM , NULL  
	   FROM
	    MTL_GROUP_ITEM_ATPS_VIEW V, MTL_PARAMETERS P , MTL_ATP_RULES R , 
	     MTL_SYSTEM_ITEMS I , BOM_CALENDAR_DATES C , MTL_TRANSACTION_TYPES T , 
	     MTL_TXN_REQUEST_HEADERS H , MTL_TXN_REQUEST_LINES L  WHERE 
	     L.INVENTORY_ITEM_ID=V.INVENTORY_ITEM_ID AND L.ORGANIZATION_ID = 
	     V.ORGANIZATION_ID  AND L.HEADER_ID = H.HEADER_ID  AND T.TRANSACTION_TYPE_ID 
	     = L.TRANSACTION_TYPE_ID  AND T.TRANSACTION_ACTION_ID <> 28   AND 
	     L.QUANTITY-NVL(L.QUANTITY_DELIVERED,0) > 0  AND P.ORGANIZATION_ID = 
	     NVL(V.ATP_CALENDAR_ORGANIZATION_ID,V.ORGANIZATION_ID)  AND L.LINE_STATUS IN 
	     (3,7)  AND ((H.MOVE_ORDER_TYPE IN (1,2,5)  AND L.TO_SUBINVENTORY_CODE IN 
	     (SELECT S.SECONDARY_INVENTORY_NAME FROM MTL_SECONDARY_INVENTORIES S WHERE 
	     S.ORGANIZATION_ID=L.ORGANIZATION_ID AND S.INVENTORY_ATP_CODE =
	     DECODE(R.DEFAULT_ATP_SOURCES, 1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND 
	     S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, 
	     S.AVAILABILITY_TYPE)) ) OR (H.MOVE_ORDER_TYPE = 6  AND 
	     T.TRANSACTION_SOURCE_TYPE_ID = 5  AND T.TRANSACTION_ACTION_ID = 31  AND 
	     L.LPN_ID IS NOT NULL ))  AND V.AVAILABLE_TO_ATP = 1  AND V.ATP_RULE_ID = 
	     R.RULE_ID  AND V.ATP_GROUP_ID = group_id  AND I.ORGANIZATION_ID = 
	     V.ORGANIZATION_ID  AND I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND 
	     P.CALENDAR_CODE = C.CALENDAR_CODE  AND P.CALENDAR_EXCEPTION_SET_ID = 
	     C.EXCEPTION_SET_ID  AND C.CALENDAR_DATE = TRUNC(L.DATE_REQUIRED)  AND 
	     sys_seq_num = sys_seq_num  GROUP BY L.HEADER_ID,
	     TO_NUMBER(TO_CHAR(C.PRIOR_DATE,'J')),CHARTOROWID('0'),V.INVENTORY_ITEM_ID,
	     V.ORGANIZATION_ID,C.PRIOR_SEQ_NUM;

           
        CURSOR sfs_stmt IS
           SELECT 
             1,
             24 ,
             5 ,
             D.WIP_ENTITY_ID ,
             2 ,
             (DECODE(NVL(V.N_COLUMN1,
             R.INCLUDE_DISCRETE_MPS),
             1,
             DECODE(I.MRP_PLANNING_CODE,
             4,
             NVL(D.MPS_NET_QUANTITY,
             0),
             8,
             NVL(D.MPS_NET_QUANTITY,
             0),
             D.PLANNED_QUANTITY),
             D.PLANNED_QUANTITY) - D.QUANTITY_COMPLETED) ,
             TO_NUMBER(TO_CHAR(C.NEXT_DATE,
             'J')) ,
             D.ROWID ,
             V.INVENTORY_ITEM_ID ,
             V.ORGANIZATION_ID ,
             C.NEXT_SEQ_NUM ,
             NULL
           FROM 
             WIP_FLOW_SCHEDULES D,
             BOM_CALENDAR_DATES C ,
             MTL_PARAMETERS P ,
             MTL_SYSTEM_ITEMS I ,
             MTL_ATP_RULES R ,
             MTL_GROUP_ITEM_ATPS_VIEW V
           WHERE 
             D.STATUS = 1 AND
             D.SCHEDULED_FLAG = 1  AND
             (D.PLANNED_QUANTITY-D.QUANTITY_COMPLETED) >0  AND
             D.ORGANIZATION_ID=V.ORGANIZATION_ID  AND
             D.PRIMARY_ITEM_ID=V.INVENTORY_ITEM_ID  AND
             V.INVENTORY_ITEM_ID=DECODE(R.INCLUDE_FLOW_SCHEDULE_RECEIPTS, 1,V.INVENTORY_ITEM_ID, -1)  AND
             P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID, V.ORGANIZATION_ID)  AND
             (D.COMPLETION_SUBINVENTORY IS NULL OR EXISTS (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=D.ORGANIZATION_ID AND
             D.COMPLETION_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME AND
             S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES,1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND
             S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)))   AND
             V.AVAILABLE_TO_ATP = 1  AND
             V.ATP_RULE_ID = R.RULE_ID  AND
             V.ATP_GROUP_ID = group_id  AND
             I.ORGANIZATION_ID=V.ORGANIZATION_ID  AND
             I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
             NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@'))= DECODE(R.DEMAND_CLASS_ATP_FLAG, 1,NVL(V.DEMAND_CLASS,NVL(P.DEFAULT_DEMAND_CLASS, '@@@')),NVL(D.DEMAND_CLASS, NVL(P.DEFAULT_DEMAND_CLASS,'@@@')))  AND
             C.NEXT_SEQ_NUM >= DECODE(R.PAST_DUE_SUPPLY_CUTOFF_FENCE, NULL, C.NEXT_SEQ_NUM, sys_seq_num-R.PAST_DUE_SUPPLY_CUTOFF_FENCE)  AND
             C.NEXT_SEQ_NUM < NVL(sys_seq_num + (DECODE(R.INFINITE_SUPPLY_FENCE_CODE,1, I.CUMULATIVE_TOTAL_LEAD_TIME,2, I.CUM_MANUFACTURING_LEAD_TIME,3, I.PREPROCESSING_LEAD_TIME+I.FULL_LEAD_TIME+I.POSTPROCESSING_LEAD_TIME,4, R.INFINITE_SUPPLY_TIME_FENCE)), C.NEXT_SEQ_NUM+1)  AND
             P.CALENDAR_CODE = C.CALENDAR_CODE  AND
             P.CALENDAR_EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND
             C.CALENDAR_DATE = TRUNC(D.SCHEDULED_COMPLETION_DATE)  AND
             C.NEXT_SEQ_NUM >= sys_seq_num;
             
       CURSOR dfs_stmt IS
          SELECT 
            /*+ index (F WIP_FLOW_SCHEDULES_N1) */ 1,
            24 ,
            5 ,
            F.WIP_ENTITY_ID ,
            1 ,
            LEAST(-1*(F.PLANNED_QUANTITY-F.QUANTITY_COMPLETED)*EXTENDED_QUANTITY,
            0) ,
            TO_NUMBER(TO_CHAR(C1.PRIOR_DATE,
            'J')) ,
            F.ROWID ,
            V.INVENTORY_ITEM_ID ,
            V.ORGANIZATION_ID ,
            C.PRIOR_SEQ_NUM ,
            NULL
          FROM 
            WIP_FLOW_SCHEDULES F,
            BOM_BILL_OF_MATERIALS BOM ,
            BOM_EXPLOSIONS BE ,
            BOM_CALENDAR_DATES C ,
            BOM_CALENDAR_DATES C1 ,
            MTL_PARAMETERS P ,
            MTL_SYSTEM_ITEMS I ,
            MTL_ATP_RULES R ,
            MTL_GROUP_ITEM_ATPS_VIEW V
          WHERE 
            V.AVAILABLE_TO_ATP = 1 AND
            (I.WIP_SUPPLY_SUBINVENTORY IS NULL OR EXISTS (SELECT 'X' FROM MTL_SECONDARY_INVENTORIES S WHERE S.ORGANIZATION_ID=I.ORGANIZATION_ID AND
            I.WIP_SUPPLY_SUBINVENTORY=S.SECONDARY_INVENTORY_NAME AND
            S.INVENTORY_ATP_CODE =DECODE(R.DEFAULT_ATP_SOURCES,1, 1, NULL, 1, S.INVENTORY_ATP_CODE) AND
            S.AVAILABILITY_TYPE =DECODE(R.DEFAULT_ATP_SOURCES, 2, 1, S.AVAILABILITY_TYPE)))   AND
            V.ATP_RULE_ID = R.RULE_ID  AND
            V.ATP_GROUP_ID = group_id  AND
            V.INVENTORY_ITEM_ID=DECODE(R.INCLUDE_FLOW_SCHEDULE_DEMAND, 1,V.INVENTORY_ITEM_ID, -1)  AND
            I.ORGANIZATION_ID=V.ORGANIZATION_ID  AND
            I.INVENTORY_ITEM_ID = V.INVENTORY_ITEM_ID  AND
            BE.COMPONENT_ITEM_ID = V.INVENTORY_ITEM_ID  AND
            BE.ORGANIZATION_ID = V.ORGANIZATION_ID  AND
            BE.EXPLOSION_TYPE = 'ALL'  AND
            BE.EXTENDED_QUANTITY > 0  AND
            BE.COMPONENT_ITEM_ID != BE.TOP_ITEM_ID  AND
            BOM.BILL_SEQUENCE_ID = BE.TOP_BILL_SEQUENCE_ID  AND
            BOM.ALTERNATE_BOM_DESIGNATOR IS NULL  AND
            TRUNC(BE.EFFECTIVITY_DATE) <= TRUNC(F.SCHEDULED_COMPLETION_DATE)  AND
            TRUNC(BE.DISABLE_DATE) > TRUNC(F.SCHEDULED_COMPLETION_DATE)  AND
            MRP_SCATP_PUB.REQUIRED_COMPONENT(BE.TOP_BILL_SEQUENCE_ID,BE.PLAN_LEVEL, F.SCHEDULED_COMPLETION_DATE, BE.COMPONENT_SEQUENCE_ID, BE.COMPONENT_CODE ) = 1  AND
            F.PRIMARY_ITEM_ID = BOM.ASSEMBLY_ITEM_ID  AND
            F.ORGANIZATION_ID = BOM.ORGANIZATION_ID  AND
            F.STATUS = 1  AND
            F.SCHEDULED_FLAG = 1  AND
            (F.PLANNED_QUANTITY - F.QUANTITY_COMPLETED) >0  AND
            P.ORGANIZATION_ID = NVL(V.ATP_CALENDAR_ORGANIZATION_ID, V.ORGANIZATION_ID)  AND
            C1.CALENDAR_CODE = C.CALENDAR_CODE  AND
            C1.EXCEPTION_SET_ID = C.EXCEPTION_SET_ID  AND
            C1.CALENDAR_DATE = TRUNC(F.SCHEDULED_START_DATE)  AND
            C.CALENDAR_CODE = P.CALENDAR_CODE  AND
            C.EXCEPTION_SET_ID = P.CALENDAR_EXCEPTION_SET_ID  AND
            C.CALENDAR_DATE = TRUNC(F.SCHEDULED_COMPLETION_DATE)  AND
            C.PRIOR_SEQ_NUM >= sys_seq_num;


     BEGIN
        
        SELECT   mtl_atp_rules_s.nextval
           INTO  rule_id
        FROM dual;
        
        
        -- Set the Infinite Supply Time Fence to a large value
        inf_fence := 100000;
        oh_source := 1;
       
        SELECT   value
           INTO  v_trace_dir
        FROM     v$parameter
        WHERE name = 'user_dump_dest';
        
        
     -- Insert a Dummy ATP RULE
        INSERT INTO mtl_atp_rules
              (rule_id
              ,rule_name
              ,created_by
              ,last_update_date
              ,last_updated_by
              ,creation_date
              ,infinite_supply_time_fence
              ,infinite_supply_fence_code
              ,demand_class_atp_flag
              ,include_rep_mps
              ,include_onhand_available
              ,accumulate_available_flag
              ,forward_consumption_flag
              ,backward_consumption_flag
              ,include_sales_orders
              ,include_internal_orders
              ,include_discrete_wip_demand
              ,include_rep_wip_demand
              ,include_nonstd_wip_demand
              ,include_discrete_mps
              ,include_user_defined_demand
              ,include_purchase_orders
              ,include_internal_reqs
              ,include_vendor_reqs
              ,include_discrete_wip_receipts
              ,include_rep_wip_receipts
              ,include_nonstd_wip_receipts
              ,include_interorg_transfers
              ,include_user_defined_supply
              ,include_flow_schedule_demand
              ,include_flow_schedule_receipts
              ,default_atp_sources
              )
        VALUES
              (rule_id,TO_CHAR(rule_id)
              , 0
              , SYSDATE
              , 0
              , SYSDATE
              , inf_fence
              , 4
              , 2
              , 2
              , 2
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , 1
              , oh_source
              );
       
        item_name    := '&inp_item_name';
        org_code     := '&inp_org_code';
        v_nonnet_sub :=  &inp_nonnet_sub;
        v_gen_trace  := '&inp_trace';
       
        BEGIN
        
            SELECT    organization_id
               INTO   org_id
            FROM      mtl_parameters
            WHERE     organization_code = org_code;
        
        EXCEPTION
            WHEN no_data_found THEN
            ErrorPrint('The organization code you entered is incorrect.  Please enter a valid code.');
            return;
        END;

        BEGIN
        
            SELECT    inventory_item_id
               INTO   item_id
            FROM      mtl_system_items_kfv
            WHERE     concatenated_segments = item_name
            AND       organization_id = org_id;
        
        EXCEPTION
            WHEN no_data_found THEN
            ErrorPrint('The item name you entered is incorrect.  Please enter a valid item name.');
            return;
        END;


       
         
    
     -- Set the Infinite Supply Time Fence to a large value
        inf_fence := 100000;
        oh_source := 1;
    
        SELECT   mtl_demand_interface_s.NEXTVAL
           INTO  group_id
        FROM     dual;
    
     
     -- Insert a record into mtl_demand_interface
    
        INSERT INTO mtl_group_atps_view
             (
              atp_group_id
             ,organization_id
             ,inventory_item_id
             ,last_update_date
             ,last_updated_by
             ,creation_date
             ,created_by
             ,atp_rule_id
             ,request_quantity
             ,uom_code
             ,available_to_atp
             ,n_column1
             )
        VALUES
             (
             group_id
             , org_id
             , item_id
             , SYSDATE
             , 0
             , SYSDATE
             , 0
             , rule_id
             , 0
             ,'SD'
             ,1
             ,-1
             );
    
        SELECT   c1.next_seq_num
           INTO  sys_seq_num
        FROM     bom_calendar_dates c1, mtl_parameters p
        WHERE    p.organization_id= org_id
        AND      p.calendar_code = c1.calendar_code
        AND      c1.exception_set_id = p.calendar_exception_set_id
        AND      c1.calendar_date = trunc(sysdate);
    
        SectionPrint ('Parameters');
        Tab0Print('Rule ID:        '||rule_id);
        Tab0Print('Group ID:       '||group_id);
        Tab0Print('Sys Seq Num:    '||sys_seq_num);
        Tab0Print('Item Name/ID:   '||item_name||'/'||item_id);
        Tab0Print('Org Code/ID:    '||org_code||'/'||org_id);
        Tab0Print('Include Option: '||v_nonnet_sub|| ' (1 - ATP Subs, 2 - Net Subs, 3 - All Subs)');
        Tab0Print('Generate Trace: '||v_gen_trace);
        Tab0Print('Trace Dir:      '||v_trace_dir);
        BRPrint;
        
        SectionPrint('Supply/Demand Rollup Patches');
	BRPrint;
	           
	OPEN sd_rollup;
	   FETCH sd_rollup BULK COLLECT INTO
	         rollup_bug
	        ,rollup_date
	   LIMIT 500;
	
	   Tab1Print('Bug Number Creation Date');
	   Tab1Print('---------- -------------');
	
	   IF rollup_bug.COUNT = 0 THEN
	
	      ActionWarningPrint('No rollup patches found.  Please apply the latest rollup per Metalink Note: 286755.1');
	
	   ELSE
	      LOOP
	         FOR j IN 1..rollup_bug.COUNT LOOP
	
	         Tab1Print(lpad(rollup_bug(j),10,' ') ||' '||
	                   rpad(rollup_date(j),13,' ')
	                  );
	         END LOOP;
	
	   FETCH sd_rollup BULK COLLECT INTO
	         rollup_bug
	        ,rollup_date
	   LIMIT 500;
	
	   EXIT WHEN rollup_bug.COUNT = 0;
	   END LOOP;
           END IF;
        CLOSE sd_rollup;

       
        SectionPrint('INV Remote Procedure Manager Setup');
        BRPrint;
       
        SELECT   'INV Remote Procudure Manager'
                ,running_processes
                ,max_processes
           INTO  v_conc_queue_name
                ,v_run_process
                ,v_max_process
        FROM     fnd_concurrent_queues_vl
        WHERE    concurrent_queue_name = 'INVTMRPM';
       
        Tab1Print('Concurrent Manager           Acutal Processes Target Processes');
        Tab1Print('---------------------------- ---------------- ----------------');
        Tab1Print(rpad(v_conc_queue_name,28,' ')||' '||
                  lpad(v_run_process,16,' ')||' '||
                  lpad(v_max_process,16,' ')
                 );
        BRPrint;
       
        IF v_max_process < 3 THEN
           WarningPrint('Please set Target Processes to at least 3 to avoid performance issues.');
        END IF;
        
       sqltxt :=  'select table_name, last_analyzed '||
                  'from dba_tables '||
                  'where table_name in ('||
                  '''MTL_SYSTEM_ITEMS_B'','||
	          '''MTL_ATP_RULES'','||
	          '''BOM_CALENDAR_DATES'','||
	          '''OE_ORDER_LINES_ALL'','||
	          '''MTL_DEMAND'','||
	          '''MTL_SECONDARY_INVENTORIES'','||
	          '''WIP_REQUIREMENT_OPERATIONS'','||
	          '''WIP_DISCRETE_JOBS'','||
	          '''WIP_REPETITIVE_SCHEDULES'','||
	          '''MTL_USER_DEMAND'','||
	          '''MTL_ONHAND_QUANTITIES_DETAIL'','||
	          '''MTL_MATERIAL_TRANSACTIONS_TEMP'','||
	          '''MTL_SUPPLY'','||
	          '''MTL_USER_SUPPLY'','||
	          '''MRP_SCHEDULE_DESIGNATORS'','||
	          '''MRP_SCHEDULE_DATES'','||
	          '''WIP_REPETITIVE_ITEMS'','||
	          '''MTL_TXN_REQUEST_LINES'','||
	          '''MTL_TXN_REQUEST_HEADERS'','||
	          '''MTL_TRANSACTION_TYPES'','||
	          '''CST_COST_GROUPS'','||
	          '''WMS_LICENSE_PLATE_NUMBERS'','||
	          '''WIP_FLOW_SCHEDULES'','||
	          '''BOM_STRUCTURES_B'','||
	          '''BOM_EXPLOSIONS'')';
	disp_lengths := lengths(30,12);
	col_headers  := headers('Table Name', 'Last Analyzed');
	   
	Run_SQL('Table Statistics', sqltxt, disp_lengths, col_headers);

        

        SectionPrint('Validate S/D Quantity');
        
        SELECT lot_control_code
           into l_lot_control
        from  mtl_system_items_b
        where inventory_item_id = item_id
        and   organization_id = org_id;
        
        IF (v_nonnet_sub = 1) THEN
            SELECT SUM(moq.primary_transaction_quantity)
            INTO   l_moq_qty
            FROM   mtl_onhand_quantities_detail moq, mtl_lot_numbers mln
            WHERE  moq.organization_id = org_id
            AND    moq.inventory_item_id = item_id
            AND    EXISTS (select 'x' from mtl_secondary_inventories msi
            WHERE  msi.organization_id = moq.organization_id and
                   msi.secondary_inventory_name = moq.subinventory_code
            AND    nvl(msi.inventory_atp_code,1) = 1)
            AND    moq.organization_id = nvl(moq.planning_organization_id, moq.organization_id)
            AND    moq.lot_number = mln.lot_number(+)
            AND    moq.organization_id = mln.organization_id(+)
            AND    moq.inventory_item_id = mln.inventory_item_id(+)
            AND    trunc(nvl(mln.expiration_date, sysdate+1)) > trunc(sysdate)
            AND    nvl(moq.planning_tp_type,2) = 2;
        ELSE   
            SELECT SUM(moq.primary_transaction_quantity)
            INTO   l_moq_qty
            FROM   mtl_onhand_quantities_detail moq, mtl_lot_numbers mln
            WHERE  moq.organization_id = org_id
            AND    moq.inventory_item_id = item_id
            AND    EXISTS (select 'x' from mtl_secondary_inventories msi
            WHERE  msi.organization_id = moq.organization_id and 
                   msi.secondary_inventory_name = moq.subinventory_code 
            AND    msi.availability_type = decode(v_nonnet_sub,3,msi.availability_type,1))
            AND    moq.organization_id = nvl(moq.planning_organization_id, moq.organization_id)
            AND    moq.lot_number = mln.lot_number(+)
            AND    moq.organization_id = mln.organization_id(+)
            AND    moq.inventory_item_id = mln.inventory_item_id(+)
            AND    trunc(nvl(mln.expiration_date, sysdate+1)) > trunc(sysdate)
            AND    nvl(moq.planning_tp_type,2) = 2;
         END IF;    
       
         Tab0Print('- Total MOQ quantity Org level: ' || to_char(l_moq_qty));
        
         IF (l_lot_control = 2) THEN
	         
            IF (v_nonnet_sub = 1) THEN
      
               SELECT SUM(Decode(mmtt.transaction_action_id, 1, -1, 2, -1, 28, -1, 3, -1,
                      Sign(mmtt.primary_quantity)) * Abs( mmtt.primary_quantity ))
               INTO   l_mmtt_qty_src
               FROM   mtl_material_transactions_temp mmtt
               WHERE  mmtt.organization_id = org_id
               AND    mmtt.inventory_item_id = item_id
               AND    mmtt.posting_flag = 'Y'
               AND    mmtt.subinventory_code IS NOT NULL
               AND    Nvl(mmtt.transaction_status,0) <> 2
               AND    mmtt.transaction_action_id NOT IN (24,30)
               AND    EXISTS (select 'x' from mtl_secondary_inventories msi
                      WHERE msi.organization_id = mmtt.organization_id
                      AND   msi.secondary_inventory_name = mmtt.subinventory_code
                      AND   nvl(msi.inventory_atp_code,1) = 1)
               AND    mmtt.planning_organization_id IS NULL
               AND    EXISTS (select 'x' from mtl_transaction_lots_temp mtlt, mtl_lot_numbers mln
                              WHERE  mtlt.transaction_temp_id = mmtt.transaction_temp_id
                              AND    mtlt.lot_number = mln.lot_number(+)
                              AND    org_id = mln.organization_id(+)
                              AND    item_id = mln.inventory_item_id(+)
                              AND    trunc(nvl(nvl(mtlt.lot_expiration_date,mln.expiration_Date),sysdate+1))> trunc(sysdate))
               AND  nvl(mmtt.planning_tp_type,2) = 2;
	         
            ELSE
	    
	       SELECT SUM(Decode(mmtt.transaction_action_id, 1, -1, 2, -1, 28, -1, 3, -1,
	              Sign(mmtt.primary_quantity)) * Abs( mmtt.primary_quantity ))
	       INTO   l_mmtt_qty_src
	       FROM   mtl_material_transactions_temp mmtt
	       WHERE  mmtt.organization_id = org_id
	       AND    mmtt.inventory_item_id = item_id
	       AND    mmtt.posting_flag = 'Y'
	       AND    mmtt.subinventory_code IS NOT NULL 
	       AND    Nvl(mmtt.transaction_status,0) <> 2 
	       AND    mmtt.transaction_action_id NOT IN (24,30)
	       AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	              WHERE msi.organization_id = mmtt.organization_id
	              AND   msi.secondary_inventory_name = mmtt.subinventory_code 
	              AND    msi.availability_type = decode(v_nonnet_sub,3,msi.availability_type,1))
	       AND    mmtt.planning_organization_id IS NULL
	       AND    EXISTS (select 'x' from mtl_transaction_lots_temp mtlt, mtl_lot_numbers mln
	                      WHERE  mtlt.transaction_temp_id = mmtt.transaction_temp_id
	                      AND    mtlt.lot_number = mln.lot_number(+)
	                      AND    org_id = mln.organization_id(+)
	                      AND    item_id = mln.inventory_item_id(+)
	                      AND    trunc(nvl(nvl(mtlt.lot_expiration_date,mln.expiration_Date),sysdate+1))> trunc(sysdate)) 
               AND  nvl(mmtt.planning_tp_type,2) = 2;
	
 	   END IF;
	
	   Tab0Print('- Total MMTT Trx quantity Source Org level (lot Controlled): ' || to_char(l_mmtt_qty_src));
	       
	   IF (v_nonnet_sub = 1) THEN
	
	      SELECT SUM(Abs(mmtt.primary_quantity))
	      INTO   l_mmtt_qty_dest
	      FROM   mtl_material_transactions_temp mmtt
	      WHERE  decode(mmtt.transaction_action_id,3,
	             mmtt.transfer_organization,mmtt.organization_id) = org_id
	      AND    mmtt.inventory_item_id = item_id
	      AND    mmtt.posting_flag = 'Y'
	      AND    Nvl(mmtt.transaction_status,0) <> 2
	      AND    mmtt.transaction_action_id  in (2,28,3)
	      AND    ((mmtt.transfer_subinventory IS NULL) OR
	              (mmtt.transfer_subinventory IS NOT NULL
	      AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	                WHERE msi.organization_id = decode(mmtt.transaction_action_id,
	                                            3, mmtt.transfer_organization,mmtt.organization_id)
	                AND   msi.secondary_inventory_name = mmtt.transfer_subinventory
	                AND   nvl(msi.inventory_atp_code,1) = 1)))
	      AND    mmtt.planning_organization_id IS NULL
	      AND    EXISTS (select 'x' from mtl_transaction_lots_temp mtlt, mtl_lot_numbers mln
	                     WHERE  mtlt.transaction_temp_id = mmtt.transaction_temp_id
	                     AND    mtlt.lot_number = mln.lot_number (+)
	                     AND    decode(mmtt.transaction_action_id,
	                               3, mmtt.transfer_organization,mmtt.organization_id) = mln.organization_id(+)
	                     AND    item_id = mln.inventory_item_id(+)
	                     AND    trunc(nvl(nvl(mtlt.lot_expiration_Date,mln.expiration_date),sysdate+1))> trunc(sysdate))
	      AND  nvl(mmtt.planning_tp_type,2) = 2;
	
	   ELSE
	
	      SELECT SUM(Abs(mmtt.primary_quantity))
	      INTO   l_mmtt_qty_dest
	      FROM   mtl_material_transactions_temp mmtt
	      WHERE  decode(mmtt.transaction_action_id,3,
	             mmtt.transfer_organization,mmtt.organization_id) = org_id
	      AND    mmtt.inventory_item_id = item_id
	      AND    mmtt.posting_flag = 'Y'
	      AND    Nvl(mmtt.transaction_status,0) <> 2
	      AND    mmtt.transaction_action_id  in (2,28,3)
	      AND    ((mmtt.transfer_subinventory IS NULL) OR
	              (mmtt.transfer_subinventory IS NOT NULL 
	      AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	                WHERE msi.organization_id = decode(mmtt.transaction_action_id,
	                                             3, mmtt.transfer_organization,mmtt.organization_id)
	                AND   msi.secondary_inventory_name = mmtt.transfer_subinventory
	                AND   msi.availability_type = decode(v_nonnet_sub,3,msi.availability_type,1))))
	      AND    mmtt.planning_organization_id IS NULL
	      AND    EXISTS (select 'x' from mtl_transaction_lots_temp mtlt, mtl_lot_numbers mln
	                     WHERE  mtlt.transaction_temp_id = mmtt.transaction_temp_id
	                     AND    mtlt.lot_number = mln.lot_number (+)
	                     AND    decode(mmtt.transaction_action_id,
	                               3, mmtt.transfer_organization,mmtt.organization_id) = mln.organization_id(+)
	                     AND    item_id = mln.inventory_item_id(+)
	                     AND    trunc(nvl(nvl(mtlt.lot_expiration_Date,mln.expiration_date),sysdate+1))> trunc(sysdate)) 
              AND  nvl(mmtt.planning_tp_type,2) = 2;
		
           END IF;
	
	            
	   Tab0Print('- Total MMTT Trx quantity Dest Org level (lot controlled): ' || to_char(l_mmtt_qty_dest));
	           
        ELSE
	
           IF (v_nonnet_sub = 1) THEN
	
	      SELECT SUM(Decode(mmtt.transaction_action_id, 1, -1, 2, -1, 28, -1, 3, -1,
	             Sign(mmtt.primary_quantity)) * Abs( mmtt.primary_quantity ))
	      INTO   l_mmtt_qty_src
	      FROM   mtl_material_transactions_temp mmtt
	      WHERE  mmtt.organization_id = org_id
	      AND    mmtt.inventory_item_id = item_id
	      AND    mmtt.posting_flag = 'Y'
	      AND    mmtt.subinventory_code IS NOT NULL
	      AND    Nvl(mmtt.transaction_status,0) <> 2
	      AND    mmtt.transaction_action_id NOT IN (24,30)
	      AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	             WHERE msi.organization_id = mmtt.organization_id
	             AND   msi.secondary_inventory_name = mmtt.subinventory_code
	             AND   nvl(msi.inventory_atp_code,1) = 1)
	      AND    mmtt.planning_organization_id IS NULL
	      AND  nvl(mmtt.planning_tp_type,2) = 2;
	
	   ELSE
	
	      SELECT SUM(Decode(mmtt.transaction_action_id, 1, -1, 2, -1, 28, -1, 3, -1,
	             Sign(mmtt.primary_quantity)) * Abs( mmtt.primary_quantity ))
	      INTO   l_mmtt_qty_src
	      FROM   mtl_material_transactions_temp mmtt
	      WHERE  mmtt.organization_id = org_id
	      AND    mmtt.inventory_item_id = item_id
	      AND    mmtt.posting_flag = 'Y'
	      AND    mmtt.subinventory_code IS NOT NULL 
	      AND    Nvl(mmtt.transaction_status,0) <> 2 
	      AND    mmtt.transaction_action_id NOT IN (24,30)
	      AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	             WHERE msi.organization_id = mmtt.organization_id
	             AND   msi.secondary_inventory_name = mmtt.subinventory_code 
	             AND    msi.availability_type = decode(v_nonnet_sub,3,msi.availability_type,1))
	      AND    mmtt.planning_organization_id IS NULL
	      AND  nvl(mmtt.planning_tp_type,2) = 2;
	
           END IF;
	
	   Tab0Print('- Total MMTT Trx quantity Source Org level: ' || to_char(l_mmtt_qty_src));
	     
	    
	IF (v_nonnet_sub = 1) THEN
	
	   SELECT SUM(Abs(mmtt.primary_quantity))
	   INTO   l_mmtt_qty_dest
	   FROM   mtl_material_transactions_temp mmtt
	   WHERE  decode(mmtt.transaction_action_id,3,
	          mmtt.transfer_organization,mmtt.organization_id) = org_id
	   AND    mmtt.inventory_item_id = item_id
	   AND    mmtt.posting_flag = 'Y'
	   AND    Nvl(mmtt.transaction_status,0) <> 2
	   AND    mmtt.transaction_action_id  in (2,28,3)
	   AND    ((mmtt.transfer_subinventory IS NULL) OR
	            (mmtt.transfer_subinventory IS NOT NULL
	   AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	             WHERE msi.organization_id = decode(mmtt.transaction_action_id,
	                                          3, mmtt.transfer_organization,mmtt.organization_id)
	             AND   msi.secondary_inventory_name = mmtt.transfer_subinventory
	            AND   nvl(msi.inventory_atp_code,1) = 1)))
	   AND    mmtt.planning_organization_id IS NULL
	   AND  nvl(mmtt.planning_tp_type,2) = 2;
	          
	ELSE
	
	   SELECT SUM(Abs(mmtt.primary_quantity))
	   INTO   l_mmtt_qty_dest
	   FROM   mtl_material_transactions_temp mmtt
	   WHERE  decode(mmtt.transaction_action_id,3,
	          mmtt.transfer_organization,mmtt.organization_id) = org_id
	   AND    mmtt.inventory_item_id = item_id
	   AND    mmtt.posting_flag = 'Y'
	   AND    Nvl(mmtt.transaction_status,0) <> 2
	   AND    mmtt.transaction_action_id  in (2,28,3)
	   AND    ((mmtt.transfer_subinventory IS NULL) OR
	           (mmtt.transfer_subinventory IS NOT NULL 
	   AND    EXISTS (select 'x' from mtl_secondary_inventories msi
	             WHERE msi.organization_id = decode(mmtt.transaction_action_id,
	                                          3, mmtt.transfer_organization,mmtt.organization_id)
	             AND   msi.secondary_inventory_name = mmtt.transfer_subinventory
	             AND   msi.availability_type = decode(v_nonnet_sub,3,msi.availability_type,1))))
	   AND    mmtt.planning_organization_id IS NULL
	   AND  nvl(mmtt.planning_tp_type,2) = 2;
		
	END IF;
	
	Tab0Print('- Total MMTT Trx quantity Dest Org level: ' || to_char(l_mmtt_qty_dest));
	            
        END IF;
	
	        
        SELECT SUM(inv_decimals_pub.get_primary_quantity( org_id
                                                         ,item_id
                                                         ,mtrl.uom_code
                                                         ,mtrl.quantity - NVL(mtrl.quantity_delivered,0))
                                                        )
        INTO  l_lpn_qty
        FROM  mtl_txn_request_lines mtrl, mtl_txn_request_headers mtrh, mtl_transaction_types mtt
        where mtrl.organization_id = org_id
        AND   mtrl.inventory_item_id = item_id
        AND   mtrl.header_id = mtrh.header_id
        AND   mtrh.move_order_type = 6 -- Putaway Move Order
        AND   mtrl.transaction_source_type_id = 5 -- Wip
        AND   mtt.transaction_action_id = 31 -- WIP Assembly Completion
        AND   mtt.transaction_type_id   = mtrl.transaction_type_id
        AND   mtrl.line_status = 7 -- Pre Approved
        AND   mtrl.lpn_id is not null;
	
        Tab0Print('- Total MTRL undelivered LPN quantity for WIP completions: ' || to_char(l_lpn_qty));
     
        l_qoh :=  nvl(l_moq_qty,0) + nvl(l_mmtt_qty_src,0) + nvl(l_mmtt_qty_dest,0) + nvl(l_lpn_qty,0);
     
        Tab0Print('- Total quantity on-hand: ' || to_char(l_qoh));
 
        SectionPrint('Profile Options');
        Display_Profiles(null,'INV_RPC_TIMEOUT');
        BRPrint;
       
           SELECT    profile_option_value
              INTO	 v_rpc_prof
           FROM      fnd_profile_option_values
           WHERE     level_id = 10001
           AND       profile_option_id = 
                    (SELECT profile_option_id
                     FROM   fnd_profile_options
                     WHERE  profile_option_name = 'INV_RPC_TIMEOUT');
                     
           IF v_rpc_prof < 90 THEN
              WarningPrint('For INV-APP-05647/05649 errors, set the profile INV:RPC Timeout to 900 and retry');
           END IF;
                  
        BRPrint;
        Display_Profiles(null,'CONC_TOKEN_TIMEOUT');
        BRPrint;
        
--           SELECT     nvl(profile_option_value,10)
--              INTO       v_conc_wait
--           FROM       fnd_profile_option_values
--           WHERE      level_id = 10001
--           AND        profile_option_id = 
--                     (SELECT profile_option_id
--                      FROM   fnd_profile_options
--                      WHERE  profile_option_name = 'CONC_TOKEN_TIMEOUT');
--                      
--           IF v_conc_wait > 5 THEN
--	      WarningPrint('For performance issues, try decreasing the value of the profile option Concurrent:Wait for Available TM to less than 5');
--	   END IF;

        Display_Profiles(null,'INV_DEBUG_TRACE');
        BRPrint;
        Display_Profiles(null,'INV_DEBUG_FILE');
        BRPrint;
        Display_Profiles(null,'INV_DEBUG_LEVEL');
        BRPrint;
        Display_Profiles(null,'MRP_DEBUG');
        BRPrint;
       
        
        SectionPrint('MTL_TXN_REQUEST_LINES Issues');
 
           SELECT count(*)
              INTO   v_index_count
           FROM (
                 select count(*) as count
                 from dba_ind_columns
	         where table_name = 'MTL_TXN_REQUEST_LINES' 
	         and column_name = 'INVENTORY_ITEM_ID' 
	         and column_position = 1
	         INTERSECT
	         select count(*) as count
	         from dba_ind_columns
	         where table_name = 'MTL_TXN_REQUEST_LINES'
	         and column_name = 'ORGANIZATION_ID'
	         and column_position = 2
	         INTERSECT
	         select count(*) as count
	         from dba_ind_columns
	         where table_name = 'MTL_TXN_REQUEST_LINES'
	         and column_name = 'LINE_STATUS'
	         and column_position = 3
	        );
                
           IF v_index_count = 0 THEN
              WarningPrint('If you are experiencing performance problems in 11.5.9, apply patch 4440615');
              WarningPrint('If you are experiencing performance problems in 11.5.10, apply patch 4734840');
           ELSE
              Tab0Print('Index MTL_TXN_REQUEST_LINES_N9 exists');
           END IF;
        BRPrint;
        
       sqltxt :=  'select line_status, count(*) '||
                  'from mtl_txn_request_lines '||
                  'group by line_status';
                  
	disp_lengths := lengths(15,15);
	col_headers  := headers('Line Status', '# of Records');
	   
	Run_SQL('MTL_TXN_REQUEST_LINES Count', sqltxt, disp_lengths, col_headers);
        
        

        SectionPrint('Supply/Demand Cursors');
          SectionPrint('DMD_STMT - MTL_DEMAND_OMOE');
          BRPrint;
          Tab1Print('- Opening Cursor DMD_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));
        
        IF upper(v_gen_trace) = 'Y' THEN
           EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR0_dmd_stmt'''); 
           EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
        END IF;
        
        OPEN dmd_stmt;
        
        LOOP
          FETCH dmd_stmt BULK COLLECT INTO 
                rsv_type
               ,src_type
               ,trx_type
               ,src_id
               ,sd_type
               ,sd_qty
               ,osd_date
               ,sd_rowid
               ,sd_item
               ,sd_org
               ,sd_date
               ,src_name
          LIMIT 500;
       
          Tab1Print('- Fetched: DMD_STMT, rows: '|| to_char(dmd_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
             LOOP
                SELECT to_date(osd_date(j),'j')
                INTO reqt_date
             FROM DUAL;
             
             Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                       lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                       lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                       lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                       lpad(to_char(reqt_date),16,' ')
                      );
                      
             END LOOP;
          EXIT when dmd_stmt%NOTFOUND;
        END LOOP;
        BRPrint;
        CLOSE dmd_stmt;
       
        IF upper(v_gen_trace) = 'Y' THEN
           EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
        END IF;
       
        Tab1Print('- Closing Cursor DMD_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS')); 

           SectionPrint('DMD2_STMT - MTL_DEMAND');
           BRPrint;
	   Tab1Print('- Opening Cursor DMD2_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

        IF upper(v_gen_trace) = 'Y' THEN
           EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR1_dmd2_stmt'''); 
           EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
        END IF;
       
        OPEN dmd2_stmt;
       
        LOOP
          FETCH dmd2_stmt BULK COLLECT INTO 
                    rsv_type
                   ,src_type
                   ,trx_type
                   ,src_id
                   ,sd_type
                   ,sd_qty
                   ,osd_date
                   ,sd_rowid
                   ,sd_item
                   ,sd_org
                   ,sd_date
                   ,src_name

           LIMIT 500;
          
           Tab1Print('- Fetched: DMD2_STMT, rows: '|| to_char(dmd2_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
           BRPrint;
           Tab1Print('|----------------------- Supply/Demand -------------------------|');
           Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
           Tab1Print(' ---------------- ----------- -------- -------- ----------------');

           FOR j IN 1..rsv_type.COUNT
              LOOP
                SELECT to_date(osd_date(j),'j')
              INTO reqt_date
              FROM DUAL;
 
             Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                       lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                       lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                       lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                       lpad(to_char(reqt_date),16,' ')
                      );
            
           END LOOP;
       EXIT when dmd2_stmt%NOTFOUND;
       END LOOP;
       BRPrint;
       CLOSE dmd2_stmt;

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
       
       Tab1Print('- Closing Cursor DMD2_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS')); 

       SectionPrint('DMD3_STMT - MRP_DEMAND_OM_RESERVATIONS_V');
       BRPrint;
       Tab1Print('- Opening Cursor DMD3_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR2_dmd3_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
    
       OPEN DMD3_stmt;
          LOOP
          FETCH DMD3_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
       LIMIT 500;
       
       Tab1Print('- Fetched: DMD3_STMT, rows: '|| to_char(dmd3_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
       BRPrint;
       Tab1Print('|----------------------- Supply/Demand -------------------------|');
       Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
       Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

       END LOOP;
       EXIT when DMD3_stmt%NOTFOUND;
       END LOOP;
       BRPrint;
       CLOSE DMD3_stmt;
       
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;

       Tab1Print('- Closing Cursor DMD3_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS')); 

          SectionPrint('DDJ_STMT - WIP_DISCRETE_JOBS/WIP_OPERATIONS');
          BRPrint;
          Tab1Print('- Opening Cursor DDJ_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));
       
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR3_ddj_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
                             
       OPEN ddj_stmt;
          LOOP
          FETCH ddj_stmt BULK COLLECT INTO
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
          LIMIT 500;
          
          Tab1Print('- Fetched: DDJ_STMT, rows: '|| to_char(DDJ_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          EXIT when ddj_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE ddj_stmt;
          
          IF upper(v_gen_trace) = 'Y' THEN
             EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
          END IF;

          Tab1Print('- Closing Cursor DDJ_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS')); 

          SectionPrint('DDJ2_STMT - WIP_DISCRETE_JOBS/WIP_REQUIREMENT_OPERATIONS');
          BRPrint;
          Tab1Print('- Opening Cursor DDJ2_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR4_ddj2_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

       OPEN DDJ2_stmt;
          LOOP
          FETCH DDJ2_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
          LIMIT 500;

          Tab1Print('- Fetched: DDJ2_STMT, rows: '|| to_char(DDJ2_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
          EXIT when DDJ2_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE DDJ2_stmt;
          
          IF upper(v_gen_trace) = 'Y' THEN
	     EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
	  END IF;

          Tab1Print('- Closing Cursor DDJ2_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS')); 

          SectionPrint('DRJ_STMT - WIP_REQUIREMENT_OPERATIONS/WIP_OPERATIONS/WIP_REPETITIVE_SCHEDULES');
          BRPrint;
          Tab1Print('- Opening Cursor DRJ_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));
       
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR5_drj_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

       OPEN DRJ_stmt;
          LOOP
          FETCH DRJ_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
          LIMIT 500;
      
          Tab1Print('- Fetched: DRJ_STMT, rows: '|| to_char(DRJ_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');
	  
          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );
	  
          END LOOP;
      
          EXIT when DRJ_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE DRJ_stmt;

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor DRJ_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       SectionPrint('DRJ2_STMT - WIP_REPETITVE_SCHEDULES/WIP_REQUIREMENT_OPERATIONS');
       BRPrint;
       Tab1Print('- Opening Cursor DRJ2_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR6_drj2_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

       OPEN drj2_stmt;
       LOOP
       FETCH drj2_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
       LIMIT 500;
      
       Tab1Print('- Fetched: DRJ2_STMT, rows: '|| to_char(DRJ2_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
       BRPrint;
       Tab1Print('|----------------------- Supply/Demand -------------------------|');
       Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
       Tab1Print(' ---------------- ----------- -------- -------- ----------------');

       FOR j IN 1..rsv_type.COUNT
       LOOP
         SELECT to_date(osd_date(j),'j')
         INTO reqt_date
         FROM DUAL;

         Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                   lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                   lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                   lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                   lpad(to_char(reqt_date),16,' ')
                  );
                  
       END LOOP;  
	         
       EXIT when drj2_stmt%NOTFOUND;
       END LOOP;
       BRPrint;
       CLOSE drj2_stmt;
       
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
  
       Tab1Print('- Closing Cursor DRJ2_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('DUD_STMT - MTL_USER_DEMAND');
          BRPrint;
          Tab1Print('- Opening Cursor DUD_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR7_dud_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
       
          OPEN dud_stmt;
          LOOP
          FETCH dud_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
          LIMIT 500;

          Tab1Print('- Fetched: DUD_STMT, rows: '|| to_char(DUD_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
          
          EXIT when dud_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE dud_stmt;
          
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor DUD_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SOH1_STMT - MTL_ONHAND_QUANTITIES_DETAIL');
          BRPrint;
          Tab1Print('- Opening Cursor SOH1_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR8_soh1_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
    
          OPEN soh1_stmt;
          LOOP
          FETCH soh1_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
          LIMIT 500;

          Tab1Print('- Fetched: SOH1_STMT, rows: '|| to_char(SOH1_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
          
          EXIT when soh1_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE soh1_stmt;
          
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor SOH1_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SOH2_STMT - MTL_ONHAND_QUANTITIES_DETAIL');
          BRPrint;
          Tab1Print('- Opening Cursor SOH2_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR9_soh2_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

          OPEN soh2_stmt;
          LOOP
          FETCH soh2_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
          LIMIT 500;

          Tab1Print('- Fetched: SOH2_STMT, rows: '|| to_char(SOH2_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
          
          EXIT when soh2_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE soh2_stmt;
          
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor SOH2_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SPOIN_STMT - MTL_SUPPLY');
          BRPrint;
          Tab1Print('- Opening Cursor SPOIN_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR10_spoin_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
          
           OPEN spoin_stmt;
           LOOP
           FETCH spoin_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SPOIN_STMT, rows: '|| to_char(SPOIN_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when spoin_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE spoin_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor SPOIN_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SUD_STMT - MTL_USER_SUPPLY');
          BRPrint;
          Tab1Print('- Opening Cursor SUD_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR11_sud_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

           OPEN sud_stmt;
           LOOP
           FETCH sud_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SUD_STMT, rows: '|| to_char(SUD_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
          EXIT when sud_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE sud_stmt;
          
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor SUD_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SMPS_STMT - MRP_SCHEDULE_DESIGNATORS/MRP_SCHEDULE_DATES');
          BRPrint;
          Tab1Print('- Opening Cursor SMPS_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR12_smps_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

           OPEN smps_stmt;
           LOOP
           FETCH smps_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SMPS_STMT, rows: '|| to_char(SMPS_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
          EXIT when smps_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE smps_stmt;
          
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor SMPS_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SDJ_STMT - WIP_DISCRETE_JOBS');
          BRPrint;
          Tab1Print('- Opening Cursor SDJ_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR13_sdj_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

           OPEN sdj_stmt;
           LOOP
           FETCH sdj_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SDJ_STMT, rows: '|| to_char(SDJ_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
          EXIT when sdj_stmt%NOTFOUND;
          END LOOP;
          BRPrint;
          CLOSE sdj_stmt;
          
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
          
          Tab1Print('- Closing Cursor SDJ_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SDJ1_STMT - WIP_REQUIREMENT_OPERATIONS/WIP_DISCRETE_JOBS');
          BRPrint;  	                              
          Tab1Print('- Opening Cursor SDJ1_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR14_sdj1_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;

           OPEN sdj1_stmt;
           LOOP
           FETCH sdj1_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SDJ1_STMT, rows: '|| to_char(SDJ1_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when sdj1_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE sdj1_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor SDJ1_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SRJ_STMT - WIP_REPETITIVE_SCHEDULES WRS/WIP_REPETITIVE_ITEMS');
          BRPrint;
          Tab1Print('- Opening Cursor SRJ_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR15_srj_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
           
           OPEN srj_stmt;
           LOOP
           FETCH srj_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SRJ_STMT, rows: '|| to_char(SRJ_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when srj_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE srj_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor SRJ_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('DMO_STMT - MTL_TXN_REQUEST_LINES');
          BRPrint;
          Tab1Print('- Opening Cursor DMO_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR16_dmo_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
           
           OPEN dmo_stmt;
           LOOP
           FETCH dmo_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: DMO_STMT, rows: '|| to_char(DMO_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when dmo_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE dmo_stmt;

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor DMO_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('AMO_STMT - MTL_TXN_REQUEST_LINES/MTL_MATERIAL_TRANSACTIONS_TEMP');
          BRPrint;
          Tab1Print('- Opening Cursor AMO_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR17_amo_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
           
           OPEN amo_stmt;
           LOOP
           FETCH amo_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: AMO_STMT, rows: '|| to_char(AMO_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when amo_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE amo_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor AMO_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SMO_STMT - MTL_TXN_REQUEST_LINES');
          BRPrint;
          Tab1Print('- Opening Cursor SMO_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR18_smo_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
           
           OPEN smo_stmt;
           LOOP
           FETCH smo_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SMO_STMT, rows: '|| to_char(SMO_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when smo_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE smo_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor SMO_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('SFS_STMT - WIP_FLOW_SCHEDULES');
          BRPrint;
          Tab1Print('- Opening Cursor SFS_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR19_sfs_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
           
           OPEN sfs_stmt;
           LOOP
           FETCH sfs_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;

          Tab1Print('- Fetched: SFS_STMT, rows: '|| to_char(SFS_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when sfs_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE sfs_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor SFS_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

          SectionPrint('DFS_STMT - WIP_FLOW_SCHEDULES');
          BRPrint;
          Tab1Print('- Opening Cursor DFS_STMT at:' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));

       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET TRACEFILE_IDENTIFIER = ''INVSD_CUR20_dfs_stmt'''); 
          EXECUTE IMMEDIATE('ALTER SESSION SET EVENTS = ''10046 trace name context forever, level 12''');
       END IF;
           
           OPEN dfs_stmt;
           LOOP
           FETCH dfs_stmt BULK COLLECT INTO 
             rsv_type
            ,src_type
            ,trx_type
            ,src_id
            ,sd_type
            ,sd_qty
            ,osd_date
            ,sd_rowid
            ,sd_item
            ,sd_org
            ,sd_date
            ,src_name
           LIMIT 500;
          
          Tab1Print('- Fetched: DFS_STMT, rows: '|| to_char(DFS_stmt%ROWCOUNT) || ' at ' || to_char(sysdate,'dd-mon-rr hh24:mi:ss'));
          BRPrint;
          Tab1Print('|----------------------- Supply/Demand -------------------------|');
          Tab1Print(' Reservation Type Source Type Souce ID Quantity Requirement Date');
          Tab1Print(' ---------------- ----------- -------- -------- ----------------');

          FOR j IN 1..rsv_type.COUNT
          LOOP
            SELECT to_date(osd_date(j),'j')
            INTO reqt_date
            FROM DUAL;

            Tab1Print(lpad(to_char(rsv_type(j)),17,' ')|| ' ' ||
                      lpad(to_char(src_type(j)),11,' ')|| ' ' ||
                      lpad(to_char(src_id(j)),8,' ')  || ' ' ||
                      lpad(to_char(sd_qty(j)),8,' ')  || ' ' ||
                      lpad(to_char(reqt_date),16,' ')
                     );

          END LOOP;
       
           
           EXIT when dfs_stmt%NOTFOUND;
           END LOOP;
           BRPrint;
           CLOSE dfs_stmt;
           
       IF upper(v_gen_trace) = 'Y' THEN
          EXECUTE IMMEDIATE('ALTER SESSION SET SQL_TRACE=FALSE');
       END IF;
           
           Tab1Print('- Closing Cursor DRJ_STMT at: ' || to_char(sysdate,'DD-MON-RR HH24:MI:SS'));
    
    
    
    
    END;
 


  --  -------------------- Feedback ---------------------------- 
  --  BRPrint;
  --  Show_Footer('&v_testlongname', '&v_headerinfo');

  -- -------------------- Test Exception Section ------------------------- 
  EXCEPTION
    WHEN OTHERS THEN  -- exception section (block 2) for test code
      BRPrint;
      ErrorPrint(sqlerrm ||' occurred in test');
      ActionErrorPrint('Please report the above error to Oracle Support Services.');
      BRPrint;
  --  Show_Footer('&v_testlongname', '&v_headerinfo');
      BRPrint;
  END;  -- end (block 2), test code 

EXCEPTION
  WHEN OTHERS THEN   -- exceptions (block 1) for API and template code
    BRPrint;
    ErrorPrint(sqlerrm ||' occurred in test');
    ActionErrorPrint('Please report the above error to Oracle Support Services.');
    BRPrint;
  -- Show_Footer('&v_testlongname', '&v_headerinfo');
    BRPrint;
END;  -- end (block 1), API and template code 
/

Rollback;

REM  ==============SQL PLUS Environment setup===================
Spool off

PROMPT
PROMPT  =======================================================================
PROMPT  Please review the output file:  &v_spoolfilename
PROMPT  =======================================================================


