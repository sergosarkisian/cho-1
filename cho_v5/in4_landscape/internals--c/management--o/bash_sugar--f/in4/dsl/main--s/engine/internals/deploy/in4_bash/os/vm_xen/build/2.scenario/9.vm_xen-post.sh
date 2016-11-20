#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### XEN DOMU AUTONAMING  ###
#SYSTEMD
 rm -f  /etc/systemd/system/init_auto_xen.service && cp/media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/_sub/vm_xen/3.env/init_auto_xen.service /etc/systemd/system/
systemctl enable init_auto_xen
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
