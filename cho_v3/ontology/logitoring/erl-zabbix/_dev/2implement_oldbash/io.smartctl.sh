#!/bin/bash
###
##Monitoring - diskstats
###

if [[ -z "$1" && -z "$2" ]]; then exit 1; fi

###~~~###~~~###CONSTANTS###~~~###~~~###
STATURL="/usr/sbin/smartctl"
CACHE_PREFIX="smartctl"
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
	  $STATURL /dev/$DEVICE -A  > $CACHE || exit 1
fi
 
###2.PARSE CACHE FILE

###3.METRIC CHOOSING
case $METRIC in
	'raw_read_error_rate') set -a  $(grep -i "Raw_Read_Error_Rate" $CACHE); echo ${10} ;;
	'start_stop_count') set -a  $(grep -i "Start_Stop_Count" $CACHE); echo ${10} ;;
	'reallocated_sector_Ct') set -a  $(grep -i "Reallocated_Sector_Ct" $CACHE); echo ${10} ;;
	'seek_error_rate') set -a  $(grep -i "Seek_Error_Rate" $CACHE); echo ${10} ;;
	'power_on_hours') set -a  $(grep -i "Power_On_Hours" $CACHE); echo ${10} ;;
	'spin_retry_count') set -a  $(grep -i "Spin_Retry_Count" $CACHE); echo ${10} ;;
	'calibration_retry_count') set -a  $(grep -i "Calibration_Retry_Count" $CACHE); echo ${10} ;;
	'power_cycle_count') set -a  $(grep -i "Power_Cycle_Count" $CACHE); echo ${10} ;;
	'poweroff_retract_count') set -a  $(grep -i "Power-Off_Retract_Count" $CACHE); echo ${10} ;;
	'load_cycle_count') set -a  $(grep -i "Load_Cycle_Count" $CACHE); echo ${10} ;;
	'temperature_celsius')  set -a  $(grep -i "Temperature_Celsius" $CACHE); echo ${10} ;;
	'reallocated_event_count') set -a  $(grep -i "Reallocated_Event_Count" $CACHE); echo ${10} ;;
	'current_pending_sector') set -a  $(grep -i "Current_Pending_Sector" $CACHE); echo ${10} ;;
	'offline_uncorrectable') set -a  $(grep -i "Offline_Uncorrectable" $CACHE); echo ${10} ;;
	'udma_crc_error_count') set -a  $(grep -i "UDMA_CRC_Error_Count" $CACHE); echo ${10} ;;
	'multi_zone_error_rate') set -a  $(grep -i "Multi_Zone_Error_Rate" $CACHE); echo ${10} ;;
           *) exit -1 ;;
esac

###4.ECHO METRIC
echo $data

exit 0
##FINISH