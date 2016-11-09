#!/bin/bash

### ON HV ###
mkfs.btrfs  -L "storage" ./storage.raw 
###

### TMP ###
zypper ar -cf http://download.opensuse.org/repositories/filesystems/openSUSE_Leap_42.2/filesystems.repo
zypper --gpg-auto-import-keys dup
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


### ZYPPER  ###
 zypper --non-interactive in unixODBC unixODBC-devel bison flex gcc make gcc-c++ pcre-devel zlib-devel patch m4 glibc binutils glibc-devel libaio1 libaio-devel libelf0 libelf1 libelf-devel numactl libtool libstdc++6 libstdc++-devel libgcc_s1 expat libopenssl-devel binutils-devel glibc-devel-32bit libaio-devel-32bit unixODBC-32bit libgthread-2_0-0-32bit gcc-32bit gcc-c++-32bit gcc48-32bit libgcc_s1-32bit glibc-32bit binutils-devel-32bit
 zypper --non-interactive in http://ftp.novell.com/partners/oracle/orarun-2.0-1.4.0.x86_64.rpm
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
 btrfs subvolume create /media/storage/as/oracle/flash_recovery_area
 
 ##FIX!!!
setfacl -m g::rx  /media/storage/as/oracle
setfacl -m o::rx  /media/storage/as/oracle
setfacl -m g::rx  /media/storage/as
setfacl -m o::rx  /media/storage/as
##
###


### TS INIT  ###
mkdir -p /media/storage/ts/services--c/database--o/rdbms--f
btrfs subvolume create /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw

mkdir -p /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m u:oracle:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m d:u:oracle:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m g:oinstall:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m d:g:oinstall:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/

##FIX!!
setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f
setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f
setfacl -m g::rx  /media/storage/ts/services--c/database--o
setfacl -m o::rx  /media/storage/ts/services--c/database--o
setfacl -m g::rx  /media/storage/ts/services--c/
setfacl -m o::rx  /media/storage/ts/services--c/
setfacl -m g::rx  /media/storage/ts
setfacl -m o::rx  /media/storage/ts
##
###


### ORACLE INIT  - /etc ###
rm -f /etc/systemd/system/in4__oracle10g.service 	&& cp  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/_systemd/in4__oracle10g.service /etc/systemd/system/
rm -f  /etc/profile.d/oracle.sh && ln -s /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/profile.d_oracle.sh /etc/profile.d/oracle.sh
touch /etc/oratab && chown oracle:oinstall /etc/oratab && chmod 750 /etc/oratab
###



###  ??  ###
usermod -s /bin/bash oracle 
usermod -d /media/storage/as/oracle oracle 

chmod 755 /media/storage/as
setfacl -R -m u:oracle:rwx /media/storage/as/oracle
setfacl -R -m d:u:oracle:rwx /media/storage/as/oracle
setfacl -R -m g:oinstall:rwx /media/storage/as/oracle
setfacl -R -m d:g:oinstall:rwx /media/storage/as/oracle

echo "umask 022" > /opt/oracle/.bash_profile

###


### OLD ORACLE -> MIGRATE ###
mkdir -p /media/storage_old/_tmp/ && cd /media/storage_old/_tmp/
wget http://public.edss.ee/software/Linux/Oracle/oracle10.2.0.5EE_rev2.tar.gz
tar -xzf ./oracle10.2.0.5EE_rev2.tar.gz&
cp -R /media/storage_old/_tmp/software/oracle/product /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
#mkdir /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/in4/
#cp /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/* /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/in4/
 chown -R oracle:oinstall /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
###

### LOGGING SYMLINKS  ###
.

mkdir /media/storage/as/oracle/logs/rdbms /media/storage/as/oracle/logs/network

ln -s /media/storage/as/oracle/logs/startup.log /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/startup.log
ln -s /media/storage/as/oracle/logs/shutdown.log /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/shutdown.log

rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/log && ln -s /media/storage/as/oracle/logs/rdbms /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/log
rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/audit && ln -s /media/storage/as/oracle/logs/rdbms /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/audit

rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/log && ln -s  /media/storage/as/oracle/logs/network /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/log
rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/trace && ln -s  /media/storage/as/oracle/logs/network /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/trace

 rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/dbs &&  ln -s /media/storage/as/oracle/sid /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/dbs
### 


###  ###
###


###  ###
###


###  ###
###


###  ###
###

chown -R oracle:oinstall /media/storage/as/oracle

### CREATE RO SNAPSHOT  ###
btrfs subvolume delete /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
btrfs subvolume snapshot -r /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
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



ALC_PATH_ARR=`echo $ALC_PATH`
    for PATH in $ALC_PATH
        setfacl -m g::rx $PATH
        setfacl -m o::rx $PATH
    done

    The following 8 packages are going to be downgraded:
  bash bash-completion ksh libreadline6 systemd systemd-sysvinit udev util-linux

The following 8 packages are going to change vendor:
  bash              obs://build.opensuse.org/shells -> openSUSE         
  bash-completion   obs://build.opensuse.org/shells -> openSUSE         
  ksh               obs://build.opensuse.org/shells -> openSUSE         
  libreadline6      obs://build.opensuse.org/shells -> openSUSE         
  systemd           obs://build.opensuse.org/home:conecenter -> openSUSE
  systemd-sysvinit  obs://build.opensuse.org/home:conecenter -> openSUSE
  udev              obs://build.opensuse.org/home:conecenter -> openSUSE
  util-linux        obs://build.opensuse.org/home:conecenter -> openSUSE

    

