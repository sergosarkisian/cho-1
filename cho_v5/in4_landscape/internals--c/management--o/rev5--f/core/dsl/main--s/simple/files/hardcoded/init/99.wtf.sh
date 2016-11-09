systemctl daemon-reexec
umount /media/sysdata/linux_sys/home 
umount /media/sysdata/linux_sys/home 
umount /media/sysdata/linux_sys/root
umount /media/sysdata/linux_sys/root

mount -o remount /boot /boot
mount -o remount /etc /etc
mount -o remount /usr /usr

sed -i "s/set term xy/#set term xy/" /etc/inputrc 

cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/wtf/wickedd-dhcp /usr/lib/systemd/system/wickedd-auto4.service
cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/wtf/wickedd-dhcp /usr/lib/systemd/system/wickedd-dhcp4.service
systemctl disable wickedd-dhcp6
systemctl mask wickedd-dhcp6
