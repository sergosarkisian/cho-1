#!/bin/bash
###
##Monitoring - haproxy
###

if [[ -z "$1" && -z "$2" && -z "$3" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
BIN=/usr/bin/socat
STATURL="/var/run/haproxy.stat"
CACHE_PREFIX="haproxy"
CACHETTL="10"
###~~~###~~~###CONSTANTS###~~~###~~~###


###0.PARAMS
DEVICE="$1"
METRIC="$2"
GROUP="$3"

TIMENOW=`date '+%s'`
CACHE="/tmp/zabbix/$CACHE_PREFIX-`echo $STATURL | md5sum | cut -d" " -f1`.cache"

###1.PREPARE
if [ -s "$CACHE" ]; then
        TIMECACHE=`stat -c"%Z" "$CACHE"`
else
        TIMECACHE=0
fi
if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
         echo 'show stat' | $BIN "$STATURL" stdio > $CACHE || exit 1                                                                                                                
fi
 
###2.PARSE CACHE FILE
DEVSTAT= set -a $(grep -m 1 $DEVICE $CACHE|grep -m 1 $GROUP)
cat $DEVSTAT

###3.METRIC CHOOSING
case $METRIC in
       "read.ops") data=$4;;     # Reads completed
    "read.merged") data=$5 ;;    # Reads merged
   "read.sectors") data=$6 ;;    # 512 byte sectors read
        "read.ms") data=$7 ;;    # milliseconds spent reading
      "write.ops") data=$8 ;;    # Writes completed
   "write.merged") data=$9 ;;    # Writes merged
  "write.sectors") data=${10} ;; # 512 byte sectors written
       "write.ms") data=${11} ;; # milliseconds spent writing
      "io.active") data=${12} ;; # I/Os currently in progress
          "io.ms") data=${13} ;; # milliseconds spent doing I/Os
      "io.weight") data=${14} ;; # weighted # of milliseconds spent doing I/O
           *) exit -1 ;;
esac

###4.ECHO METRIC
echo $data

exit 0
##FINISH

 #cat $CACHE                                                                                                                                                                        
 #1.5 - pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt,
                                                                                                                                                                                    
case $METRIC in                                                                                                                                                                     
'pxname') cat $CACHE    | grep $GROUP | grep $SERVER | cut -d',' -f1;;                                                                                                                                    
'svname') cat $CACHE    | grep $GROUP | grep $SERVER | cut -d',' -f2;;
'qcur') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f3;;
'qmax') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f4;;
'scur') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f5;;
'smax') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f6;;
'slim') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f7;;
'stot') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f8;;
'bin') cat $CACHE       | grep $GROUP | grep $SERVER | cut -d',' -f9;;
'bout') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f10;;
'dreq') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f11;;
'dresp') cat $CACHE     | grep $GROUP | grep $SERVER | cut -d',' -f12;;
'ereq') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f13;;
'econ') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f14;;
'eresp') cat $CACHE     | grep $GROUP | grep $SERVER | cut -d',' -f15;;
'wretr') cat $CACHE     | grep $GROUP | grep $SERVER | cut -d',' -f16;;
'wredis') cat $CACHE    | grep $GROUP | grep $SERVER | cut -d',' -f17;;
'status') cat $CACHE    | grep $GROUP | grep $SERVER | cut -d',' -f18;;
'weight') cat $CACHE    | grep $GROUP | grep $SERVER | cut -d',' -f19;;
'act') cat $CACHE       | grep $GROUP | grep $SERVER | cut -d',' -f20;;
'bck') cat $CACHE       | grep $GROUP | grep $SERVER | cut -d',' -f21;;
'chkfail') cat $CACHE   | grep $GROUP | grep $SERVER | cut -d',' -f22;;
'chkdown') cat $CACHE   | grep $GROUP | grep $SERVER | cut -d',' -f23;;
'lastchg') cat $CACHE   | grep $GROUP | grep $SERVER | cut -d',' -f24;;
'downtime') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f25;;
'qlimit') cat $CACHE    | grep $GROUP | grep $SERVER | cut -d',' -f26;;
'pid') cat $CACHE       | grep $GROUP | grep $SERVER | cut -d',' -f27;;
'iid') cat $CACHE       | grep $GROUP | grep $SERVER | cut -d',' -f28;;
'sid') cat $CACHE       | grep $GROUP | grep $SERVER | cut -d',' -f29;;
'throttle') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f30;;
'lbtot') cat $CACHE     | grep $GROUP | grep $SERVER | cut -d',' -f31;;
'tracked') cat $CACHE   | grep $GROUP | grep $SERVER | cut -d',' -f32;;
'type') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f33;;
'rate') cat $CACHE      | grep $GROUP | grep $SERVER | cut -d',' -f34;;
'rate_lim') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f35;;
'rate_max') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f36;;
'check_status') cat $CACHE| grep $GROUP | grep $SERVER | cut -d',' -f37;;
'check_code') cat $CACHE| grep $GROUP | grep $SERVER | cut -d',' -f38;;
'check_duration') cat $CACHE| grep $GROUP | grep $SERVER | cut -d',' -f39;;
'hrsp_1xx') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f40;;
'hrsp_2xx') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f41;;
'hrsp_3xx') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f42;;
'hrsp_4xx') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f43;;
'hrsp_5xx') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f44;;
'hrsp_other') cat $CACHE| grep $GROUP | grep $SERVER | cut -d',' -f45;;
'hanafail') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f46;;
'req_rate') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f47;;
'req_rate_max') cat $CACHE| grep $GROUP | grep $SERVER | cut -d',' -f48;;
'req_tot') cat $CACHE   | grep $GROUP | grep $SERVER | cut -d',' -f49;;
'cli_abrt') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f50;;
'srv_abrt') cat $CACHE  | grep $GROUP | grep $SERVER | cut -d',' -f51;;