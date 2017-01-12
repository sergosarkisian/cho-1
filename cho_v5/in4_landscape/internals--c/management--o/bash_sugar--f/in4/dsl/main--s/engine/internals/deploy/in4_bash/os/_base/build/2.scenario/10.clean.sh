#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

zypper mr -K -a
## zypper clean -a ## NOT COMP WITH OFFLINE 

### OS BUILD TAG ###
echo "#" > /etc/in4-release

In4BuildWeek=`date +"w"%W"y"%y`
echo "In4BuildWeek=\"$In4BuildWeek\"" >> /etc/in4-release
In4BuildDate=`date +%d.%m.%y_w%W_%H:%M:%S`
echo "In4BuildDate=\"$In4BuildDate\"" >> /etc/in4-release

In4BuildGitBranch=`git rev-parse --abbrev-ref HEAD`
echo "In4BuildGitBranch=\"$In4BuildGitBranch\"" >> /etc/in4-release
In4BuildGitHash=`git rev-parse HEAD`
echo "In4BuildGitHash=\"$In4BuildGitHash\"" >> /etc/in4-release
In4BuildGitHashShort=`git rev-parse --short HEAD`
echo "In4BuildGitHashShort=\"$In4BuildGitHashShort\"" >> /etc/in4-release
In4BuildGitTag=`git name-rev --tags --name-only $(git rev-parse HEAD)`
echo "In4BuildGitTag=\"$In4BuildGitTag\"" >> /etc/in4-release
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
