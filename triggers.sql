select 'alter trigger '|| owner ||'.'|| trigger_name || ' enable ; ' from dba_triggers where status='DISABLED';
