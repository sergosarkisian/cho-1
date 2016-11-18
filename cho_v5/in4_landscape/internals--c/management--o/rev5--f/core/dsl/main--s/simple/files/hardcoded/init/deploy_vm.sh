#!/bin/bash
set -e
i=1
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/manual.sh

VM_DISKPATH=

if [[ -z $VM_CPU ]]; then
    DESC="Please specify number of CPUs"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_CPU in 2 4 6 8 ;  do  break ; done; else VM_CPU=$ARG_NUM; fi
fi

echo -e "\n #### Physical parameters #### \n"

if [[ -z $VM_CPU ]]; then
    DESC="Please specify number of CPUs"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_CPU in 2 4 6 8 ;  do  break ; done; else VM_CPU=$ARG_NUM; fi
fi

if [[ -z $VM_RAM ]]; then
    DESC="Please specify amount of RAM (GB)"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_RAM in 2 4 10 20 30 40 ;  do  break ; done; else VM_RAM=$ARG_NUM; fi
fi

if [[ -z $VM_RAM_MAX ]]; then
    DESC="Please specify amount of max RAM (GB)"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_RAM_MAX in 5 20 30 40 50    ;  do  break ; done; else VM_RAM_MAX=$ARG_NUM; fi
fi

if [[ -z $VM_POOL ]]; then
    DESC="Please specify VM pool"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_POOL in Pool1 Pool2    ;  do  break ; done; else VM_POOL=$ARG_NUM; fi
fi

echo -e "\n #### Storage  #### \n"

if [[ -z $VM_DISK_STORAGE_SIZE ]]; then
    DESC="Please specify VM Disk 'storage' size in G"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_DISK_STORAGE_SIZE in 10 50 100 200 300;  do  break ; done; else VM_DISK_STORAGE_SIZE=$ARG_NUM; fi
fi

echo -e "\n #### Network  #### \n"


if [[ -z $VM_MTU ]]; then
    DESC="Please specify MTU of the main interface"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_MTU in 1500 9000 ;  do  break ; done; else VM_MTU=$ARG_NUM; fi
fi

VM_VLAN=$Net

if [[ -z $VM_GATE_IP ]]; then
    DESC="Please specify VM Gate IP address"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z ${vm_params[$i]} ]]; then echo $DESC; read VM_GATE_IP; else VM_GATE_IP=$i; fi
fi


# systemd service

### SUPERLOGIC ###
VM_IP2MAC_OCT1=$( printf "%02x" `echo $VM_IP|cut -d. -f 1`)
VM_IP2MAC_OCT2=$( printf "%02x" `echo $VM_IP|cut -d. -f 2`)
VM_IP2MAC_OCT3=$( printf "%02x" `echo $VM_IP|cut -d. -f 3`)
VM_IP2MAC_OCT4=$( printf "%02x" `echo $VM_IP|cut -d. -f 4|cut -d/ -f 1`)
VM_NETMASK=$( printf "%02x" `echo $VM_IP|cut -d. -f 4|cut -d/ -f 2`)
VM_IP2MAC_SUM3_DEC=$((16#${VM_IP2MAC_OCT3:1:1}${VM_IP2MAC_OCT4}))
VM_SPICE_PORT=$((VM_IP2MAC_SUM3_DEC+50000))
VM_SPICE_PASS="${VM_IP2MAC_OCT1}${VM_IP2MAC_OCT2}${VM_IP2MAC_OCT3}${VM_IP2MAC_OCT4}"
MACIP="${VM_IP2MAC_OCT1}${VM_IP2MAC_OCT2}${VM_IP2MAC_OCT3}${VM_IP2MAC_OCT4}${VM_NETMASK}"
VM_IP2MAC_MAC_UC="${VM_IP2MAC_OCT1^^}:${VM_IP2MAC_OCT2^^}:${VM_IP2MAC_OCT3^^}:${VM_IP2MAC_OCT4^^}:${VM_NETMASK^^}"
###
.  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/vm_tmpl.xl

.  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/vm_tmpl.xl > /media/sysdata/in4/_context/conf/xen/$HV/$Org.pool/$Net/$SrvType/$DeplType/$SrvName.hvm.xl
