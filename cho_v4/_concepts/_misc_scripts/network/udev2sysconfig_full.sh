#!/bin/bash
declare -A CURRENT_INTERFACES_ARRAY_ASSOC        
declare -A UDEV_ARRAY_ASSOC             

UDEV_ARRAY=(`cat /etc/udev/rules.d/70-persistent-net.rules|sed -e "s/.*.ATTR{address}==\"//" -e "s/\", ATTR{dev_id}.*.NAME=\"/ /" -e "s/\"//"|awk '{print $1"++"$2}'|grep ":"`)

for i in "${UDEV_ARRAY[@]}"
do
    UDEV_ARRAY_ASSOC["`echo $i|awk -F "++" '{print $1}'|tr '[A-Z]' '[a-z]'`"]="`echo $i|awk -F "++" '{print $2}'`"
done    

for i in "${!UDEV_ARRAY_ASSOC[@]}"
do

    for octet in `echo "$i"|cut -d: -f3-|tr : ' '`; do
            [ -n "$ip" ] && ip=$ip.
            if [[ $octet == 00 ]]; then
                c=0
            else
                let c=0x$octet
            fi
            ip=${ip}$c
    done

    net=$((0x`echo $i|cut -d: -f2`))
  
    echo "ip - $ip, net - $net, mac - $i"
  
    echo "BOOTPROTO='static'" > /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "NAME=''" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "BROADCAST=''" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "ETHTOOL_OPTIONS=''" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "IPADDR='$ip/$net'" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "MTU=''" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "NETWORK=''" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "REMOTE_IPADDR=''" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}
    echo "USERCONTROL='no'" >> /etc/sysconfig/network/ifcfg-${UDEV_ARRAY_ASSOC[$i]}

    unset ip
done    
