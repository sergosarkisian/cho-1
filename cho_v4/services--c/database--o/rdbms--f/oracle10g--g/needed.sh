#!/bin/bash


### SNAPSHOTS ###
btrfs subvolume snapshot /media/storage/database /media/storage/snapshots/database/`date +%d.%m.%y_%H:%M:%S`
btrfs subvolume show  /media/storage/snapshots/database_devel/04.07.16_12\:26\:29|grep "Subvolume ID"|awk '{print $3}'

mkdir -p /media/storage/snapshots/as/oracle/
 btrfs subvolume snapshot  /media/storage/as/oracle/data
 
/media/storage/as/oracle/snapshots/data/daily/`date +%d.%m.%y_%H:%M:%S`
/media/storage/as/oracle/snapshots/data/weekly/`date +%d.%m.%y_%H:%M:%S`
###



ALC_PATH_ARR=`echo $ALC_PATH`
    for PATH in $ALC_PATH
        setfacl -m g::rx $PATH
        setfacl -m o::rx $PATH
    done
