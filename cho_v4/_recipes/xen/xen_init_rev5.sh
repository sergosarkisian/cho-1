  ##########
  
## REPO & SW ##
#zypper ar -cf http://download.opensuse.org/repositories/filesystems/openSUSE_42.1/filesystems.repo
#zypper in openvswitch openvswitch-switch xen xen-libs xen-tools qemu qemu-kvm qemu-tools btrfsmaintenance btrfsprogs ocfs2-tools 

## RAID ##
  zypper in http://public.edss.ee/software/Linux/HW/storcli-1.17.08-1.noarch.rpm
##
##


## DISKS, PARTITIONS & FS ##
# parted --script /dev/sdX mklabel gpt
#parted --script --align optimal /dev/sdX mkpart primary 0% 50%
#parted --script --align optimal /dev/sdx mkpart primary 50% 100%

#=>> "Linux filesystem", not "Microsoft basic data"

#mkfs.ocfs2 -b 4KB -C 1MB -N 1 -T vmstore -L "storage1" --fs-features=local,backup-super,sparse,unwritten,inline-data,metaecc,refcount,xattr,indexed-dirs,discontig-bg /dev/sdX1
#mkfs.ocfs2 -b 4KB -C 1MB -N 1 -T vmstore -L "storage2" --fs-features=local,backup-super,sparse,unwritten,inline-data,metaecc,refcount,xattr,indexed-dirs,discontig-bg /dev/sdX2
##


## FSTAB, MOUNT ##
mkdir /media/storage1
mkdir /media/storage2
echo "LABEL=storage1        /media/storage1       ocfs2      inode64,localalloc=2048,rw,nosuid,noexec,noatime,acl 1 1" >> /etc/fstab
echo "LABEL=storage2        /media/storage2       ocfs2      inode64,localalloc=2048,rw,nosuid,noexec,noatime,acl 1 1" >> /etc/fstab
mount -a
##


## USERS & GROUPS
groupadd --gid 1910 vmadmin
useradd --uid 1910 -g vmadmin -d /home/vmadmin vmadmin
## HV cross-server key auth
##


## DIRECTORIES ##

#STORAGE 1
mkdir -p \
/media/storage1 \
/media/storage1/images/\!master \
/media/storage1/images/infrastructure \
/media/storage1/images/rev5 \
/media/storage1/templates \
/media/storage1/snapshots \
/media/storage1/iso;

chown -R vmadmin:vmadmin /media/storage1
setfacl -R -m d:u:vmadmin:rwx /media/storage1
setfacl -R -m d:g:vmadmin:rwx /media/storage1
setfacl -R -m u:vmadmin:rwx /media/storage1         
setfacl -R -m g:vmadmin:rwx /media/storage1    

#STORAGE 2
mkdir -p \
/media/storage2 \
/media/storage2/images/\!master \
/media/storage2/images/infrastructure \
/media/storage2/images/rev5 \
/media/storage2/templates \
/media/storage2/snapshots \
/media/storage2/iso;

chown -R vmadmin:vmadmin /media/storage2
setfacl -R -m d:u:vmadmin:rwx /media/storage2
setfacl -R -m d:g:vmadmin:rwx /media/storage2
setfacl -R -m u:vmadmin:rwx /media/storage2         
setfacl -R -m g:vmadmin:rwx /media/storage2    
##


## GRUB ##
 rm -f /etc/dracut.conf && ln -s /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/dracut.conf-xen_dom0 /etc/dracut.conf
 rm -f /etc/default/grub && ln -s /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/etc_default_grub--hv_xen /etc/default/grub
 rm -f  /boot/grub2/grub.cfg && ln -s /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/boot_grub2_grub.cfg--xen /boot/grub2/grub.cfg
 #edit /etc/default/grub according to HV HW parameters
##

## XEN  - Defaults ##
rm -f /etc/xen/xl.conf && ln -s /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/dsl/main--s/simple/files/hardcoded/xl.conf /etc/xen/xl.conf
rm -f /etc/systemd/system/rev5_vm_i@.service && ln -s  /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/dsl/main--s/simple/files/hardcoded/_systemd/rev5_vm_i@.service /etc/systemd/system/
##


## VIF - OVS ##
rm -f /etc/xen/scripts/vif-ovs  && ln -s /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/dsl/main--s/simple/files/hardcoded/scripts/vif-ovs /etc/xen/scripts/
rm -f /etc/xen/scripts/ovs-openflow  && ln -s /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/dsl/main--s/simple/files/hardcoded/scripts/ovs-openflow /etc/xen/scripts/
##

## OPENVSWITCH - INIT ##
systemctl disable openvswitch.service && systemctl stop openvswitch.service
rm -f /etc/systemd/system/rev5__services--c--virtualization--o--network--f--openvswitch--g--main--s.service && ln -s /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/network--f/openvswitch/rev5/5_service/systemd/rev5__services--c--virtualization--o--network--f--openvswitch--g--main--s.service /etc/systemd/system/
systemctl enable /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/network--f/openvswitch/rev5/5_service/systemd/rev5__services--c--virtualization--o--network--f--openvswitch--g--main--s.service && systemctl restart rev5__services--c--virtualization--o--network--f--openvswitch--g--main--s

/usr/bin/ovs-vsctl --may-exist add-br vlannet
/usr/bin/ovs-vsctl --may-exist add-port vlannet bond_vlannet
## 


## XEN - dom0 init service ##
rm -f /etc/xen/scripts/dom0_init.sh  && ln -s /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/dsl/main--s/simple/files/hardcoded/scripts/dom0_init.sh /etc/xen/scripts/
rm -f /etc/systemd/system/rev5__services--c--virtualization--o--vm--f--xen--g--dom0_init && ln -s /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/rev5/5_service/systemd/rev5__services--c--virtualization--o--vm--f--xen--g--dom0_init--s.service /etc/systemd/system/
systemctl enable /media/sysdata/rev5/techpool/rev5a1/products/services--c/virtualization--o/vm--f/xen/rev5/5_service/systemd/rev5__services--c--virtualization--o--vm--f--xen--g--dom0_init--s.service
systemctl restart rev5__services--c--virtualization--o--vm--f--xen--g--dom0_init--s
## 






## NETWORK ##

#insert to /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="MAC_OF", ATTR{type}=="1",  NAME="man1"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="MAC_OF", ATTR{type}=="1",  NAME="man2"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="MAC_OF", ATTR{type}=="1",  NAME="vlannet1"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="MAC_OF", ATTR{type}=="1",  NAME="vlannet2"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="MAC_OF", ATTR{type}=="1",  NAME="vlannet3"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="MAC_OF", ATTR{type}=="1",  NAME="vlannet4"

cp /etc/udev/rules.d/70-persistent-net.rules /etc/udev/70-persistent-net.rules.back

# CONFIGURE IP FOR MANAGEMENT
# REBOOT, RISK OF NET/IP CHANGE
# CREATE BOND - copy from working HV - /etc/sysconfig/network/ifcfg-bond_vlannet, edit
##

# firewall
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_xen-vnc && ln -s /media/sysdata/rev5/techpool/ontology/virtualization/xen/_firewall/rev5_xen-vnc /etc/sysconfig/SuSEfirewall2.d/services/
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_xen-spice && ln -s /media/sysdata/rev5/techpool/ontology/virtualization/xen/_firewall/rev5_xen-spice /etc/sysconfig/SuSEfirewall2.d/services/


## HV PORT INIT ##
/usr/bin/ovs-vsctl --may-exist add-port vlannet hv tag=XXX -- set interface hv type=internal
ip link set hv up
ip link set hv mtu 9000
#add ip to sysconfig/network
##

sh  


### DOWNLOAD BASE IMAGES ###
mkdir -p /media/storage1/images/\!master/openSUSE-Tumbleweed/
#leap docker image
dockerImage=`curl -s http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-Tumbleweed/images/ --list-only|grep ".tar.xz"|sed -e "s/.*.<a href=\"//" -e "s/.mirrorlist.*//"`; wget http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-Tumbleweed/images/$dockerImage -O /media/storage1/images/\!master/openSUSE-Tumbleweed/openSUSE-Tumbleweed.docker.tar.gz

current rev1-2k12-w image

###

