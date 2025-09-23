select max(archived.sequence#) primary, max(applied.sequence#) standby, archived.thread# thread 
from v$archived_log archived, v$archived_log applied where archived.thread#=applied.thread# and 
archived.archived='YES' and applied.applied='YES'group by archived.thread#;
