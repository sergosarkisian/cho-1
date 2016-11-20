#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


 ### MOUNTS  ###
#mounts
echo "LABEL=system           /          btrfs       rw,noatime,acl,nodatacow,autodefrag,recovery 1 1" > /etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /etc/fstab
#echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> /etc/fstab


in4 recipe self 5_service systemd mount add media-storage
in4 recipe self 5_service systemd mount add media-sysdata
in4 recipe self 5_service systemd mount enable media-sysdata
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
