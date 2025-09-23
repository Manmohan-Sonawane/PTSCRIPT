SELECT
   SID,
   USERNAME,
   ROUND(100 * TOTAL_USER_IO/TOTAL_IO,2) TOT_IO_PCT
FROM
   (SELECT 
      b.SID SID,
      nvl(b.USERNAME,p.NAME) USERNAME,
      SUM(VALUE) TOTAL_USER_IO
   FROM 
      sys.V_$STATNAME c,  
      sys.V_$SESSTAT a,
      sys.V_$SESSION b,
      sys.v_$bgprocess p
   WHERE 
      a.STATISTIC#=c.STATISTIC# and 
      p.paddr (+) = b.paddr and
      b.SID=a.SID and 
      c.NAME in ('physical reads','physical writes',
      'consistent changes','consistent gets',
      'db block gets','db block changes', 
      'physical writes direct',
      'physical reads direct',
      'physical writes direct (lob)',
      'physical reads direct (lob)') 
   GROUP BY 
      b.SID, nvl(b.USERNAME,p.name)),
   (select 
      sum(value) TOTAL_IO 
   from    
      sys.V_$STATNAME c, 
      sys.V_$SESSTAT a 
   WHERE   
      a.STATISTIC#=c.STATISTIC# and 
      c.NAME in ('physical reads','physical writes',
      'consistent changes',
      'consistent gets','db block gets',
      'db block changes',
      'physical writes direct',
      'physical reads direct',
      'physical writes direct (lob)',
      'physical reads direct (lob)'))
ORDER BY 
   3 ;

