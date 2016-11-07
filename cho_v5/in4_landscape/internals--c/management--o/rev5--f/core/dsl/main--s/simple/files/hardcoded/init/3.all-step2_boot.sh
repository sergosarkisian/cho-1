 ### DRACUT  ###
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/dracut.conf-vm ./loop/etc/dracut.conf
 ### 
 
 
 ### GRUB2  ###
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/etc_default_grub--vm_xen ./loop/etc/default/grub
mkdir -p  ./loop/boot/grub2/
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/boot_grub2_grub.cfg--xen-all ./loop/boot/grub2/grub.cfg
 ### 
 
 
 ### /dev/xvd* blacklisting   ###
#cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/51-wa_xenvm_blacklist.conf ./loop/etc/modprobe.d/
#Temp - not in svn
#echo "blacklist xen-blkfront" >  ./loop/etc/modprobe.d/51-block-xenvm_blacklist.conf
 ### 
