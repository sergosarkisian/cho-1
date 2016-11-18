#!/bin/bash
set -e
#red=`tput setaf 1`

if [[ -z $VM_CPU ]]; then
    DESC="Please specify number of CPUs"
    echo $DESC    
    if [[ -z $1 ]]; then echo $DESC; select VM_CPU in 2 4 6 8 ;  do  break ; done; else VM_CPU=$1; fi
fi

if [[ -z $VM_RAM ]]; then
    DESC="Please specify amount of RAM (GB)"
    echo $DESC
    if [[ -z $2 ]]; then echo $DESC; select VM_RAM in 2 4 10 20 30 40 ;  do  break ; done; else VM_RAM=$2; fi
fi

if [[ -z $VM_RAM_MAX ]]; then
    DESC="Please specify amount of max RAM (GB)"
    echo $DESC
    if [[ -z $3 ]]; then echo $DESC; select VM_RAM_MAX in 5 20 30 40 50    ;  do  break ; done; else VM_RAM_MAX=$3; fi
fi

if [[ -z $VM_POOL ]]; then
    DESC="Please specify VM pool"
    echo $DESC
    if [[ -z $4 ]]; then echo $DESC; select VM_POOL in Pool1 Pool2    ;  do  break ; done; else VM_POOL=$4; fi
fi

if [[ -z $VM_POOL ]]; then
    DESC="Please specify VM pool"
    echo $DESC
    if [[ -z $5 ]]; then echo $DESC; select VM_POOL in Pool1 Pool2    ;  do  break ; done; else VM_POOL=$5; fi
fi

if [[ -z $VM_IP ]]; then
    DESC="Please specify IP address of the main interface"
    echo $DESC
    if [[ -z $6 ]]; then echo $DESC; read VM_IP; else VM_IP=$6; fi
fi

if [[ -z $VM_MTU ]]; then
    DESC="Please specify MTU of the main interface"
    echo $DESC
    if [[ -z $7 ]]; then echo $DESC; select VM_MTU in 1500 9000 ;  do  break ; done; else VM_MTU=$7; fi
fi

if [[ -z $VM_VLAN ]]; then
    DESC="Please specify VLAN of the main interface"
    echo $DESC
    if [[ -z $8 ]]; then echo $DESC; read VM_VLAN ; else VM_VLAN=$8; fi
fi

if [[ -z $VM_GATE_IP ]]; then
    DESC="Please specify VM Gate IP address"
    echo $DESC
    if [[ -z $9 ]]; then echo $DESC; read VM_GATE_IP; else VM_GATE_IP=$9; fi
fi

if [[ -z $VM_DISK_STORAGE_SIZE ]]; then
    DESC="Please specify VM Disk 'storage' size in G"
    echo $DESC
    if [[ -z ${10} ]]; then echo $DESC; select VM_DISK_STORAGE_SIZE in 10 50 100 200 300;  do  break ; done; else VM_DISK_STORAGE_SIZE=${10}; fi
fi
# IP2MAC VM_SPICE_PORT VM_SPICE_WORD VM_NAME VM_DISKPATH
# systemd service

.  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/vm_tmpl.xl
