#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### PATHS ###
mkdir -p /media/sysdata /media/storage /media/sysdata/in4/
chmod 755 /media/ /media/storage /media/sysdata

#### BUG -MOUNT DISK BEFORE OR MK ON OTHER DISK	
if [[ -L /var ]]; then rm -f /var; fi; mkdir -p /media/sysdata/linux_sys/var && cp -pR /var/* /media/sysdata/linux_sys/var ; rm -rf /var && ln -s /media/sysdata/linux_sys/var /var
if [[ -L /root ]]; then rm -f /root; fi;  mkdir -p /media/sysdata/linux_sys/root && cp -pR /root/* /media/sysdata/linux_sys/root ; rm -rf /root && ln -s /media/sysdata/linux_sys/root /root
if [[ -L /home ]]; then rm -f /home; fi;  mkdir -p /media/sysdata/linux_sys/home && rm -rf /home && ln -s /media/sysdata/linux_sys/home /home && chmod 755  /media/sysdata/linux_sys/home
! rm -r /var/tmp; ln -s /tmp /var/tmp
! rm -r /var/run; ln -s /run /var/run

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
