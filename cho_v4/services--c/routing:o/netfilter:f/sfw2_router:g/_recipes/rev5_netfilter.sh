#!/bin/bash 

## NETFILTER ##

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os
rm -f  /etc/iproute2/rt_tables && ln -s /media/sysdata/rev5/_context/conf/netfilter/$Net/$MACIP_HA-$SrvContext-$SrvRole-$DeplType/rt_tables_symlink /etc/iproute2/rt_tables

rm -f /etc/systemd/system/rev5_netfilter.service 			&& cp /media/sysdata/rev5/techpool/ontology/network/netfilter/_systemd/rev5_netfilter.service 	/etc/systemd/system/ 

systemctl daemon-reload
systemctl enable rev5_netfilter && systemctl restart rev5_netfilter 
systemctl status rev5_netfilter 
##
