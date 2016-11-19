#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### PROFILE.D ###
#CONF
rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/administrators.sh /etc/profile.d/ 
rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/power.sh /etc/profile.d/ 
rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/support.sh /etc/profile.d/ 
chmod 744 /etc/profile.d/*
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
