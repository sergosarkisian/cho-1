#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### SSHD ###
#ZYPPER
in4func_Zypper openssh
#SYSTEMD
rm -f /etc/systemd/system/in4__sshd.service 	&& cp  /media/sysdata/in4/cho/cho_v4/services--c/server:o/ssh:f/sshd:g/_systemd/in4__sshd.service /etc/systemd/system/
! systemctl stop sshd && systemctl disable sshd && systemctl mask sshd
systemctl enable in4__sshd
#SWF2
rm -f /etc/sysconfig/SuSEfirewall2.d/services/in4__sshd && ln -s  /media/sysdata/in4/cho/cho_v4/services--c/server:o/ssh:f/sshd:g/_firewall/in4__sshd /etc/sysconfig/SuSEfirewall2.d/services/
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
