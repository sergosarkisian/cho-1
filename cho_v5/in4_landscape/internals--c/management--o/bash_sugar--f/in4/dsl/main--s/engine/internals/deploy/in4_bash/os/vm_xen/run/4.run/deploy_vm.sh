#!/bin/bash
set -e
.  $In4_Exec_Path/../../../naming/manual.sh

if [[ -z $VM_HV_NAME ]]; then
    DESC="Please specify hypervisor name"
     echo $DESC; read VM_HV_NAME;
fi

if [[ -z $VM_HV_ORG ]]; then
    DESC="Please specify hypervisor organisation"
     echo $DESC; read VM_HV_ORG;
fi

echo -e "\n #### Physical parameters #### \n"

if [[ -z $VM_CPU ]]; then
    DESC="Please specify number of CPUs"
     echo $DESC; select VM_CPU in 2 4 6 8 ;  do  break ; done; 
fi

if [[ -z $VM_RAM ]]; then
    DESC="Please specify amount of RAM (GB)"
     echo $DESC; select VM_RAM in 2 4 10 20 30 40 ;  do  break ; done; 
fi

if [[ -z $VM_RAM_MAX ]]; then
    DESC="Please specify amount of max RAM (GB)"
     echo $DESC; select VM_RAM_MAX in 5 20 30 40 50    ;  do  break ; done; 
fi

if [[ -z $VM_POOL ]]; then
    DESC="Please specify VM pool"
     echo $DESC; select VM_POOL in Pool1 Pool2    ;  do  break ; done; 
fi

echo -e "\n #### Storage  #### \n"

if [[ -z $VM_DISK_STORAGE_SIZE ]]; then
    DESC="Please specify amount of starable data on disk 'storage' (in G)"
     echo $DESC; select VM_DISK_STORAGE_SIZE in 10 50 100 200 300;  do  break ; done; 
fi

if [[ -z $VM_DISK_STORAGE_SNAP_COEFF ]]; then
    DESC="Please specify snapshot coeff for disk 'storage' (in G)"
     echo $DESC; select VM_DISK_STORAGE_SNAP_COEFF in 0.1 0.3 0.5 0.7 1 2 ;  do  break ; done; 
fi

VM_DISK_STORAGE_SIZE_OVERALL=`printf "%.0f" $(echo "$VM_DISK_STORAGE_SIZE + $VM_DISK_STORAGE_SIZE*$VM_DISK_STORAGE_SNAP_COEFF" | bc -l)`
echo "Overall disk 'storage' is $VM_DISK_STORAGE_SIZE_OVERALL GB"

VM_DISK_PATH="$Org/$SrvRole/$DeplType/$SrvName"

echo -e "\n #### Network  #### \n"


if [[ -z $VM_MTU ]]; then
    DESC="Please specify MTU of the main interface"
     echo $DESC; select VM_MTU in 1500 9000 ;  do  break ; done;
fi

VM_VLAN="$Net"

if [[ -z $VM_GATE_IP ]]; then
    DESC="Please specify VM Gate IP address"
     echo $DESC; read VM_GATE_IP
fi


# systemd service

### SUPERLOGIC ###
VM_IP2MAC_SUM3_DEC=$((16#${VM_IP2MAC_OCT3:1:1}${VM_IP2MAC_OCT4}))
VM_SPICE_PORT=$((VM_IP2MAC_SUM3_DEC+50000))
VM_IP2MAC_MAC_UC="${VM_NETMASK^^}:${VM_IP2MAC_OCT1^^}:${VM_IP2MAC_OCT2^^}:${VM_IP2MAC_OCT3^^}:${VM_IP2MAC_OCT4^^}"
###
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/bash_sugar--f/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/vm_xen/run/4.run/vm_tmpl.xl
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/bash_sugar--f/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/vm_xen/run/4.run/vm_tmpl.xl > /tmp/$SrvName.xl
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/bash_sugar--f/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/vm_xen/run/4.run/in4_xen-deploy_vm.sh
### CREATE XL CONF IN SVN ###
#SVN_CONF_PATH="/media/sysdata/in4/companies/$VM_HV_ORG/sdata/roles/hv_xen/$VM_HV_NAME/$Org/$SrvRole/$DeplType"
#mkdir -p  $SVN_CONF_PATH
 #.  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/vm_tmpl.xl > $SVN_CONF_PATH/${SrvName}.xl
 ###
 
 ### PROMOTE VM ON HV ###
 #systemctl -H $VM_HV_NAME start in4_vm-deploy@$FullSrvName
 ##
