#!/bin/sh
. /media/sysdata/in4/cho/in4_core/internals/naming/naming.sh os
. /media/storage/as/oracle/conf/_context/env.sh

MEMORY=`grep MemTotal /proc/meminfo | awk '{print $2}'`

PAGESIZE=`getconf PAGESIZE`
DB_MEM=$(($MEMORY*1024*90/100))
SHMMAX=$(($DB_MEM*110/100))
SHMALL=$(($DB_MEM/$PAGESIZE))

if [[ -z $SgaPercentFromDBMEM ]]; then SgaPercentFromDBMEM=80; fi

if [[ -z $PgaFixedMemoryGB ]]; then
    if [[ -z $PgaPercentFromDBMEM ]]; then PgaPercentFromDBMEM=15; fi
    SGA=$(($DB_MEM*$SgaPercentFromDBMEM/100))
    PGA=$(($DB_MEM*$PgaPercentFromDBMEM/100))
else
    PGA=$(($PgaFixedMemoryGB*1024*1024*1024))
    DBMEM_Wo_PGA=$(($DB_MEM-$PGA))
    SGA=$(($DBMEM_Wo_PGA*$SgaPercentFromDBMEM/100))    
fi

if [[ -z $Buffers_32KPercentFromSGA ]]; then Buffers_32KPercentFromSGA=85; fi
BUFFERS_32K=$(($SGA*$Buffers_32KPercentFromSGA/100))    


echo "Pagesize is: $PAGESIZE"
echo "Memory for Oracle: $DB_MEM"
echo "SHMMAX is: $SHMMAX"
echo "SHMALL is: $SHMALL"
echo "SgaPercentFromDBMEM is: $SgaPercentFromDBMEM"
echo "SGA size is: $SGA"
echo "PgaPercentFromDBMEM is: $PgaPercentFromDBMEM"
echo "PGA is: $PGA"
echo "Buffers_32KPercentFromSGA is: $Buffers_32KPercentFromSGA"
echo "BUFFERS_32K is: $BUFFERS_32K"

sed -i "s/SHMMAX=.*/SHMMAX=$SHMMAX/" /etc/sysconfig/oracle
sed -i "s/SHMALL=.*/SHMALL=$SHMALL/" /etc/sysconfig/oracle

cp -f /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/pfile.ora /media/storage/as/oracle/conf/_generated/init$SID.ora
sed -i "s/sga_target=.*/sga_target=$SGA/" /media/storage/as/oracle/conf/_generated/init$SID.ora
sed -i "s/sga_max_size=.*/sga_max_size=$SGA/" /media/storage/as/oracle/conf/_generated/init$SID.ora
sed -i "s/pga_aggregate_target=.*/pga_aggregate_target=$PGA/" /media/storage/as/oracle/conf/_generated/init$SID.ora
sed -i "s/db_32k_cache_size=.*/db_32k_cache_size=$BUFFERS_32K/" /media/storage/as/oracle/conf/_generated/init$SID.ora
sed -i "s/{SID}/$SID/" /media/storage/as/oracle/conf/_generated/init$SID.ora
sed -i "s/{DOMAIN}/$Org.pool/" /media/storage/as/oracle/conf/_generated/init$SID.ora

echo "$SID:/media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s/product/10g:Y" > /etc/oratab
