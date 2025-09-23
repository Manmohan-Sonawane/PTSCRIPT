SELECT Start_Date,
       Start_Time,
       Num_Logs,
       Round(Num_Logs * (Vl.Bytes / (1024 * 1024)),
             2) AS Mbytes,
       Vdb.NAME AS Dbname
  FROM (SELECT To_Char(Vlh.First_Time,
                       'YYYY-MM-DD') AS Start_Date,
               To_Char(Vlh.First_Time,
                       'HH24') || ':00' AS Start_Time,
               COUNT(Vlh.Thread#) Num_Logs
          FROM V$log_History Vlh
         GROUP BY To_Char(Vlh.First_Time,
                          'YYYY-MM-DD'),
                  To_Char(Vlh.First_Time,
                          'HH24') || ':00') Log_Hist,
       V$log Vl,
       V$database Vdb
 WHERE Vl.Group# = 1
 ORDER BY Log_Hist.Start_Date,
          Log_Hist.Start_Time;

