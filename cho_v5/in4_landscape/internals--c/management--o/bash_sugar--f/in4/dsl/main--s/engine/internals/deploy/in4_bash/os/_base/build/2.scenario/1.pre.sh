#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### PATHS ###
mkdir -p /media/sysdata /media/storage /media/sysdata/in4/
chmod 755 /media/ /media/storage /media/sysdata

#### BUG -MOUNT DISK BEFORE OR MK ON OTHER DISK	
mkdir -p /media/sysdata/linux_sys
 if [[ -L /var ]]; then rm -f /var; fi; mkdir -p /media/sysdata/linux_sys/var && cp -pR /var/* /media/sysdata/linux_sys/var ; rm -rf /var && ln -s /media/sysdata/linux_sys/var /var
 if [[ -L /root ]]; then rm -f /root; fi;  mkdir -p /media/sysdata/linux_sys/root && cp -pR /root/* /media/sysdata/linux_sys/root ; rm -rf /root && ln -s /media/sysdata/linux_sys/root /root
 if [[ -L /home ]]; then rm -f /home; fi;  mkdir -p /media/sysdata/linux_sys/home && rm -rf /home && ln -s /media/sysdata/linux_sys/home /home; chmod 755  /media/sysdata/linux_sys/home
 ! rm -r /var/tmp; ln -s /tmp /var/tmp
 ! rm -r /var/run; ln -s /run /var/run

### ZYPPER OFFLINE ###
if [[ -d /media/sysdata/offline/zypper/zypp_offline ]]; then
    sudo mkdir /var/cache/zypp_offline     
    sudo cp -r /media/sysdata/offline/zypper/zypp_offline /var/cache/zypp_offline/
fi

if [[ -d /media/sysdata/offline/zypper/repos.d ]]; then
    sudo mkdir /etc/zypp/repos.d_offline 
    sudo cp -r /media/sysdata/offline/zypper/repos.d/*  /etc/zypp/repos.d_offline/
    sudo sed -i 's/keeppackages=.*/keeppackages=1/g' /etc/zypp/repos.d_offline/*.repo
fi   

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
