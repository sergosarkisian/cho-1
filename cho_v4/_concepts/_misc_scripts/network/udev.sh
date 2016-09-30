#!/bin/bash
declare -A CURRENT_INTERFACES_ARRAY_ASSOC        
declare -A UDEV_ARRAY_ASSOC             

CURRENT_INTERFACES_ARRAY=(`ifconfig |grep HWaddr|sed  "s/ Link encap:Ethernet  HWaddr //"|awk '{print $2"++"$1}'`)
UDEV_ARRAY=(`cat /etc/udev/rules.d/70-persistent-net.rules|sed -e "s/.*.ATTR{address}==\"//" -e "s/\", ATTR{dev_id}.*.NAME=\"/ /" -e "s/\"//"|awk '{print $1"++"$2}'|grep ":"`)

for i in "${CURRENT_INTERFACES_ARRAY[@]}"
do
    CURRENT_INTERFACES_ARRAY_ASSOC["`echo $i|awk -F "++" '{print $1}'|tr '[A-Z]' '[a-z]'`"]="`echo $i|awk -F "++" '{print $2}'`"
done

for i in "${UDEV_ARRAY[@]}"
do
    UDEV_ARRAY_ASSOC["`echo $i|awk -F "++" '{print $1}'|tr '[A-Z]' '[a-z]'`"]="`echo $i|awk -F "++" '{print $2}'`"
done    

for i in "${!CURRENT_INTERFACES_ARRAY_ASSOC[@]}"
do
    if [[ ${UDEV_ARRAY_ASSOC[$i]} ]]; then
    
        if [[ ${CURRENT_INTERFACES_ARRAY_ASSOC[$i]} == ${UDEV_ARRAY_ASSOC[$i]} ]]; then
            echo "$i is simular in udev & interfaces"
        else
            echo "$i is not simular: in udev -  ${UDEV_ARRAY_ASSOC[$i]}, interfaces -  ${CURRENT_INTERFACES_ARRAY_ASSOC[$i]}"
            mv /etc/sysconfig/network/ifcfg-${CURRENT_INTERFACES_ARRAY_ASSOC[$i]} /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]} 
        fi
    fi
done    
