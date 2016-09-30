#!/bin/bash
declare -A CURRENT_INTERFACES_ARRAY_ASSOC        
declare -A UDEV_ARRAY_ASSOC             

CURRENT_INTERFACES_ARRAY=(`ip a|grep link/ether|sed  "s/link\/ether //"|awk '{print $1"++vlan"}'`)

for i in "${CURRENT_INTERFACES_ARRAY[@]}"
do
    CURRENT_INTERFACES_ARRAY_ASSOC["`echo $i|awk -F "++" '{print $1}'|tr '[A-Z]' '[a-z]'`"]="`echo $i|awk -F "++" '{print $2}'`"
done

echo > /etc/udev/rules.d/70-persistent-net.rules

for i in "${!CURRENT_INTERFACES_ARRAY_ASSOC[@]}"
do
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$i\", ATTR{type}==\"1\", NAME=\"${CURRENT_INTERFACES_ARRAY_ASSOC[$i]}\"" >> /etc/udev/rules.d/70-persistent-net.rules
done    
