#!/bin/bash
###
##Monitoring - nginx
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
BIN=/usr/bin/curl
CACHE_PREFIX="nstat"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX_$DEVICE.cache"
STATURL="http://$DEVICE/nstat"

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
	  'active_connections')   cat $CACHE | grep "Active connections" | cut -d':' -f2;;                                                                                                                              
	  'accepts')              cat $CACHE | sed -n '3p' | cut -d" " -f2;;
	  'handled')              cat $CACHE | sed -n '3p' | cut -d" " -f3;;
	  'requests')             cat $CACHE | sed -n '3p' | cut -d" " -f4;;
	  'conn_reading')         cat $CACHE | grep "Reading" | cut -d':' -f2 | cut -d' ' -f2;;
	  'conn_writing')         cat $CACHE | grep "Writing" | cut -d':' -f3 | cut -d' ' -f2;;
	  'conn_waiting')         cat $CACHE | grep "Waiting" | cut -d':' -f4 | cut -d' ' -f2;;

           *) exit -1 ;;
esac

###4.ECHO METRIC
echo $data

exit 0
##FINISH