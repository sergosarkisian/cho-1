#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


### SFW2 ###
#ZYPPER
#ZYPPER
 if [[ -z $OfflineDir ]]; then
    zypper  --gpg-auto-import-keys ref
    ZypperFlags=""
else
    echo "Offline mode, no refresh"
    ZypperFlags=" --no-refresh "
fi
zypper  --gpg-auto-import-keys --non-interactive $ZypperFlags in --force SuSEfirewall2
#INIT
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_EXT=.*/FW_IGNORE_FW_BROADCAST_EXT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_INT=.*/FW_IGNORE_FW_BROADCAST_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_DMZ=.*/FW_IGNORE_FW_BROADCAST_DMZ=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_PROTECT_FROM_INT=.*/FW_PROTECT_FROM_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
#SYSTEMD
rm -f /etc/systemd/system/in4__SuSEfirewall2_i@.service 	&& cp  /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/sfw2:g/_systemd/in4__SuSEfirewall2_i@.service /etc/systemd/system/
rm -f /etc/systemd/system/in4__SuSEfirewall2_init_i@.service 	&& cp  /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/sfw2:g/_systemd/in4__SuSEfirewall2_init_i@.service /etc/systemd/system/
! systemctl stop SuSEfirewall2 && systemctl disable SuSEfirewall2 && systemctl mask SuSEfirewall2
! systemctl stop SuSEfirewall2_init && systemctl disable SuSEfirewall2_init && systemctl mask SuSEfirewall2_init
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
