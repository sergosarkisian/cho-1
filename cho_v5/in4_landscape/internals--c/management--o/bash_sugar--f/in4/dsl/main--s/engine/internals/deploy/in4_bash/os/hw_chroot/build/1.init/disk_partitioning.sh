#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

if [[ -z $RecreatePartitions ]]; then
    echo "Do you need to make disk partitions?"
    select RecreatePartitions in Yes No
    do  break; done        
fi

    case $RecreatePartitions in
    "Yes") 

        if [[ -z $DiskSizingUnit ]]; then
            DiskSizingUnit="GiB"
        fi
    
        if [[ -z $In4Disk_SystemSize ]]; then
            echo "Please enter in4 linux main image size in GiB (label = system): "
            select In4Disk_SystemSize in 10 15 20 30
            do  break; done        
        fi

        if [[ -z $In4Disk_SwapSize ]]; then
            echo "Please enter in4 linux swap size in GiB (label = swap): "
            select In4Disk_SwapSize in 1 5 10 15 20 
            do  break; done
        fi

        if [[ -z $In4Disk_SysdataSize ]]; then        
            echo "Please enter in4 linux sysdata size in GiB (label = sysdata): "
            select In4Disk_SysdataSize in 5 10 15 20 30 40 50 80 100 100%
            do  break; done
        fi
               

        if [[ -z $In4Disk_StorageOnBaseDisk ]]; then        
            echo "If storage disk belongs to in4 linux base disk ($HWBaseDisk) "
            select In4Disk_StorageOnBaseDisk in Yes No
            do
                case $In4Disk_StorageOnBaseDisk in
                "Yes") 
                    if [[ -z $In4Disk_StorageSize ]]; then        
                        echo "Please enter in4 linux sysdata size in GiB (label = sysdata): "
                        select In4Disk_StorageSize in 5 10 15 20 30 40 50 80 100 100%
                        do  break; done
                    fi                        
                ;;
                esac
            done
        fi

        echo "!!!   DATA WILL BE DESTROYED ON partition $HWBaseDisk"
        select DataDestroy in Yes No
        do
            case $DataDestroy in
            "Yes") 
                ### all data in the same partition
                ## % in parted
                    sudo parted  /dev/$HWBaseDisk mklabel gpt
                    sudo parted  /dev/$HWBaseDisk mkpart primary 1MiB 4MiB
                    sudo parted  /dev/$HWBaseDisk set 1 bios_grub on
                    sudo parted  /dev/$HWBaseDisk mkpart primary btrfs 5MiB ${In4Disk_SystemSize}$DiskSizingUnit             
                    sudo parted  /dev/$HWBaseDisk set 2 boot on                                               
                    sleep 1
                    sudo mkfs.btrfs -f -L "system" /dev/${HWBaseDisk}2
                    sudo parted  /dev/$HWBaseDisk mkpart primary linux-swap ${In4Disk_SystemSize}$DiskSizingUnit $(($In4Disk_SystemSize+$In4Disk_SwapSize))$DiskSizingUnit
                    sleep 1
                    sudo mkswap -f -L "swap" /dev/${HWBaseDisk}3
                    sudo parted  /dev/$HWBaseDisk mkpart primary btrfs $(($In4Disk_SystemSize+$In4Disk_SwapSize))$DiskSizingUnit $(($In4Disk_SystemSize+$In4Disk_SwapSize+$In4Disk_SysdataSize))$DiskSizingUnit
                    sleep 1
                    sudo mkfs.btrfs -f -L "sysdata" /dev/${HWBaseDisk}4
                    
                    sudo mount /dev/${HWBaseDisk}2  $BuildEnv/loop/
                    sudo mkdir -p  $BuildEnv/loop/media/sysdata
                    sudo mount /dev/${HWBaseDisk}4 $BuildEnv/loop/media/sysdata
                if [[ $In4Disk_StorageOnBaseDisk == "Yes" ]]; then
                    if [[ ]]; then
                    else
                    FdiskEnd="$(($In4Disk_SystemSize+$In4Disk_SwapSize+$In4Disk_SysdataSize))$DiskSizingUnit"
                    fi                
                    sudo parted  /dev/$HWBaseDisk mkpart primary btrfs $(($In4Disk_SystemSize+$In4Disk_SwapSize+$In4Disk_SysdataSize))$DiskSizingUnit 
                    sleep 1
                    sudo mkfs.btrfs -f -L "sysdata" /dev/${HWBaseDisk}5                    
                fi
                
            break ;;
            "No") exit 1;;
            esac
        done
        break ;;
    "No") break ;;
esac

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
