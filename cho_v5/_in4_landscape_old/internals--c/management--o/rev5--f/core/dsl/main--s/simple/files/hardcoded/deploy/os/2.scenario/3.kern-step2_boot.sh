#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

 ### DRACUT  ###
in4 recipe 2_init opensuse package add internals--c--linux_sys--o--boot--f--dracut--g--main--s
in4 cp internals--c--linux_sys--o--boot--f--dracut--g--main--s simple/dracut.conf-vm /etc/dracut.conf
 ### 
 
 ### GRUB2  ###
 in4 recipe 2_init opensuse package add internals--c--linux_sys--o--boot--f--grub2--g--main--s
in4 cp internals--c--linux_sys--o--boot--f--grub2--g--main--s simple/etc_default_grub--vm_xen /etc/default/grub
mkdir -p  /boot/grub2/
in4 cp internals--c--linux_sys--o--boot--f--grub2--g--main--s simple/boot_grub2_grub.cfg--xen-all  /boot/grub2/grub.cfg
 ### 
 

  ### BOOT, GRUB2 init ###
  
case $TYPE in
    "vm_xen") export _GRUB2_DISK=$LO_SYSTEM; export _GRUB2_DEFAULT_BOOT="ConeCenter - in4 - Xen - Domu - HVM"; in4 recipe 3_recipe in4_shell grub2_install.recipe.sh  ;;
    "hw_chroot") export _GRUB2_DISK=$IN4_BASEDISK; export _GRUB2_DEFAULT_BOOT="ConeCenter - in4 - HW"; in4 recipe 3_recipe in4_shell grub2_install.recipe.sh  ;;
    esac  
#DOUBLE
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
