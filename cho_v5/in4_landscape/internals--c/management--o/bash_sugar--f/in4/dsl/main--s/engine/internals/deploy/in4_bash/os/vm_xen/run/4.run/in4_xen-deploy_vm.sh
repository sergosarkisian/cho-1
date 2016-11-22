#!/bin/bash
set -e
#VM_NAME=$1
#.  $In4_Exec_Path/../../../helpers/naming.sh os $VM_NAME

VM_DISK_FULL_PATH="$VMImageDir/../in4/$VM_DISK_PATH"

SVN_CONF_PATH="/media/sysdata/in4/_context/roles/hv_xen/$VM_HV_NAME/$Org/$SrvRole/$DeplType/$SrvName.xl"

if [[ -d $VM_DISK_FULL_PATH ]]; then
    echo "VM is already exists!!! "; exit 1
else
    mkdir $VM_DISK_FULL_PATH
    cp --sparse=always $BuildEnv/../$In4NamingOsSrvType.raw $VM_DISK_FULL_PATH/$In4NamingOsSrvType.raw
    cp --sparse=always $BuildEnv/../swap.raw $VM_DISK_FULL_PATH/swap.raw
    cp --sparse=always $BuildEnv/../sysdata.raw $VM_DISK_FULL_PATH/sysdata.raw
    #VM_DISK_STORAGE_SIZE=$VM_DISK_STORAGE_SIZE
    #fallocate -l `cat $SVN_CONF_PATH|grep "VM_DISK_STORAGE_SIZE"|cut -d= -f2` $VM_DISK_FULL_PATH/storage.raw
    fallocate -l  ${VM_DISK_STORAGE_SIZE}G $VM_DISK_FULL_PATH/storage.raw
    fallocate -l 1G $VM_DISK_FULL_PATH/storage_meta.raw
    sleep 1
     #systemctl start in4_vm@$FullSrvName
fi
