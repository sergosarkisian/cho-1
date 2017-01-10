#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
### IN4 BASH HEADER ###
set -e
. /media/storage/as/oracle/conf/_context/env.sh

! mv -f /usr/bin/realgcc /usr/bin/gcc-4.8

mkdir -p /media/storage/as/oracle/cone/locks
rm -rf /media/storage/as/oracle/cone/plsql_compile/ && mkdir -p /media/storage/as/oracle/cone/plsql_compile && cd /media/storage/as/oracle/cone/plsql_compile
wget http://public.edss.ee/software/Linux/Oracle/cone_locks_in4.tar.gz
tar -xzf ./cone_locks_in4.tar.gz

chown -R oracle:oinstall /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m u:oracle:rwx /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m d:u:oracle:rwx /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m g:oinstall:rwx /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m d:g:oinstall:rwx /media/storage/as/oracle/cone/plsql_compile

su - oracle -c "sqlplus -s -l \"/ as sysdba\" <<EOF
EXECUTE UTL_RECOMP.RECOMP_PARALLEL(NULL, 'E\$CORE');
exit;
EOF"

cp /usr/bin/gcc-4.8 /usr/bin/realgcc2
mv /usr/bin/gcc-4.8 /usr/bin/realgcc
cp /media/storage/as/oracle/cone/plsql_compile/bin/gcc /usr/bin/gcc-4.8 && chmod 755 /usr/bin/gcc-4.8

su - oracle -c "sqlplus -s -l \"E\\\$CORE/$App_c2dbconePassword\" <<EOF
alter session set plsql_compiler_flags=\"NATIVE\";
alter package lck compile;
alter package lckv compile;
alter package lck compile body;
BEGIN                                                                                                                                                                               
LCK.CLEAR(0);                                                                                                                                                                
END; 
/
exit;
EOF"

mv -f /usr/bin/realgcc /usr/bin/gcc-4.8

if ! [[ -f /media/storage/as/oracle/cone/locks/sfile ]]; then
    echo "!!! LOCKS COMPILATION FAILED !!!"
    exit 1
else
    echo "!!! LOCKS COMPILATION SUCCESSFULL !!!"    
fi

