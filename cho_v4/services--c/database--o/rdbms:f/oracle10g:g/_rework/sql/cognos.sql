iptables -A INPUT -p tcp --destination-port 1521 -j DROP


create or replace directory export as '/db/export';

col curscn format 99999999999999999999999
select to_char(dbms_flashback.get_system_change_number,'xxxxxxxxxxxxxxxxxxxxxx'),
dbms_flashback.get_system_change_number curscn from dual;

expdp SYSTEM@cs.world FULL=Y directory=export FLASHBACK_SCN=127029184 dumpfile=cs.dump logfile=cs.dump.log

expdp SYSTEM@ccr.world FULL=Y directory=export FLASHBACK_SCN=242850575 dumpfile=ccr.dump logfile=ccr.dump.log

expdp SYSTEM@ccrtest.world FULL=Y directory=export FLASHBACK_SCN=157839526 dumpfile=ccrtest.dump logfile=ccrtest.dump.log



ALTER USER SYSTEM IDENTIFIED BY cognos;
ALTER USER SYSTEM IDENTIFIED BY VALUES '74EA8F7B60D36697' ACCOUNT UNLOCK;

impdp SYSTEM@ccr.world FULL=Y directory=import dumpfile=ccr.dump logfile=ccr.import.log table_exists_action=replace

select 
   dbms_metadata.get_ddl('USER', username) || '/' usercreate
from 
   dba_users;


begin dbms_stats.GATHER_DATABASE_STATS(); end;