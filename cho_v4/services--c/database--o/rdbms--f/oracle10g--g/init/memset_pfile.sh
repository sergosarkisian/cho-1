#!/bin/sh
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh os
. /media/storage/as/oracle/_manual/sid.sh

MEMORY=`grep MemTotal /proc/meminfo | awk '{print $2}'`

PAGESIZE=`getconf PAGESIZE`
DB_MEM=$(($MEMORY*1024*90/100))
SHMMAX=$(($DB_MEM*110/100))
SHMALL=$(($DB_MEM/$PAGESIZE))
SGA=$(($DB_MEM*80/100))
PGA=$(($DB_MEM*15/100))
BUFFERS_32K=$(($SGA*85/100))

echo "Pagesize is: $PAGESIZE"
echo "Memory for Oracle: $DB_MEM"
echo "SHMMAX is: $SHMMAX"
echo "SHMALL is: $SHMALL"
echo "SGA size is: $SGA"
echo "PGA is: $PGA"
echo "BUFFERS_32K is: $BUFFERS_32K"

sed -i "s/SHMMAX=.*/SHMMAX=$SHMMAX/" /etc/sysconfig/oracle
sed -i "s/SHMALL=.*/SHMALL=$SHMALL/" /etc/sysconfig/oracle

cp -f /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/pfile.ora /media/storage/as/oracle/sid/init$SID.ora
sed -i "s/sga_target=.*/sga_target=$SGA/" /media/storage/as/oracle/sid/init$SID.ora
sed -i "s/sga_max_size=.*/sga_max_size=$SGA/" /media/storage/as/oracle/sid/init$SID.ora
sed -i "s/pga_aggregate_target=.*/pga_aggregate_target=$PGA/" /media/storage/as/oracle/sid/init$SID.ora
sed -i "s/db_32k_cache_size=.*/db_32k_cache_size=$BUFFERS_32K/" /media/storage/as/oracle/sid/init$SID.ora
sed -i "s/{SID}/$SID/" /media/storage/as/oracle/sid/init$SID.ora
sed -i "s/{DOMAIN}/$Org.pool/" /media/storage/as/oracle/sid/init$SID.ora

echo "$SID:/media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s/product/10g:Y" > /etc/oratab
