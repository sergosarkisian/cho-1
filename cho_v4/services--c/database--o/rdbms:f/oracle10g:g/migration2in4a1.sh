#!/bin/bash

### ON HV ###
mkfs.btrfs  -L "storage" ./storage.raw 
###

### TMP ###
zypper ar -cf http://download.opensuse.org/repositories/filesystems/openSUSE_Leap_42.1/filesystems.repo
zypper dup
###

### MOUNTS ###
zypper in ocfs2-tools
fsck.ocfs2 /dev/sdf
tunefs.ocfs2 -L "storage_old" /dev/sdf
mkdir /media/storage_old
mount /dev/disk/by-label/storage_old -o inode64,rw,noatime,acl /media/storage_old

mkfs.btrfs  -L "storage" /dev/sdd
mount /dev/disk/by-label/storage -o nodatacow,noatime,autodefrag,recovery /media/storage
# ?? skip_balance
###


### APP INIT  ###
mkdir -p /media/storage/app/in4--c/database--o
btrfs subvolume create /media/storage/app/in4--c/database--o/oracle10g--f/
###


### AS INIT  ###
mkdir -p /media/storage/as
 btrfs subvolume create /media/storage/as/oracle
 btrfs subvolume create /media/storage/as/oracle/data
 btrfs subvolume create /media/storage/as/oracle/archive
 btrfs subvolume create /media/storage/as/oracle/cone
 btrfs subvolume create /media/storage/as/oracle/logs
 btrfs subvolume create /media/storage/as/oracle/dumps
 btrfs subvolume create /media/storage/as/oracle/sid
 btrfs subvolume create /media/storage/as/oracle/tmp
###


### SID DATA  ###
mkdir -p /media/storage/database/oracle/wk10
btrfs subvolume create /media/storage/database/oracle/wk10/devel
btrfs subvolume create /media/storage/database/oracle/wk10/manage
btrfs subvolume create /media/storage/database/oracle/wk10/cone
###


### TS INIT  ###
mkdir -p /media/storage/ts/services--c/database--o/rdbms--f
btrfs subvolume create /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
###


### CREATE RO SNAPSHOT  ###
btrfs subvolume delete /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
btrfs subvolume snapshot -r  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
###


### ORACLE INIT  ###
###


###  ###
###

###  ###
###


###  ###
###


###  ###
###



####

### SNAPSHOTS ###
btrfs subvolume snapshot /media/storage/database /media/storage/snapshots/database/`date +%d.%m.%y_%H:%M:%S`
btrfs subvolume show  /media/storage/snapshots/database_devel/04.07.16_12\:26\:29|grep "Subvolume ID"|awk '{print $3}'

mkdir -p /media/storage/snapshots/as/oracle/
 btrfs subvolume snapshot  /media/storage/as/oracle/data
 
/media/storage/as/oracle/snapshots/data/daily/`date +%d.%m.%y_%H:%M:%S`
/media/storage/as/oracle/snapshots/data/weekly/`date +%d.%m.%y_%H:%M:%S`
###
