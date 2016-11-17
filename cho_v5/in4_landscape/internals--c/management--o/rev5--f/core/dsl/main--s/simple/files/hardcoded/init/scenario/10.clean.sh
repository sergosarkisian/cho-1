#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### RM ALL LOGS & TRACES ###
rm -f /var/log/*/*
rm -f /var/log/*.log
rm -f /root/.bash_history
rm -rf /tmp/*
history -c
exit 

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
