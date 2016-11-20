#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


 ### MOUNTS  ###
#mounts
echo "LABEL=system           /          btrfs       rw,noatime,acl,nodatacow,autodefrag,recovery 1 1" > /etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /etc/fstab
#echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> /etc/fstab

in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "add" "mount" "media-storage"
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "add" "mount" "media-sysdata"
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "enable" "mount" "media-sysdata"
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
