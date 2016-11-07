
### REV5 - SYSTEMD ###
systemctl enable sshd
systemctl enable rev5_init_auto_xen
###
#######


## ADD MISC SW


 ###  CP REV5 ###
mkdir -p loop/etc/rev5/static
cp /media/sysdata/cho/cho_v3/ontology/linux_sys/suse-network/ifcfg-tmpl loop/etc/rev5/static/
cp /media/sysdata/cho/cho_v3/ontology/linux_sys/suse-network/hosts loop/etc/rev5/static/
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh  loop/etc/rev5/static/

cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/1.naming_auto_xen.sh  loop/etc/rev5/static/
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/2.svn_init.sh loop/etc/rev5/static/
rm -f  loop/etc/systemd/system/rev5_init_auto_xen.service && cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/_systemd/rev5_init_auto_xen.service loop/etc/systemd/system/
 ###
 
 ### MOUNTS  ###
#cp /media/sysdata/cho/cho_v3/ontology/linux_sys/systemd/mounts/-.mount loop/etc/systemd/system/
#cp /media/sysdata/cho/cho_v3/ontology/linux_sys/systemd/mounts/dev-disk-by\\\\x2dlabel-swap.swap loop/etc/systemd/system/
#cp /media/sysdata/cho/cho_v3/ontology/linux_sys/systemd/mounts/media-logs.mount loop/etc/systemd/system/
#mounts - old


###
