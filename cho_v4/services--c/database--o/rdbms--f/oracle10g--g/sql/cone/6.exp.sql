#########
 EXPORT
#########

col curscn format 99999999999999999999999
select to_char(dbms_flashback.get_system_change_number,'xxxxxxxxxxxxxxxxxxxxxx'),
dbms_flashback.get_system_change_number curscn from dual;

expdp SYSTEM schemas=E\$CORE directory=export FLASHBACK_SCN=42059512286 dumpfile=ecore_new.dump logfile=ecore_new.dump.log
expdp SYSTEM schemas=E\$TOCEAN directory=export FLASHBACK_SCN=33497565554 dumpfile=etocean.dump logfile=etocean.dump.log

#export NLS_LANG=AMERICAN_AMERICA.AL32UTF8; imp system BUFFER=10000000 RECORDLENGTH=64000 file=tocean_cc_21.06.dump3 FROMUSER=E\$TOCEAN TOUSER=E\$TOCEAN 
#export NLS_LANG=AMERICAN_AMERICA.AL32UTF8; time exp USERID=E\$TOCEAN BUFFER=10000000 RECORDLENGTH=64000 DIRECT=yes file=/media/storage/database/oracle/wk10/devel/export/tocean_cc_21.06.dump3
###cc_content

### LOGIN AS E$TOCEAN ###
create view v$cc_content_export as
select C.xmldata from cc_content c
