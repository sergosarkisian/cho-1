 ### MOUNTS  ###
#cp /media/sysdata/cho/cho_v3/ontology/linux_sys/systemd/mounts/-.mount loop/etc/systemd/system/
#cp /media/sysdata/cho/cho_v3/ontology/linux_sys/systemd/mounts/dev-disk-by\\\\x2dlabel-swap.swap loop/etc/systemd/system/
#cp /media/sysdata/cho/cho_v3/ontology/linux_sys/systemd/mounts/media-logs.mount loop/etc/systemd/system/
#mounts - old
echo "LABEL=system           /          btrfs       ro,noatime,acl,user_xattr 0 0" > ./loop/etc/fstab
echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> ./loop/etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> ./loop/etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> ./loop/etc/fstab
###



systemctl enable rev5_init_auto_xen
