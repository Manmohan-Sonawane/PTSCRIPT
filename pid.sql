select sid from v$session ,v$process where addr=paddr and pid=&pid

/
