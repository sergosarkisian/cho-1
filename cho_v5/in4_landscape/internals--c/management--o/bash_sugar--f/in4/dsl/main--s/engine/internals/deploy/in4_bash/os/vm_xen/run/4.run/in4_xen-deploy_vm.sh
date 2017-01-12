#!/bin/bash
set -e
#VM_NAME=$1
#.  $In4_Exec_Path/../../../helpers/naming.sh os $VM_NAME

VM_DISK_FULL_PATH="$VMImageDir/../in4/$VM_DISK_PATH"

SVN_CONF_PATH="/media/sysdata/in4/_context/roles/hv_xen/$VM_HV_NAME/$Org/$SrvRole/$DeplType/$SrvName.xl"

if [[ -d $VM_DISK_FULL_PATH ]]; then
    echo "VM is already exists!!! "; exit 1
else
    mkdir -p $VM_DISK_FULL_PATH
    cp --sparse=always $BuildEnv/../${OsBuild}_${OsSrvType}.raw $VM_DISK_FULL_PATH/${OsBuild}_${OsSrvType}.raw
    fallocate -l 10G $VM_DISK_FULL_PATH/${OsBuild}_${OsSrvType}.raw
    cp --sparse=always $BuildEnv/../swap.raw $VM_DISK_FULL_PATH/swap.raw
    cp --sparse=always $BuildEnv/../sysdata.raw $VM_DISK_FULL_PATH/sysdata.raw
    fallocate -l 20G $VM_DISK_FULL_PATH/sysdata.raw
    #VM_DISK_STORAGE_SIZE=$VM_DISK_STORAGE_SIZE
    #fallocate -l `cat $SVN_CONF_PATH|grep "VM_DISK_STORAGE_SIZE"|cut -d= -f2` $VM_DISK_FULL_PATH/storage.raw ## FROM SVN
    fallocate -l  ${VM_DISK_STORAGE_SIZE_OVERALL}G $VM_DISK_FULL_PATH/storage.raw
    mkfs.btrfs -f -L "storage" $VM_DISK_FULL_PATH/storage.raw
    fallocate -l 1G $VM_DISK_FULL_PATH/storage_meta.raw
    sleep 1
    xl create  /tmp/$SrvName.xl
     #systemctl start in4_vm@$FullSrvName
fi
