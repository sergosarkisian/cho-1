##  COPY ALL FILES TO expdp import dir

## DROP VIEWS, PACKAGES, SEQUENCE, TYPE, !!!!!
## DROP USERS FROM OLD IMPORTS !!!!!


#e$core
impdp SYSTEM schemas=E\$CORE directory=import dumpfile=ecore_....expdp.dump logfile=ecore_import_$(date +%Y_%m_%d_%H-%M-%S).dump.log
#

#e$scheme
impdp SYSTEM schemas=E\$SCHEME directory=import dumpfile=eSCHEME_.....expdp.dump logfile=eSCHEME_import_$(date +%Y_%m_%d_%H-%M-%S).dump.log
#SCHEMA & TBS remap - "remap_schema=E\$SRC:E\$DST REMAP_TABLESPACE=E\$SRC:E\$DST"
#

#e$scheme - CC
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8; imp system FROMUSER=E\$SCHEME TOUSER=E\$SCHEME  BUFFER=10000000 RECORDLENGTH=64000 DIRECT=yes file=/eSCHEME_cc_$(date +%Y_%m_%d_%H-%M-%S).exp.dump
#


#if OID problem - drop all of types owned by E$XML (login using e$XML)
