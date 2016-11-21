#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

 ### DRACUT  ###
in4func_run "internals--c--linux_sys--o--boot--f--dracut--g--main--s" "2_init/opensuse" "in4__main--s.package.zypper.sh"
in4func_cp "internals--c--linux_sys--o--boot--f--dracut--g--main--s" "simple/dracut.conf-vm" "/etc/dracut.conf"
 ### 
 
 ### GRUB2  ###
in4func_run "internals--c--linux_sys--o--boot--f--grub2--g--main--s" "2_init/opensuse" "in4__main--s.package.zypper.sh"
in4func_cp "internals--c--linux_sys--o--boot--f--grub2--g--main--s" "simple/etc_default_grub--vm_xen" "/etc/default/grub"
mkdir -p  /boot/grub2/
in4func_cp "internals--c--linux_sys--o--boot--f--grub2--g--main--s" "simple/boot_grub2_grub.cfg--xen-all"  "/boot/grub2/grub.cfg"
 ### 
 

  ### BOOT, GRUB2 init ###
  
case $DeployOsMode in
    "vm_xen") export _GRUB2_DISK=$LO_SYSTEM; export _GRUB2_DEFAULT_BOOT="ConeCenter - in4 - Xen - Domu - HVM"; in4func_run "internals--c--linux_sys--o--boot--f--grub2--g--main--s" "3_recipe/in4_shell" "grub2_install.recipe.sh"
  ;; ## BUG
    "hw_chroot") export _GRUB2_DISK=$IN4_BASEDISK; export _GRUB2_DEFAULT_BOOT="ConeCenter - in4 - HW"; in4func_run "internals--c--linux_sys--o--boot--f--grub2--g--main--s" "3_recipe/in4_shell" "grub2_install.recipe.sh"
  ;; ## BUG
    esac  
#DOUBLE
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
