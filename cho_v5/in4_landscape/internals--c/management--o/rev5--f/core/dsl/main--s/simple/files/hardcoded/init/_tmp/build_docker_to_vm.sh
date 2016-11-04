
### REV5 - SYSTEMD ###
systemctl enable sshd
systemctl enable rev5_init_auto_xen
###
#######



 ### 
 
 ###  CP REV5 - BOOT, GRUB2###
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/etc_default_grub--vm_xen ./loop/etc/default/grub
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/dracut.conf-vm ./loop/etc/dracut.conf
#cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/51-wa_xenvm_blacklist.conf ./loop/etc/modprobe.d/
#Temp - not in svn
#echo "blacklist xen-blkfront" >  ./loop/etc/modprobe.d/51-block-xenvm_blacklist.conf


mkdir -p  ./loop/boot/grub2/
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/boot_grub2_grub.cfg--xen-all ./loop/boot/grub2/grub.cfg

## ADD MISC SW
#zypper
cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/zypp.conf loop/etc/zypp/zypp.conf
cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/zypper.conf loop/etc/zypp/zypper.conf
#++ profile.d
#
#
systemd = profile.d + conf
sssd =  conf + systemd service
sysctl = conf
atop =  profile.d + conf + systemd service
rsyslog = conf + systemd service
exim = conf
sshd = conf + systemd service + swf2
sudo =  conf
bash = conf
 ###
 
 profile.d + conf + systemd service + swf2 + 
 
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
echo "LABEL=system           /          btrfs       ro,noatime,acl,user_xattr 0 0" > ./loop/etc/fstab
echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> ./loop/etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> ./loop/etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> ./loop/etc/fstab

###
