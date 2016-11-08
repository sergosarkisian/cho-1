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
rm -f /etc/systemd/system/in4__oracle10g.service 	&& cp  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms:f/oracle10g:g/_systemd/in4__oracle10g.service /etc/systemd/system/

###


###  ###
 zypper --non-interactive in unixODBC unixODBC-devel bison flex gcc make gcc-c++ pcre-devel zlib-devel patch m4 glibc binutils glibc-devel libaio1 libaio-devel libelf0 libelf1 libelf-devel numactl libtool libstdc++6 libstdc++-devel libgcc_s1 expat libopenssl-devel binutils-devel glibc-devel-32bit libaio-devel-32bit unixODBC-32bit libgthread-2_0-0-32bit gcc-32bit gcc-c++-32bit gcc48-32bit libgcc_s1-32bit glibc-32bit binutils-devel-32bit
 zypper --non-interactive in http://ftp.novell.com/partners/oracle/orarun-2.0-1.4.0.x86_64.rpm

###

###  ??  ###
sed -i "s/user:\\/opt\\/oracle:.*/user:\\/opt\\/oracle:\\/bin\\/bash/" /etc/passwd
echo "umask 022" > /opt/oracle/.bash_profile
###


###  ###
wget http://public.edss.ee/software/Linux/Oracle/oracle10.2.0.5EE_rev2.tar.gz
tar -xzf ./oracle10.2.0.5EE_rev2.tar.gz&
###


###  ###
setfacl -R -m d:u:oracle:rwx /media/backup/database
setfacl -R -m d:g:oinstall:rwx /media/backup/database
setfacl -R -m u:oracle:rwx /media/backup/database
setfacl -R -m g:oinstall:rwx /media/backup/database
setfacl -R -m d:u:oracle:rwx /media/storage/database
setfacl -R -m d:g:oinstall:rwx /media/storage/database
setfacl -R -m u:oracle:rwx /media/storage/database
setfacl -R -m g:oinstall:rwx /media/storage/database
setfacl -R -m d:u:oracle:rwx /media/storage/software
setfacl -R -m d:g:oinstall:rwx /media/storage/software
setfacl -R -m u:oracle:rwx /media/storage/software
setfacl -R -m g:oinstall:rwx /media/storage/software
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
