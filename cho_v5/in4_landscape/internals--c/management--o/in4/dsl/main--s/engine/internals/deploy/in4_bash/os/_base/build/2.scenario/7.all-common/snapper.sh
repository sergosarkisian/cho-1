#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### SNAPPER ###
#ZYPPER
 if [[ -z $OfflineDir ]]; then
    zypper  --gpg-auto-import-keys ref
    ZypperFlags=""
else
    echo "Offline mode, no refresh"
    ZypperFlags=" --no-refresh "
fi
zypper  --gpg-auto-import-keys --non-interactive $ZypperFlags in --force snapper snapper-zypp-plugin yast2-snapper grub2-snapper-plugin
#CONF
#??
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
