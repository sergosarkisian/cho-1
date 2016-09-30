#!/bin/bash
###
##Monitoring - apache
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
BIN=/usr/bin/curl
CACHE_PREFIX="astat"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX_$DEVICE.cache"
STATURL="http://$DEVICE/astat?auto"

###1.PREPARE
if [ -s "$CACHE" ]; then
        TIMECACHE=`stat -c"%Z" "$CACHE"`
else
        TIMECACHE=0
fi
if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
        $BIN --proxy $DEVICE -s --url "$STATURL" > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
      'total_accesses') cat $CACHE | grep "Total Accesses" | cut -d':' -f2;;
      'total_accesses.total') cat $CACHE | grep "Total Accesses" | cut -d':' -f2;;
      'total_kbytes') cat $CACHE | grep "Total kBytes" | cut -d':' -f2;;
      'total_kbytes.total') cat $CACHE | grep "Total kBytes" | cut -d':' -f2;;
      'cpuload') cat $CACHE | grep "CPULoad" | cut -d':' -f2;;
      'reqpersec') cat $CACHE | grep "ReqPerSec" | cut -d':' -f2;;
      'bytespersec') cat $CACHE | grep "BytesPerSec" | cut -d':' -f2;;
      'bytesperreq') cat $CACHE | grep "BytesPerReq" | cut -d':' -f2;;
      'busyworkers') cat $CACHE | grep "BusyWorkers" | cut -d':' -f2;;
      'idleworkers') cat $CACHE | grep "IdleWorkers" | cut -d':' -f2;;
      'totalworkers') cat $CACHE | grep "IdleWorkers" | cut -d':' -f2;; ##  NOT CORRECT, should be sumidle+ busy
      'workers.closingconn') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "C" | wc -l | /bin/sed s/\ //g;;
      'workers.dns') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "D" | wc -l | /bin/sed s/\ //g;;
      'workers.finishing') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "G" | wc -l | /bin/sed s/\ //g;;
      'workers.cleanup') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "I" | wc -l | /bin/sed s/\ //g;;
      'workers.keepalive') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "K" | wc -l | /bin/sed s/\ //g;;
      'workers.logging') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "L" | wc -l | /bin/sed s/\ //g;;
      'workers.openslot') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "\." | wc -l | /bin/sed s/\ //g;;
      'workers.reading') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "R" | wc -l | /bin/sed s/\ //g;;
      'workers.starting') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "S" | wc -l | /bin/sed s/\ //g;;
      'workers.waitingconn') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "W" | wc -l | /bin/sed s/\ //g;;
      'workers.writing') cat $CACHE | grep "Scoreboard" | cut -d':' -f2|  grep -o "_" | wc -l | /bin/sed s/\ //g;;

           *) exit -1 ;;
esac

###4.ECHO METRIC
echo $data

exit 0
##FINISH