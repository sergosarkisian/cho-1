#!/bin/bash
json=$1
cgoupModules=("blkio" "cpu" "memory")
#ex. '{"systemdService":"%p","procHarvesterName":"drbd"}'
## VALUES DEF
    systemdService=`echo $json|jq -r '.systemdService'`
    procHarvesterName=`echo $json|jq -r '.procHarvesterName'`
##

## PRE-PROCCESS
#procHarvester=`` # TODO - make a rev5 placement
if [[ $procHarvesterName == "drbd" ]]; then
    pids=`ps aux|egrep "drbd_a_.*|drbd_s_.*|drbd_r_.*|drbd_w_.*"|awk '{print $2}'`
fi
##

## CGROUP ASSIGN
 for pid in $pids; do
 for cgoupModule in $cgoupModules; do
        cgclassify -g $cgoupModule:/system.slice/$systemdService.service $pid
        echo "{\"logged_by\":\"cgroup_joiner\",\"msg\": \"PID $pid has joined to the CGroup of the service $systemdService, module $cgoupModule. Additional parameters: procHarvesterName - $procHarvesterName\"}"
    done
 done
##

