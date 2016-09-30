read -p "Enter SID: " SID;
read -p "Enter domain: " DOMAIN;
read -p "Enter sysPassword " sysPassword;
read -p "Enter systemPassword " systemPassword;
# read -p "Enter disk_mount" disk_label;
# read -p "Enter backup_disk_mount" backup_disk_mount;
disk_label="storage"
backup_disk_mount="backup"

CHARACTER="AL32UTF8"

sed -i "s/  ORACLE_HOME=.*/  ORACLE_HOME=\$ORACLE_BASE\/product\/10g/" /etc/profile.d/oracle.sh
sed -i "s/12cR1/10g/" /etc/profile.d/oracle.*           
sed -i "s/# NLS_LANG=.*/NLS_LANG=AMERICAN_AMERICA\.$CHARACTER/" /etc/profile.d/oracle.sh
sed -i "s/NLS_LANG=.*/NLS_LANG=AMERICAN_AMERICA\.$CHARACTER/" /etc/profile.d/oracle.sh

#AUTOSTART
sed -i "s/START_ORACLE_DB=.*/START_ORACLE_DB=\"yes\"/" /etc/sysconfig/oracle
sed -i "s/START_ORACLE_DB_LISTENER=.*/START_ORACLE_DB_LISTENER=\"yes\"/" /etc/sysconfig/oracle

MEMORY=`grep MemTotal /proc/meminfo | awk '{print $2}'`

PAGESIZE=`getconf PAGESIZE`
DB_MEM=$(($MEMORY*1024*90/100))
SHMMAX=$(($DB_MEM*110/100))
SHMALL=$(($DB_MEM/$PAGESIZE))
HOSTNAME=`uname -n`
SGA=$(($DB_MEM*85/100))
PGA=$(($DB_MEM*15/100))
BUFFERS_32K=$(($SGA*90/100))

echo "Pagesize is: $PAGESIZE"
echo "Memory for Oracle: $DB_MEM"
echo "SHMMAX is: $SHMMAX"
echo "SHMALL is: $SHMALL"
echo "SGA size is: $SGA"
echo "PGA is: $PGA"
echo "BUFFERS_32K is: $BUFFERS_32K"

sed -i "s/SHMMAX=.*/SHMMAX=$SHMMAX/" /etc/sysconfig/oracle
sed -i "s/SHMALL=.*/SHMALL=$SHMALL/" /etc/sysconfig/oracle


sed -i "s/ORACLE_SID=.*/ORACLE_SID=$SID/" /etc/profile.d/oracle.sh

mkdir -p /media/$disk_label/database/oracle/$SID/manage/conf/
rm -rf /opt/oracle/software/scripts*
wget -nc http://public.edss.ee/software/Linux/Oracle/scripts.tar.gz -P /opt/oracle/software
tar -xzf /opt/oracle/software/scripts.tar.gz -C /opt/oracle/software/
cp -R /opt/oracle/software/scripts /media/$disk_label/database/oracle/$SID/manage/conf/

#DEBUG
mkdir -p /media/$disk_label/database/oracle/$SID/manage/debug/adump
mkdir -p /media/$disk_label/database/oracle/$SID/manage/debug/bdump
mkdir -p /media/$disk_label/database/oracle/$SID/manage/debug/cdump
mkdir -p /media/$disk_label/database/oracle/$SID/manage/debug/dpdump
mkdir -p /media/$disk_label/database/oracle/$SID/manage/debug/udump
ln -s    /media/$disk_label/software/oracle/product/10g/network/log /media/$disk_label/database/oracle/$SID/manage/debug/network_log
ln -s    /media/$disk_label/software/oracle/product/10g/log /media/$disk_label/database/oracle/$SID/manage/debug/oracle_log
ln -s    /media/$disk_label/software/oracle/product/10g/network/admin /media/$disk_label/database/oracle/$SID/manage/debug/network

#CONF
mkdir -p /media/$disk_label/database/oracle/$SID/manage/conf/cfgtoollogs/dbca
mkdir -p /media/$disk_label/database/oracle/$SID/manage/conf/dbs
mkdir -p /media/$disk_label/database/oracle/$SID/manage/conf/scripts
mkdir -p /media/$disk_label/database/oracle/$SID/manage/conf/scripts/logs

#EX/IMP
mkdir -p /media/$disk_label/database/oracle/$SID/devel/export
mkdir -p /media/$disk_label/database/oracle/$SID/devel/import

#DATA
mkdir -p /media/$disk_label/database/oracle/$SID/data/main

#WORK
mkdir -p /media/$disk_label/database/oracle/$SID/data/arch
mkdir -p /media/$disk_label/database/oracle/$SID/data/flash_recovery_area

#BACKUP
mkdir -p /media/$backup_disk_mount/database/oracle/$SID/curr
mkdir -p /media/$backup_disk_mount/database/oracle/$SID/prev
mkdir -p /media/$backup_disk_mount/database/oracle/$SID/arch
mkdir -p /media/$backup_disk_mount/database/oracle/$SID/logs

#

setfacl -R -m d:u:oracle:rwx /media/$backup_disk_mount/database
setfacl -R -m d:g:oinstall:rwx /media/$backup_disk_mount/database
setfacl -R -m u:oracle:rwx /media/$backup_disk_mount/database
setfacl -R -m g:oinstall:rwx /media/$backup_disk_mount/database

setfacl -R -m d:u:oracle:rwx /media/$disk_label/database
setfacl -R -m d:g:oinstall:rwx /media/$disk_label/database
setfacl -R -m u:oracle:rwx /media/$disk_label/database
setfacl -R -m g:oinstall:rwx /media/$disk_label/database

setfacl -R -m d:u:oracle:rwx /media/$disk_label/software
setfacl -R -m d:g:oinstall:rwx /media/$disk_label/software
setfacl -R -m u:oracle:rwx /media/$disk_label/software
setfacl -R -m g:oinstall:rwx /media/$disk_label/software  

##SCRIPTS

cd /media/$disk_label/database/oracle/$SID/manage/conf/scripts/; rename 's/\.erb$//' *.erb

for files in /media/$disk_label/database/oracle/$SID/manage/conf/scripts/*.erb; do
     sed -i "s/<%= @disk_label %>/$disk_label/g" $files
     sed -i "s/<%= @sid %>/$SID/g" $files     
     sed -i "s/<%=  -%>//g" $files
     new_files=`echo ${files:0:-4}`
     mv $files $new_files
done

     sed -i "s/<%= @character %>/$CHARACTER/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/CreateDB.sql
     sed -i "s/<%= @sga %>/$SGA/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/init.ora
     sed -i "s/<%= @pga %>/$PGA/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/init.ora
     sed -i "s/<%= @buffers_32k %>/$BUFFERS_32K/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/init.ora
     sed -i "s/<%= @domain %>/$DOMAIN/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/init.ora
     sed -i "s/<%= @sysPassword %>/$sysPassword/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/db.sh
     sed -i "s/<%= @systemPassword %>/$systemPassword/" /media/$disk_label/database/oracle/$SID/manage/conf/scripts/db.sh  
     

##




mkdir -p /media/$disk_label/database/oracle/$SID/manage/conf/scripts/logs
chmod +x /media/$disk_label/database/oracle/$SID/manage/conf/scripts/db.sh



#su - oracle bash -c "/media/$disk_label/database/oracle/$SID/manage/conf/scripts/db.sh > /media/$disk_label/database/oracle/$SID/manage/conf/scripts/logs/db_initial.log"


cp /media/$disk_label/database/oracle/$SID/manage/conf/scripts/init.ora  /media/$disk_label/database/oracle/$SID/manage/conf/dbs/init.ora
mv /opt/oracle/product/10g/dbs/init$SID.ora  /opt/oracle/product/10g/dbs/init$SID_prev.ora 
ln -s /media/$disk_label/database/oracle/$SID/manage/conf/dbs/init.ora  /opt/oracle/product/10g/dbs/init$SID.ora 

mv /opt/oracle/product/10g/dbs/orapw$SID /opt/oracle/product/10g/dbs/orapw$SID_prev
ln -s /media/$disk_label/database/oracle/$SID/data/main/orapw$SID /opt/oracle/product/10g/dbs/orapw$SID



echo "$SID:/opt/oracle/product/10g:Y" > /etc/oratab
chown oracle /etc/oratab 
    
