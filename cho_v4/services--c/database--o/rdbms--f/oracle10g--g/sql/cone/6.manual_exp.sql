
### SSH TO REMOTE SERVER  - > su - oracle ###

#e$core
expdp SYSTEM schemas=E\$CORE directory=export dumpfile=ecore_$(date +%Y_%m_%d_%H-%M-%S).expdp.dump logfile=ecore_export_$(date +%Y_%m_%d_%H-%M-%S).dump.log
#

#e$scheme
expdp SYSTEM schemas=E\$SCHEME directory=export dumpfile=eSCHEME_$(date +%Y_%m_%d_%H-%M-%S).expdp.dump logfile=eSCHEME_export_$(date +%Y_%m_%d_%H-%M-%S).dump.log
#

#e$scheme - CC
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8; exp USERID=E\$SCHEME TABLES=CC_CONTENT BUFFER=10000000 RECORDLENGTH=64000 DIRECT=yes file=/eSCHEME_cc_$(date +%Y_%m_%d_%H-%M-%S).exp.dump
#
