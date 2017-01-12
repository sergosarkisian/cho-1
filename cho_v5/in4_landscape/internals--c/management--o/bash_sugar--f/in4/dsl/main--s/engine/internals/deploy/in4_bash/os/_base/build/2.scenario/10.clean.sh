#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

zypper mr -K -a
## zypper clean -a ## NOT COMP WITH OFFLINE 

### OS BUILD TAG ###
echo "#" > /etc/in4-release
echo "GitPath=$GitPath" >> $BuildEnv/loop/tmp/in4_env.sh
OsBuildDate=`date +"w"%W"y"%y`
echo "OsBuildDate=\"$OsBuildDate\"" >> /etc/in4-release
OsBuildDate=`date +%d.%m.%y_w%W_%H:%M:%S`
echo "OsBuildDateFull=\"$OsBuildDate\"" >> /etc/in4-release

OsBuildGitBranch=`git -C $GitPath rev-parse --abbrev-ref HEAD`
echo "OsBuildGitBranch=\"$OsBuildGitBranch\"" >> /etc/in4-release
OsBuildGitHash=`git -C $GitPath rev-parse HEAD`
echo "OsBuildGitHash=\"$OsBuildGitHash\"" >> /etc/in4-release
OsBuildGitHashShort=`git -C $GitPath rev-parse --short HEAD`
echo "OsBuildGitHashShort=\"$OsBuildGitHashShort\"" >> /etc/in4-release
echo "OsBuildGitTag=\"$OsBuildTag\"" >> /etc/in4-release
echo "#" >> /etc/in4-release

###

### RM ALL LOGS & TRACES ###
cd /
rm -rf  /media/sysdata/offline
rm /etc/resolv.conf ### BUG
rm /etc/sysconfig/proxy ### BUG
! rm -f /var/log/*/*
! rm -f /var/log/*.log
rm -f /root/.bash_history
rm -rf /tmp/*
history -c
exit 

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
