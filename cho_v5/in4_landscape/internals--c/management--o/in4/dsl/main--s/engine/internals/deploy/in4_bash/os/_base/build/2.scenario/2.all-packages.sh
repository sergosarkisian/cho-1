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

 if [[ -z $OfflineDir ]]; then
    zypper  --gpg-auto-import-keys ref
    ZypperFlags=""
else
    echo "Offline mode, no refresh"
    ZypperFlags=" --no-refresh "
fi

    zypper --non-interactive $ZypperFlags in --force aaa_base kmod binutils
    zypper --non-interactive $ZypperFlags in --force net-tools iproute2 wicked-service dbus-1 strace
    zypper --non-interactive $ZypperFlags in --force  aaa_base-extras man man-pages kbd timezone
    zypper --non-interactive $ZypperFlags in --force  ca-certificates-mozilla
    zypper --non-interactive $ZypperFlags in --force btrfsprogs e2fsprogs sysfsutils quota
    zypper --non-interactive $ZypperFlags in --force yast2-security
    zypper --non-interactive $ZypperFlags in --force mc vim lsof less strace pwgen sysstat tcpdump
    zypper --non-interactive $ZypperFlags in --force bzip2 gzip p7zip unzip zip tar xz
    #MISC
    zypper --non-interactive $ZypperFlags in --force rsync subversion git telnet wget mailx
    zypper --non-interactive $ZypperFlags in --force curl expect  deltarpm

    #+ pam + policy*
    zypper --non-interactive $ZypperFlags --gpg-auto-import-keys dup

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
