#!/bin/bash
###
##Monitoring - systiming
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
STATURL="/bin/netstat"
CACHE_PREFIX="netstat"
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
         $STATURL -s > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
	'ip_total_packets_received') 	cat $CACHE |grep 'total packets received' |cut -d ' ' -f5;;
	'ip_forwarded') 		cat $CACHE |grep 'forwarded'|cut -d ' ' -f5;;
	'ip_incoming_packets_discarded') 	cat $CACHE |grep 'incoming packets discarded'|cut -d ' ' -f5;;
	'ip_incoming_packets_delivered') 	cat $CACHE |grep 'incoming packets delivered' |cut -d ' ' -f5;;
	'ip_requests_sent_out') 		cat $CACHE |grep 'requests sent out'|cut -d ' ' -f5;;
	'ip_outgoing_packets_dropped') 		cat $CACHE |grep 'outgoing packets dropped'|cut -d ' ' -f5;;
	'ip_dropped_because_of_missing_route') 	cat $CACHE |grep 'dropped because of missing route'|cut -d ' ' -f5;;

	'icmp_ICMP_messages_received') 		cat $CACHE |grep 'ICMP messages received'|cut -d ' ' -f5;;
	'icmp_ICMP_messages_sent') 		cat $CACHE |grep 'ICMP messages sent'|cut -d ' ' -f5;;
	'icmp_ICMP_messages_failed') 		cat $CACHE |grep 'ICMP messages failed'|cut -d ' ' -f5;;

	'tcp_active_connections_opening') 	cat $CACHE |grep 'active connections opening'|cut -d ' ' -f5;;
	'tcp_passive_connection_opening') 	cat $CACHE |grep 'passive connection opening'|cut -d ' ' -f5;;
	'tcp_failed_connection_attempts') 	cat $CACHE |grep 'failed connection attempts'|cut -d ' ' -f5;;
	'tcp_connection_resets_received') 	cat $CACHE |grep 'connection resets received'|cut -d ' ' -f5;;

	'tcp_connections_established') 	cat $CACHE |grep 'connections established'|cut -d ' ' -f5;;
	'tcp_segments_received') 	cat $CACHE |grep 'segments received'|cut -d ' ' -f5;;
	'tcp_segments_send_out') 	cat $CACHE |grep 'segments send out'|cut -d ' ' -f5;;
	'tcp_segments_retransmited') 	cat $CACHE |grep 'segments retransmited'|cut -d ' ' -f5;;
	'tcp_bad_segments_received') 	cat $CACHE |grep 'bad segments received'|cut -d ' ' -f5;;
	'tcp_resets_sent') 		cat $CACHE |grep 'resets sent'|cut -d ' ' -f5;;

           *) exit -1 ;;
esac

###4.ECHO METRIC

exit 0
##FINISH