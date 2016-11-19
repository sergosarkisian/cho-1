#!/bin/bash
json=$1

#ex. - '{"systemdService":"%p","cgoupModule":"blkio","cgoupMetric":"throttle.read_bps_device","cgoupValue":"10000000","context":"storage"}'
## VALUES DEF
    systemdService=`echo $json|jq -r '.systemdService'`
    cgoupModule=`echo $json|jq -r '.cgoupModule'`
    cgoupMetric=`echo $json|jq -r '.cgoupMetric'`
    cgoupValue=`echo $json|jq -r '.cgoupValue'`
    context=`echo $json|jq -r '.context'`
##

## CGROUP ASSIGN
if [[ $cgoupModule == "blkio" ]]; then

    blockDeviceName=`ls -l -H /dev/disk/by-label/|grep -m 1 $context|awk '{print $11}'|cut -d"/" -f 3`
    if ! [[ $blockDeviceName =~ "drbd" ]]; then
        blockDeviceName=`echo $blockDeviceName|sed "s/[0-9]//"`
    fi
    diskNumber=`ls -l -H /dev/$blockDeviceName|awk '{print substr($5, 1, length($5) - 1)":"$6}'`;

    cgset -r $cgoupModule.$cgoupMetric="$diskNumber $cgoupValue" system.slice/$systemdService.service
    cgget -a system.slice/$systemdService.service|grep $cgoupMetric
    logger -i -t "cgroup_applyer" "Cgroup for the service $systemdService, module $cgoupModule, metric $cgoupMetric = $cgoupValue is applyed. Additional parameters: diskNumber - $diskNumber; context - $context"
    logger -i -t "cgroup_applyer"  "{\"logged_by\":\"cgroup_applyer\",\"msg\": \"Cgroup for the service $systemdService, module $cgoupModule, metric $cgoupMetric = $cgoupValue is applyed. Additional parameters: diskNumber - $diskNumber; context - $context\"}"    
fi
##
