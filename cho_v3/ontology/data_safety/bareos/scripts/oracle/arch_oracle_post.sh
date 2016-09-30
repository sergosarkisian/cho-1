#!/bin/bash
###
##BACULA ORACLE BACKUP SCRIPT - ARCHIVELOG
###
if [[ -z "$1" ]]; then
        exit 1
fi

###~~~###~~~###CONSTANTS###~~~###~~~###
export ORACLE_SID=$1

ARCH_PATH=/storage/arch/$ORACLE_SID
BACKUP_PATH=/storage/backup/oracle/arch/$ORACLE_SID

###~~~###~~~###CONSTANTS###~~~###~~~###

###1.PARAMS

###2.PREPARE

cd /tmp && find  $ARCH_PATH -mmin +1440 -type f -exec rm '{}'  \; >> /dev/null 2>&1 
cd /tmp && find  $BACKUP_PATH -mmin +1440 -type f -exec rm '{}'  \; >> /dev/null 2>&1 

chown -R oracle:oracle_backup  /storage/backup/oracle/arch/$ORACLE_SID
chmod -R 740  /storage/backup/oracle/arch/$ORACLE_SID
exit 0