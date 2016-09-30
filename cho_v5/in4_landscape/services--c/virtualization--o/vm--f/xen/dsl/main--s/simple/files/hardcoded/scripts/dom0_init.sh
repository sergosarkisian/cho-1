#!/bin/bash
#NUMA
systemctl restart xencommons.service

xl cpupool-create name=\"Pool1\" 
xl cpupool-create name=\"Pool2\" 

CPU_NUM=`xl info |grep nr_cpus|awk '{print $3}'`
CPU_NUM_Z=$((CPU_NUM-1))
CPU_NUM_H=$((CPU_NUM/2))

CPU_C=`cat /proc/cpuinfo|grep processor -c`
while [ "$CPU_C" -lt "$CPU_NUM" ]
do
	xl cpupool-cpu-remove Pool-0 $CPU_C
let "CPU_C +=1"
done

CPU_C=`cat /proc/cpuinfo|grep processor -c`
while [ "$CPU_C" -lt "$CPU_NUM_H" ]
do
	xl cpupool-cpu-add Pool1 $CPU_C
let "CPU_C +=1"
done

CPU_C=$CPU_NUM_H
while [ "$CPU_C" -lt "$CPU_NUM" ]
do
	xl cpupool-cpu-add Pool2 $CPU_C
let "CPU_C +=1"
done


#Dom0 pinning
CPU_C=`cat /proc/cpuinfo|grep processor -c`
while [ "$CPU_C" -gt 0 ]
do
	let "CPU_C -=1"
	xl vcpu-pin Domain-0 $CPU_C $CPU_C
	
done


xl sched-credit -d 0 -w 10240
xenpm set-scaling-governor performance
xenpm set-max-cstate 0

#OVS
/usr/bin/ovs-vsctl --may-exist add-br vlannet
/usr/bin/ovs-vsctl --may-exist add-port vlannet bond_vlannet

uptime=`cat /proc/uptime|cut -d " " -f 1|cut -d "." -f 1`
if [[ $uptime < 1000 ]]; then
	vif_ports=`ip a|grep vif|cut -d ":" -f 2`
	for vif in $vif_ports; do
		ovs-vsctl del-port vlannet $vif
	done
fi

ovs-ofctl del-flows vlannet
ovs-ofctl add-flow vlannet priority=10000,action=drop
ovs-vsctl set bridge vlannet protocols=OpenFlow10,OpenFlow11,OpenFlow12,OpenFlow13,OpenFlow14,OpenFlow15
ovs-appctl vlog/set syslog,info

#DELETE ALL UNUSED PORTS
ovs-vsctl -- --columns=name,error list Interface|grep "could not open network device vif" -B1|grep "\"vif"|cut -d ":" -f 2|xargs -n1 ovs-vsctl del-port vlannet


##MANAGEMENT INTERFACE
declare -A store
#const
store[dev]="man"
store[command]="online"
store[ovs_tag_method]="tag"
store[type]="ext"
store[ext_if]="bond_vlannet"
store[policy]="common"
store[switch]="vlannet"
##

net=`cat /etc/sysconfig/network/ifcfg-${store[dev]}|grep -m 1 IPADDR|cut -d "=" -f2|cut -d "'" -f2`
store[ip]=`cat $net|cut -d "/" -f1`
store[netmask]=`cat $net|cut -d "/" -f2`
store[cookie]=`cat /etc/sysconfig/network/ifcfg-${store[dev]}|grep -m 1 COOKIE|cut -d "=" -f2|cut -d "'" -f2`
store[mtu]=`cat /etc/sysconfig/network/ifcfg-${store[dev]}|grep -m 1 MTU|cut -d "=" -f2|cut -d "'" -f2`

/usr/bin/ovs-vsctl --may-exist add-port vlannet man tag=${store[cookie]} -- set interface man type=internal
sleep 1
ifup man
store[port]=`ovs-vsctl get Interface ${store[dev]} ofport`
store[bcast]=`ipcalc -b ${store[ip]}/${store[netmask]}|grep Broadcast:|awk '{sub(/^[ \t]+/, ""); print$2}'`

for pairs in ${!store[@]}; do store_serialised+="$pairs::${store[$pairs]}---"; done 
store_serialised=${store_serialised:0:-3}
/etc/xen/scripts/ovs-openflow "$store_serialised" 2>&1 | logger -t xen-vif


# for i in `echo "${store[mac]}"|cut -d: -f3-|tr : ' '`; do
#         [ -n "$ip" ] && ip=$ip.
#         if [[ $i == 00 ]]; then
#             c=0
#         else
#             let c=0x$i
#         fi
#         ip=${ip}$c
# done
# 
# 
# 
# store[mac]=
