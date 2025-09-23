explain plan for
SELECT /*+ NO_CPU_COSTING */
       ROUND ((  (closuredate_servicetechnician)
               - CASE
                    WHEN (reassigneddate) > (assigneddate)
                       THEN (reassigneddate)
                    ELSE (assigneddate)
                 END
              ),
              2
             ),
       ROUND (  (  (closuredate_servicetechnician)
                 - CASE
                      WHEN (reassigneddate) > (assigneddate)
                         THEN (reassigneddate)
                      ELSE (assigneddate)
                   END
                )
              * 24,
              2
             )
  FROM bccd_complaintproduct_details
   WHERE complaintid = '8200477' AND complaintcode = 'KOL011215008200477-1';

