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
  if [[ -d $ARCH_PATH/ && -d $BACKUP_PATH/ ]]; then
      cd /tmp && rsync  -azusSq $ARCH_PATH/ $BACKUP_PATH/
  fi 

exit 0