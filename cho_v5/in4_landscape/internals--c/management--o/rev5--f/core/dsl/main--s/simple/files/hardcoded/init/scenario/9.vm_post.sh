#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### XEN DOMU AUTONAMING  ###
#SYSTEMD
 rm -f  /etc/systemd/system/init_auto_xen.service && cp /media/sysdata/in4/cho/in4_core/init/xen_domu/init_auto_xen.service /etc/systemd/system/
systemctl enable init_auto_xen
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
