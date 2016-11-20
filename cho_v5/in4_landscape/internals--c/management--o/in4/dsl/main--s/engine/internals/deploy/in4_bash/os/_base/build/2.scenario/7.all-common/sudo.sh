#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### SUDO ###
#ZYPPER
 if [[ -z $OfflineDir ]]; then
    zypper  --gpg-auto-import-keys ref
    ZypperFlags=""
else
    echo "Offline mode, no refresh"
    ZypperFlags=" --no-refresh "
fi
zypper  --gpg-auto-import-keys --non-interactive $ZypperFlags in --force sudo
#CONF
rm -f /etc/sudoers && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/security:f/sudo--g/etc_sudoers /etc/sudoers
echo -e "localadmin     ALL=(ALL) ALL" > /etc/sudoers.d/localadmin
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
