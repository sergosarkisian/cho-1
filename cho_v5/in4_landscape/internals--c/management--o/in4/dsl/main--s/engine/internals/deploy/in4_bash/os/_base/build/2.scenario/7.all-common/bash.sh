#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### BASH ###
#ZYPPER
 if [[ -z $OfflineDir ]]; then
    zypper  --gpg-auto-import-keys ref
    ZypperFlags=""    
else
    echo "Offline mode, no refresh"
    ZypperFlags=" --no-refresh "
fi
zypper --gpg-auto-import-keys --non-interactive $ZypperFlags in --force bash-completion
#CONF
#rm -f  /etc/bash.bashrc.local && ln -s  /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/bash/conf/bash.bashrc.local /etc/bash.bashrc.local
echo "for f in /etc/profile.d/in4__*; do test -s \$f;   source \$f; done" >>  /etc/bash.bashrc
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
