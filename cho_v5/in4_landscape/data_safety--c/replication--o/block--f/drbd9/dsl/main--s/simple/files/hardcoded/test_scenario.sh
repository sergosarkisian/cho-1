#####
/tmp/disk_md5_sum.sh
#####
#!/bin/bash
umount  /media/storage
systemctl stop rev5__data_safety--c--replication--o--block--f--drbd9--g--up--s
mount -o ro /dev/disk/by-label/storage1 /media/storage

md5sum /media/storage/drbd_test/*
ls -l /media/storage/drbd_test/*
umount  /media/storage
systemctl restart rev5__data_safety--c--replication--o--block--f--drbd9--g--up--s

#####
/tmp/drbd_pri_up.sh
#####
#!/bin/bash
drbdadm primary all
mount /dev/drbd/by-disk/disk/by-label/storage1 /media/storage
systemctl restart disk_storage_makeio.service

#####
/tmp/drbd_pri_down.sh
#####
#!/bin/bash
systemctl stop disk_storage_makeio.service
sleep 2
umount  /media/storage
drbdadm secondary all

#####
/tmp/data_check.sh
#####
#!/bin/bash
while true; do 
    md5sum /media/storage/drbd_test/*
    ls -l /mediia/storage/drbd_test/*
    echo "\n"
    sleep 1
done


#####
/tmp/disk_storage_makeio.sh
#####

rm /media/storage/drbd_test/date
rm /media/storage/drbd_test/dd
sleep 1
sh -c /tmp/disk_storage_makeio--dd.sh&
sh -c /tmp/disk_storage_makeio--date.sh&
sleep 10000000


#####
/tmp/disk_storage_makeio--dd.sh
#####
while true; do 
    dd if=/dev/zero of=/media/storage/drbd_test/dd bs=1M count=10 oflag=direct
done

#####
/tmp/disk_storage_makeio--date.sh
#####
while true; do 
ls -l /media/storage/drbd_test
        date  >> /media/storage/drbd_test/date
        sleep 1
done 



###############
Views:
I) stat
    1) tailf /media/logs/syslog/hosts/*/08.04.2016/kernel/merged--3.plain|grep -i drbd
    2) atop -f -D 1
    3)  date
####
/tmp/2
####
while true; do 
        date
        sleep 1
done 


 
II) work
#bash

III) DRBD status - 

####
/tmp/1
####
while true; do 
    /sbin/drbdadm status all
    sleep 1
done



#########3
mount -o remount / /
mount -o remount /etc/ /etc/
mount -o remount /root/ /root/

