#!/bin/bash
echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"


 ### MOUNTS  ###
#mounts
echo "LABEL=system           /          btrfs       rw,noatime,acl,nodatacow,autodefrag,recovery 1 1" > /etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /etc/fstab
#echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> /etc/fstab

 rm -f /etc/systemd/system/media-storage.mount && cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/mounts/media-storage.mount /etc/systemd/system/
 rm -f /etc/systemd/system/media-sysdata.mount && cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/mounts/media-sysdata.mount /etc/systemd/system/
 
systemctl enable media-sysdata.mount
###

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
