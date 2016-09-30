#!/bin/bash
###
##BACULA ORACLE BACKUP SCRIPT - PRE
###
if [[ -z "$1" ]]; then
        exit 1
fi

###~~~###~~~###CONSTANTS###~~~###~~~###
export ORACLE_SID=$1

BACKUP_PATH=/media/storage/backup/database/current/$ORACLE_SID
BACKUP_PATH_LAST=/media/storage/backup/database/previous/$ORACLE_SID
LOG_PATH=/media/storage/backup/database/logs
###~~~###~~~###CONSTANTS###~~~###~~~###

###1.PARAMS

###2.PREPARE
  if [ -d $BACKUP_PATH ]; then
    cd /tmp && rm -rf $BACKUP_PATH_LAST >> /dev/null 2>&1 
    cd /tmp && mv $BACKUP_PATH $BACKUP_PATH_LAST >> /dev/null 2>&1 
  fi 

cd /tmp && mv $LOG_PATH/oracle_$ORACLE_SID.bkp_rman.log $LOG_PATH/oracle_$ORACLE_SID.bkp_rman.log.`date +%Y%m%d-%H%M%S` >> /dev/null 2>&1 
cd /tmp && mv $LOG_PATH/oracle_$ORACLE_SID.bak_ctl.log  $LOG_PATH/oracle_$ORACLE_SID.bak_ctl.log.`date +%Y%m%d-%H%M%S` >> /dev/null 2>&1 

chown -R oracle:oracle_backup  /media/storage/backup/database/
chmod -R 740  /media/storage/backup/database/

exit 0