#!/bin/bash
. /media/sysdata/rev5/techpool/ontology/virtualization/xen/domu/xen_read.sh


for i in "${!XEN_IP_ARR[@]}"
do
 cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/ifcfg-tmpl /etc/sysconfig/network/ifcfg-vlan${XEN_COOKIE_ARR[$i]} 
 sed -i "s/{IP}/${XEN_IP_ARR[$i]}/"  /etc/sysconfig/network/ifcfg-vlan${XEN_COOKIE_ARR[$i]} 
 sed -i "s/{NETMASK}/${XEN_NETMASK_ARR[$i]}/"  /etc/sysconfig/network/ifcfg-vlan${XEN_COOKIE_ARR[$i]} 
 sed -i "s/{MTU}/${XEN_MTU_ARR[$i]}/"  /etc/sysconfig/network/ifcfg-vlan${XEN_COOKIE_ARR[$i]} 	 
done    
