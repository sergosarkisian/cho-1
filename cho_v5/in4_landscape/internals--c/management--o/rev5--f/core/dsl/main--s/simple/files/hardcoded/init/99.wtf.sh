systemctl daemon-reexec
umount /media/sysdata/linux_sys/home 
umount /media/sysdata/linux_sys/home 
umount /media/sysdata/linux_sys/root
umount /media/sysdata/linux_sys/root

mount -o remount /boot /boot
mount -o remount /etc /etc
mount -o remount /usr /usr

sed -i "s/set term xy/#set term xy/" /etc/inputrc 
