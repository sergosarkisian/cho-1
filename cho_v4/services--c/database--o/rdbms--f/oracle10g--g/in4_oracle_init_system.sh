#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL, profiles
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
### IN4 BASH HEADER ###
set -e
PrevDirPath=$CurDirPath; CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="BEGIN -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

### TMP ###
! zypper ar -cf http://download.opensuse.org/repositories/filesystems/openSUSE_Leap_42.2/filesystems.repo
zypper --non-interactive  --gpg-auto-import-keys dup
###

### ZYPPER  ###
zypper --non-interactive in unixODBC unixODBC-devel bison flex gcc make gcc-c++ pcre-devel zlib-devel patch m4 glibc binutils glibc-devel libaio1 libaio-devel libelf0 libelf1 libelf-devel numactl libtool libstdc++6 libstdc++-devel libgcc_s1 expat libopenssl-devel binutils-devel glibc-devel-32bit libaio-devel-32bit unixODBC-32bit libgthread-2_0-0-32bit gcc-32bit gcc-c++-32bit gcc48-32bit libgcc_s1-32bit glibc-32bit binutils-devel-32bit
zypper --non-interactive in http://ftp.novell.com/partners/oracle/orarun-2.0-1.4.0.x86_64.rpm
! chkconfig oracle off
! rm /etc/init.d/oracle
#?? raw service
###


### ORACLE INIT  - /etc ###
rm -f /etc/systemd/system/in4__oracle10g.service && cp  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/_systemd/in4__oracle10g.service /etc/systemd/system/
rm -f  /etc/profile.d/oracle.sh && ln -s /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/profile.d_oracle.sh /etc/profile.d/oracle.sh
touch /etc/oratab && chown oracle:oinstall /etc/oratab && chmod 750 /etc/oratab
###


###  ORACLE USER & PERMS  ###
usermod -s /bin/bash oracle 
usermod -d /media/storage/as/oracle/home oracle 
###


### FIREWALL ###
rm -f /etc/sysconfig/SuSEfirewall2.d/services/in4__oracle10g && ln -s  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/_firewall/in4__oracle10g /etc/sysconfig/SuSEfirewall2.d/services/
###


### SNAPSHOT ###
btrfs quota enable /media/storage
. /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/in4_oracle_init_snap.sh
###

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
