#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### INIT_AUTO_HW  ###
#SYSTEMD
 rm -f  /etc/systemd/system/init_auto_hw.service && cp /media/sysdata/in4/cho/in4_core/deploy/os/_sub/hw_chroot/3.env/init_auto_hw.service /etc/systemd/system/
systemctl enable init_auto_hw
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
