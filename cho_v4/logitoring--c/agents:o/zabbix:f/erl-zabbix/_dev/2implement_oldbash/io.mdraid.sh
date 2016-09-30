#!/bin/bash
###
##Monitoring - diskstats
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
STATURL="/sbin/mdadm"
CACHE_PREFIX="mdadm"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX_$DEVICE.cache"

###1.PREPARE
if [ -s "$CACHE" ]; then
        TIMECACHE=`stat -c"%Z" "$CACHE"`
else
        TIMECACHE=0
fi
if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
	DEVICE_MOD=`echo \`ls -l /dev/disk/by-label/$DEVICE\`| cut -d' ' -f11| sed s/'..\/..\/'//`
        $STATURL --detail /dev/$DEVICE_MOD > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
	'state') set -a  $(grep -i "State :" $CACHE); echo $3 ;;
	'active') set -a  $(grep -i "Active Devices :" $CACHE); echo $4 ;;
	'working') set -a  $(grep -i "Working Devices :" $CACHE); echo $4 ;;
	'failed') set -a  $(grep -i "Failed Devices :" $CACHE); echo $4 ;;
	'spare') set -a  $(grep -i "Spare Devices :" $CACHE); echo $4;;
	'events') set -a  $(grep -i "Events :" $CACHE); echo $3 ;;
	'update.time') set -a  $(grep -i "Update Time :" $CACHE); echo $7 ;;
	'rebuild.status') set -a  $(grep -i "Rebuild Status :" $CACHE); echo $3 ;;
           *) exit -1 ;;
esac

###4.ECHO METRIC
exit 0
##FINISH