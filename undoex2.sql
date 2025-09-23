select TO_CHAR(MIN(Begin_Time),'D-MON-YYYY HH24:MI:SS')
"Begin Time",
TO_CHAR(MAX(End_Time),'DD-MON-YYYY HH24:MI:SS')
"End Time",
SUM(Undoblks)    "Total Undo Blocks Used",
SUM(Txncount)    "Total Num Trans Executed",
MAX(Maxquerylen)  "Longest Query(in secs)",
MAX(Maxconcurrency) "Highest Concurrent Txn count",
SUM(Ssolderrcnt),
SUM(Nospaceerrcnt),
MAX(undoblks/((end_time-begin_time)*3600*24)) "UNDO_BLOCK_PER_SEC"
from V$UNDOSTAT;
