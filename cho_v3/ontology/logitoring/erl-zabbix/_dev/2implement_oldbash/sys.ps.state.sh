#!/bin/bash
###
##Monitoring - systiming
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
STATURL="/bin/ps axo state="
CACHE_PREFIX="ps.state"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX-`echo $STATURL | md5sum | cut -d" " -f1`.cache"

###1.PREPARE
if [ -s "$CACHE" ]; then
        TIMECACHE=`stat -c"%Z" "$CACHE"`
else
        TIMECACHE=0
fi
if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
         cat "$STATURL" > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
      'processes_uninterruptible') cat $CACHE |grep -c D;;
      'processes_runnable') cat $CACHE | grep -c R;;
      'processes_sleeping') cat $CACHE |grep -c S;;
      'processes_paging') cat $CACHE |grep -c T;;
      'processes_dead') cat $CACHE |grep -c X;;
      'processes_zombie') cat $CACHE |grep -c Z;;

           *) exit -1 ;;
esac

###4.ECHO METRIC
exit 0
##FINISH