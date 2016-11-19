#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### NSS ###
#CONF
 rm -f /etc/nsswitch.conf &&  ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/nss:g/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
