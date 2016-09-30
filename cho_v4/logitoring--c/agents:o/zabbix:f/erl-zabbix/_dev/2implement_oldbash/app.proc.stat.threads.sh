#!/bin/bash
###
##Monitoring - app.proc.threads
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
CACHE_PREFIX="app.proc.stat.threads"
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
          STATURL=("/proc/${PIDS[$i]}/stat")
          STAT=`cat $STATURL`
          SUMSTAT="${SUMSTAT[@]} \n${STAT}"
  done                                             
       echo -e $SUMSTAT > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
	'state')        cat $CACHE | awk '$3{c++}END{print c}';;
	'min_flt')      cat $CACHE | awk '{ SUM += $10} END {print SUM}';;
	'cmin_flt')     cat $CACHE | awk '{ SUM += $11} END {print SUM}';;
	'maj_flt')      cat $CACHE | awk '{ SUM += $12} END {print SUM}';;
	'cmaj_flt')     cat $CACHE | awk '{ SUM += $13} END {print SUM}';;
	'utime')        cat $CACHE | awk '{ SUM += $14} END {print SUM}';;
	'stime')        cat $CACHE | awk '{ SUM += $15} END {print SUM}';;
	'cutime')       cat $CACHE | awk '{ SUM += $16} END {print SUM}';;
	'cstime')       cat $CACHE | awk '{ SUM += $17} END {print SUM}';;
	'vsize')	cat $CACHE | awk '{ SUM += $23} END {print SUM}';;
	'rss')		cat $CACHE | awk '{ SUM += $24} END {print SUM}';;
	'blkio_ticks')	cat $CACHE | awk '{ SUM += $42} END {print SUM}';;


           *) exit -1 ;;
esac

###4.ECHO METRIC
#echo $data

exit 0
##FINISH