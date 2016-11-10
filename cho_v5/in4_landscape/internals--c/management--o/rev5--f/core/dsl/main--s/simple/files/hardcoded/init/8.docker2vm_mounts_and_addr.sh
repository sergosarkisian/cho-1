 ### MOUNTS  ###
#mounts
echo "LABEL=system           /          btrfs       rw,noatime,acl,nodatacow,autodefrag,recovery 1 1" > /etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /etc/fstab

 rm -f /etc/systemd/system/media-storage.mount && cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/mounts/media-storage.mount /etc/systemd/system/
 rm -f /etc/systemd/system/media-sysdata.mount && cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/mounts/media-sysdata.mount /etc/systemd/system/
 
systemctl enable media-sysdata.mount
###



### XEN DOMU AUTONAMING  ###
#SYSTEMD
 rm -f  /etc/systemd/system/init_auto_xen.service && cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/xen_domu/init_auto_xen.service /etc/systemd/system/
systemctl enable init_auto_xen
###
