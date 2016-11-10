#!/bin/bash
SCHEME=$1
mkdir -p /media/storage/as/oracle/logs/cone

if [[ -z $SCHEME ]]; then
    echo "set sheme name"
    exit 1
fi
SCHEME_LC=${SCHEME,,}
SCHEME_UC=${SCHEME^^}

sysPassword="qwe123"
ecorePassword="3edc4rfv"
exmlPassword="3edc4rfv"
eschemePassword="3edc4rfv"

sqlplus -s -l "/ as sysdba" <<EOF
set verify off
DEFINE scheme_lc = $SCHEME_LC
DEFINE scheme_uc = $SCHEME_UC
DEFINE sysPassword = $sysPassword
DEFINE systemPassword = $sysPassword
DEFINE ecorePassword = $ecorePassword
DEFINE exmlPassword = $exmlPassword
DEFINE eschemePassword = $eschemePassword

@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/8.grants.sql
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/9.stats.sql
exit;
EOF

