#!/bin/bash
echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force flashrom ipmiutil snapper snapper-zypp-plugin grub2-snapper-plugin yast2-snapper smartmontools hdparm dmidecode ntp dhcp dhcp-client 

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
