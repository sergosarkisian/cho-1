read -p "Enter SID: " SID;

disk_label="storage"

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


sed -i "s/sga_target=.*/sga_target=$SGA/" /media/$disk_label/database/oracle/$SID/manage/conf/dbs/init.ora
sed -i "s/sga_max_size=.*/sga_max_size=$SGA/" /media/$disk_label/database/oracle/$SID/manage/conf/dbs/init.ora
sed -i "s/pga_aggregate_target=.*/pga_aggregate_target=$PGA/" /media/$disk_label/database/oracle/$SID/manage/conf/dbs/init.ora
sed -i "s/db_32k_cache_size=.*/db_32k_cache_size=$BUFFERS_32K/" /media/$disk_label/database/oracle/$SID/manage/conf/dbs/init.ora

