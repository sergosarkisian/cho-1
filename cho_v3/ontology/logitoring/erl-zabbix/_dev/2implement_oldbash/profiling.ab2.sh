#!/bin/bash
###
##Monitoring - apache
###

if [[ -z "$1" && -z "$2" && -z "$3" && -z "$4" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
BIN=/usr/sbin/ab2
CACHE_PREFIX="profiling.ab2"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
NUMBER="$3"
CONCURRENT="$4"

TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX-`echo $DEVICE | md5sum | cut -d" " -f1`.cache"

###1.PREPARE
if [ -s "$CACHE" ]; then
        TIMECACHE=`stat -c"%Z" "$CACHE"`
else
        TIMECACHE=0
fi
if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
        $BIN -n $NUMBER -c $CONCURRENT  $DEVICE> $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
      'time_per_single_request') cat $CACHE | grep "across all concurrent requests" | awk '{$1=$1}1'| cut -d " " -f 4;;
      'transfer_rate') cat $CACHE | grep "Transfer rate:" | awk '{$1=$1}1'| cut -d " " -f 3;;

      'percentage_50')  cat $CACHE | grep "50%" | awk '{$1=$1}1'| cut -d " " -f 2 ;;
      'percentage_80')  cat $CACHE | grep "80%" | awk '{$1=$1}1'| cut -d " " -f 2 ;;
      'percentage_90')  cat $CACHE | grep "90%" | awk '{$1=$1}1'| cut -d " " -f 2 ;;
      'percentage_95')  cat $CACHE | grep "95%" | awk '{$1=$1}1'| cut -d " " -f 2 ;;
      'percentage_99')  cat $CACHE | grep "99%" | awk '{$1=$1}1'| cut -d " " -f 2 ;;
      'percentage_100') cat $CACHE | grep "100%" | awk '{$1=$1}1'| cut -d " " -f 2 ;;

      'connect_min')    cat $CACHE | grep "Connect:"|awk '{$1=$1}1'|cut -d " " -f 2 ;;
      'connect_mean')   cat $CACHE | grep "Connect:"|awk '{$1=$1}1'|cut -d " " -f 3 ;;
      'connect_dev')    cat $CACHE | grep "Connect:"|awk '{$1=$1}1'|cut -d " " -f 4 ;;
      'connect_med')    cat $CACHE | grep "Connect:"|awk '{$1=$1}1'|cut -d " " -f 5 ;;
      'connect_max')    cat $CACHE | grep "Connect:"|awk '{$1=$1}1'|cut -d " " -f 6 ;;

      'processing_min')    cat $CACHE | grep "Processing:"|awk '{$1=$1}1'|cut -d " " -f 2 ;;
      'processing_mean')   cat $CACHE | grep "Processing:"|awk '{$1=$1}1'|cut -d " " -f 3 ;;
      'processing_dev')    cat $CACHE | grep "Processing:"|awk '{$1=$1}1'|cut -d " " -f 4 ;;
      'processing_med')    cat $CACHE | grep "Processing:"|awk '{$1=$1}1'|cut -d " " -f 5 ;;
      'processing_max')    cat $CACHE | grep "Processing:"|awk '{$1=$1}1'|cut -d " " -f 6 ;;

      'waiting_min')    cat $CACHE | grep "Waiting:"|awk '{$1=$1}1'|cut -d " " -f 2 ;;
      'waiting_mean')   cat $CACHE | grep "Waiting:"|awk '{$1=$1}1'|cut -d " " -f 3 ;;
      'waiting_dev')    cat $CACHE | grep "Waiting:"|awk '{$1=$1}1'|cut -d " " -f 4 ;;
      'waiting_med')    cat $CACHE | grep "Waiting:"|awk '{$1=$1}1'|cut -d " " -f 5 ;;
      'waiting_max')    cat $CACHE | grep "Waiting:"|awk '{$1=$1}1'|cut -d " " -f 6 ;;

      'total_min')    cat $CACHE | grep "Total:"|awk '{$1=$1}1'|cut -d " " -f 2 ;;
      'total_mean')   cat $CACHE | grep "Total:"|awk '{$1=$1}1'|cut -d " " -f 3 ;;
      'total_dev')    cat $CACHE | grep "Total:"|awk '{$1=$1}1'|cut -d " " -f 4 ;;
      'total_med')    cat $CACHE | grep "Total:"|awk '{$1=$1}1'|cut -d " " -f 5 ;;
      'total_max')    cat $CACHE | grep "Total:"|awk '{$1=$1}1'|cut -d " " -f 6 ;;




           *) exit -1 ;;
esac

###4.ECHO METRIC
echo $data

exit 0
##FINISH