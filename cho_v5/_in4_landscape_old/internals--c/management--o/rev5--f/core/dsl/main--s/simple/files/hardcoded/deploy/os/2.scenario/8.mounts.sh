#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


 ### MOUNTS  ###
#mounts
echo "LABEL=system           /          btrfs       rw,noatime,acl,nodatacow,autodefrag,recovery 1 1" > /etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /etc/fstab
#echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> /etc/fstab

 rm -f /etc/systemd/system/media-storage.mount && cp  /media/sysdata/in4/cho/in4_core/deploy/os/3.env/mounts/media-storage.mount /etc/systemd/system/
 rm -f /etc/systemd/system/media-sysdata.mount && cp  /media/sysdata/in4/cho/in4_core/deploy/os/3.env/mounts/media-sysdata.mount /etc/systemd/system/
 
systemctl enable media-sysdata.mount
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
