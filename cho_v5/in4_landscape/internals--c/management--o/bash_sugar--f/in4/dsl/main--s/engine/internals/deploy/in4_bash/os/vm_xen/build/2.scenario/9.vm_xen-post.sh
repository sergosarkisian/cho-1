#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### XEN DOMU AUTONAMING  ###
#SYSTEMD
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "add" "service" "init_auto_xen"
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "enable" "service" "init_auto_xen"
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
