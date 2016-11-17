#!/bin/bash
echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

### INIT_AUTO_HW  ###
#SYSTEMD
 rm -f  /etc/systemd/system/init_auto_hw.service && cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/hw/init_auto_hw.service /etc/systemd/system/
systemctl enable init_auto_hw
###

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
