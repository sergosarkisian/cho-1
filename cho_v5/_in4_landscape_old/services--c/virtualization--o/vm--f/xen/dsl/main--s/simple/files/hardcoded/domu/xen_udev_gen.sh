#!/bin/bash
. /media/sysdata/rev5/techpool/ontology/virtualization/xen/domu/xen_read.sh

echo > /etc/udev/rules.d/70-persistent-net.rules

for i in "${!XEN_IP_ARR[@]}"
do
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"${XEN_MAC_ARR[$i]}\", ATTR{type}==\"1\", NAME=\"vlan${XEN_COOKIE_ARR[$i]}\"" >> /etc/udev/rules.d/70-persistent-net.rules
done    
