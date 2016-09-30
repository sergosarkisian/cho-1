#!/bin/bash
###
##Monitoring - app.proc.threads
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
CACHE_PREFIX="app.proc.statm.threads"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX_$DEVICE.cache"
PIDS=(`/sbin/pidof $1`)                                                                                                 

###1.PREPARE
if [ -s "$CACHE" ]; then
        TIMECACHE=`stat -c"%Z" "$CACHE"`
else
        TIMECACHE=0
fi

if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
total=${#PIDS[*]}
         
  for (( i=0; i<=$(( $total -1 )); i++ ))
  do                                     
          STATURL=("/proc/${PIDS[$i]}/statm")
          STAT=`cat $STATURL`
          SUMSTAT="${SUMSTAT[@]} \n${STAT}"
  done                                             
       echo -e $SUMSTAT > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
	'size')		cat $CACHE | awk '{ SUM += $1} END {print SUM}';; 
	'resident')	cat $CACHE | awk '{ SUM += $2} END {print SUM}';; 
	'shared')	cat $CACHE | awk '{ SUM += $3} END {print SUM}';; 
	'trs')		cat $CACHE | awk '{ SUM += $4} END {print SUM}';; 
	'lrs')		cat $CACHE | awk '{ SUM += $5} END {print SUM}';; 
	'drs')		cat $CACHE | awk '{ SUM += $6} END {print SUM}';; 
	'dt')		cat $CACHE | awk '{ SUM += $7} END {print SUM}';; 

           *) exit -1 ;;
esac

###4.ECHO METRIC
#echo $data

exit 0
##FINISH