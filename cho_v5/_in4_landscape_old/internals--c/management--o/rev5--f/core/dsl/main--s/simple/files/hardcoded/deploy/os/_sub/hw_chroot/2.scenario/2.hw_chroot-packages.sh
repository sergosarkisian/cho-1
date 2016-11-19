#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force flashrom ipmiutil snapper snapper-zypp-plugin grub2-snapper-plugin yast2-snapper smartmontools hdparm dmidecode ntp dhcp dhcp-client kernel-firmware

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
