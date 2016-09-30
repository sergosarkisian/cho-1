#!/bin/bash
## USAGE
#ExecStart=/bin/bash rsync  blkio throttle.read_bps_device 2000 system
##

service=$1
cgoupModule=$2
cgoupMetric=$3
value=$4
context=$5


if [[ $cgoupModule == "blkio" ]]; then
    blockDeviceName=`ls -l -H /dev/disk/by-label/|grep $context|awk '{print $11}'|cut -d"/" -f 3|sed "s/[0-9]//"`
    diskNumber=`ls -l -H /dev/$blockDeviceName|awk '{print substr($5, 1, length($5) - 1)":"$6}'`;

    cgset -r $blkio.$cgoupMetric="$diskNumber $value" system.slice/$service.service
    cgget -a system.slice/$service.service |grep $cgoupMetric
fi