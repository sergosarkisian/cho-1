#!/bin/bash
###
##Monitoring - opensuse
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
STATURL=""
CACHE_PREFIX="opensuse"
CACHETTL="30"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
#TIMENOW=`date '+%s'`
#CACHE="/tmp/zabbix/$CACHE_PREFIX-`echo $STATURL | md5sum | cut -d" " -f1`.cache"

###1.PREPARE
#if [ -s "$CACHE" ]; then
#        TIMECACHE=`stat -c"%Z" "$CACHE"`
#else
#        TIMECACHE=0
#fi
#if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
#         cat "$STATURL" > $CACHE || exit 1
#fi
 
###2.PARSE CACHE FILE
#DEVSTAT= set -a $(grep -m 1 $DEVICE $CACHE)

###3.METRIC CHOOSING
case $METRIC in
	'patches.available')	zypper -q lp|grep "" -c;;
	'patches.needed')	zypper -q lp|grep "| needed" -c;;
	'upd.available')	zypper -q lu|grep "v |" -c;;
	'uname.r')		uname -r;;
	'kernel.global')	uname -r|cut -d "." -f 1;;
	'kernel.major')		uname -r|cut -d "." -f 2;;
	'kernel.minor')		uname -r|cut -d "." -f 3|cut -d "-" -f 1;;
	'kernel.sub')		uname -r|cut -d "." -f 3|cut -d "-" -f 2;;



           *) exit -1 ;;
esac

###4.ECHO METRIC
#echo $data

exit 0
##FINISH