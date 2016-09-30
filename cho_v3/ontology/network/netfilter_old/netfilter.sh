#!/bin/bash 
. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os

sed -i "s/net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/" /etc/sysctl.conf
sed -i "s/net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/" /etc/sysctl.d/99-sysctl.conf

ip rule flush && /sbin/ip rule add from all table main pref 32766 && /sbin/ip rule add from all table default pref 32767
ip route flush cache
sh /media/sysdata/rev5/_context/conf/netfilter/$Net/$MACIP_HA-$SrvContext-$SrvRole-$DeplType/$SrvName.netfilter.sh 2> /dev/null

sed -i "s/switch_on_ip_forwarding/#switch_on_ip_forwarding/" /usr/sbin/SuSEfirewall2
sed -i "s/setproc 0 \/proc\/sys\/net\/ipv4\/ip_forward/setproc 1 \/proc\/sys\/net\/ipv4\/ip_forward/" /usr/sbin/SuSEfirewall2
sed -i "s/setproc 0 \$i\/forwarding/setproc 1 \$i\/forwarding/" /usr/sbin/SuSEfirewall2
#sed -i "s/setproc 1 \$i\/log_martians/setproc 0 \$i\/log_martians/" /usr/sbin/SuSEfirewall2

echo "2" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "1" >  /proc/sys/net/ipv4/ip_forward

#RM
rm -f /etc/sysconfig/network/ifcfg-eth* 2> /dev/null
#
