#!/bin/bash
###
##BACULA ORACLE BACKUP SCRIPT - PRE
###

### OPTIONS VERIFICATION
if [[ -z "$1" ]]; then
        exit 1
fi

###~~~###~~~###CONSTANTS###~~~###~~~###
export ORACLE_SID=$1

export ORACLE_BASE=`cat /etc/profile.d/oracle.sh |grep "ORACLE_BASE="`
export ORACLE_HOME=`cat /etc/oratab |grep $ORACLE_SID:|awk -F: '{ print $2 }'`
export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
export ORA_NLS10=$ORACLE_HOME/nls/data
export PATH=/usr/local/bin:/usr/bin:/bin:$ORACLE_HOME/bin

BACKUP_PATH=/media/storage/backup/database/oracle/current/$ORACLE_SID
BACKUP_PATH_LAST=/media/storage/backup/database/oracle/previous/$ORACLE_SID
LOG_PATH=/media/storage/backup/database/oracle/logs
RMAN_CMF=$BACKUP_PATH/rman.cmf
RESERVED=15000000
###~~~###~~~###CONSTANTS###~~~###~~~###

mkdir -p $BACKUP_PATH
mkdir -p $BACKUP_PATH_LAST
mkdir -p $LOG_PATH

###1.PARAMS
  case  $ORACLE_HOME in
	'/opt/oracle/product/9ir2' )	ORA_VER=9;;
	'/opt/oracle/product/10g' )	ORA_VER=10;;
	* ) echo "Unsupported version" exit 0
	esac


###2.PREPARE
FREE_SPACE=$[ `df /media/storage/backup|grep "/dev"|awk -F" "  '{ print $4 }'` + $RESERVED]

DATAFILE_SIZE=`echo 'set echo off head off
select sum(bytes)/1024 from v\$datafile;
exit'|sqlplus -s -l "/ as sysdba"`



 if [ "$FREE_SPACE" -gt "$DATAFILE_SIZE" ]; then
    mkdir $BACKUP_PATH >> /dev/null 2>&1 
  else 
    cd /tmp && rm -rf $BACKUP_PATH_LAST >> /dev/null 2>&1 && sleep 30
    mkdir $BACKUP_PATH >> /dev/null 2>&1 
      if [ "$FREE_SPACE" -lt "$DATAFILE_SIZE" ]; then exit 1
         fi
  fi 
cd $BACKUP_PATH


###3.SQLPLUS
#DATAFILE

DATAFILE_LIST=$(sqlplus -s -l "/ as sysdba" <<EOF
set echo off head off
select 'copy datafile '||file#||' to ''$BACKUP_PATH/backup_'||substr(substr(name, instr(name,'/',-1)),2)||''';\n' from sys.v_\$datafile;
exit;
EOF)

#Flush redo
# FLUSH_REDO=$(sqlplus -s -l "/ as sysdba" <<EOF
# set echo off head off
# alter system archive log current;
# exit;
# EOF)

#ARCHIVE_MAX
ARCHIVE_MAX=`echo 'set echo off head off
select max(sequence#) from V\$ARCHIVED_LOG;
exit'|sqlplus -s -l "/ as sysdba"`

DELIMITER="'"

###4.RMAN CMD
echo "run {" >> $RMAN_CMF
echo "allocate channel c1 type disk;" >> $RMAN_CMF
echo "" >> $RMAN_CMF
echo -e $DATAFILE_LIST|grep "copy datafile" >> $RMAN_CMF
echo "" >> $RMAN_CMF
echo "sql 'alter system archive log current';" >> $RMAN_CMF
echo "sql \"create pfile=''`echo $BACKUP_PATH`/`echo $ORACLE_SID`.spfile'' from spfile\";" >> $RMAN_CMF
echo "sql \"alter database backup controlfile to ''`echo $BACKUP_PATH`/ctl_`echo $ORACLE_SID.ctl`''\";" >> $RMAN_CMF
echo "sql \"alter database backup controlfile to trace as ''`echo $BACKUP_PATH`/ctl.trace__`echo $ORACLE_SID`.ctl''\";" >> $RMAN_CMF

case  $ORA_VER in
	'9' )	echo ;;
	'10' )	echo "backup as copy archivelog from sequence `echo $ARCHIVE_MAX` format '`echo $BACKUP_PATH`/%h_%e_%a.dbf';">> $RMAN_CMF ;;
	* ) echo "Unsupported version" exit 0
	esac

echo "release channel c1;" >> $RMAN_CMF
echo "}" >> $RMAN_CMF
echo "exit" >> $RMAN_CMF

sed -i "s/\\\ n//" $RMAN_CMF
$ORACLE_HOME/bin/rman nocatalog target / msglog=$LOG_PATH/oracle_$ORACLE_SID.bkp_rman.log cmdfile=$RMAN_CMF >> /dev/null 2>&1 
exit 0
