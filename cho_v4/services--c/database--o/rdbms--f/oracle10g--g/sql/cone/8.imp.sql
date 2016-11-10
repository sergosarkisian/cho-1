
#########
 IMPORT
#########
## DROP VIEWS, PACKAGES, SEQUENCE, TYPE, !!!!!

impdp SYSTEM schemas=E\$CORE directory=export dumpfile=ecore.dump logfile=ecore.import.log table_exists_action=replace
impdp SYSTEM schemas=E\$TT directory=export dumpfile=etocean.dump logfile=etocean.import.log table_exists_action=replace


#SCHEMA & TBS remap
#  impdp SYSTEM schemas=E\$EPN directory=import dumpfile=02.08_eepn.dump logfile=eepn.import.log remap_schema=E\$EPN:E\$WEB REMAP_TABLESPACE=E\$EPN:E\$WEB
impdp E\$TT schemas=E\$MANN directory=import dumpfile=mann_22.04.16.dump logfile=bws_to_alc.import.log remap_schema=E\$MANN:E\$TT REMAP_TABLESPACE=E\$MANN:E\$TT

drop table E$TOCEAN.cc_content

#if OID problem - drop all of types owned by E$XML (login using e$XML)
