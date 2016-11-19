#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

echo "Please enter in4 linux base disk"
select IN4_BASEDISK in sda sdb sdc sdd sde 
do  break; done
export IN4_BASEDISK="$IN4_BASEDISK"

echo "Do you need to make disk partitions?"
select PARTED in Yes No
do  

    case $PARTED in
    "Yes") 
    
        echo "Please enter in4 linux main image size in GiB (label = system): "
        select IN4_SYSTEM_SIZE in 10 15 20 
        do  break; done

        echo "Please enter in4 linux swap size in GiB (label = swap): "
        select IN4_SWAP_SIZE in 1 5 10 15 20 
        do  break; done

        echo "Please enter in4 linux sysdata size in GiB (label = sysdata): "
        select IN4_SYSDATA_SIZE in 5 10 15 20 30 40 50 80 100
        do  break; done

        echo "If sysdata belongs to in4 linux base disk ($IN4_BASEDISK) "
        select IN4_SYSDATA_DISK in Yes No
        do
            case $IN4_SYSDATA_DISK in
            "Yes") break;;
            "No") exit 1 ;;
            esac
        done

        echo "!!!   DATA WILL BE DESTROYED ON partition $IN4_BASEDISK"
        select IN4_SYSDATA_DISK in Yes No
        do
            case $IN4_SYSDATA_DISK in
            "Yes") 
                parted  /dev/$IN4_BASEDISK mklabel gpt
                parted  /dev/$IN4_BASEDISK mkpart primary 1MiB 4MiB
                parted  /dev/$IN4_BASEDISK set 1 bios_grub on
                parted  /dev/$IN4_BASEDISK mkpart primary btrfs 5MiB ${IN4_SYSTEM_SIZE}GiB                
                parted  /dev/$IN4_BASEDISK set 2 boot on                                               
                sleep 1
                mkfs.btrfs -f -L "system" /dev/${IN4_BASEDISK}2
                parted  /dev/$IN4_BASEDISK mkpart primary linux-swap ${IN4_SYSTEM_SIZE}GiB $(($IN4_SYSTEM_SIZE+$IN4_SWAP_SIZE))GiB
                sleep 1
                mkswap -f -L "swap" /dev/${IN4_BASEDISK}3
                parted  /dev/$IN4_BASEDISK mkpart primary btrfs $(($IN4_SYSTEM_SIZE+$IN4_SWAP_SIZE))GiB $(($IN4_SYSTEM_SIZE+$IN4_SWAP_SIZE+$IN4_SYSDATA_SIZE))GiB
                sleep 1
                mkfs.btrfs -f -L "sysdata" /dev/${IN4_BASEDISK}4
                
            break ;;
            "No") exit 1;;
            esac
        done
        break ;;
    "No") break ;;
    esac
done



### GENERATE LOOP MOUNT & UNTAR ###
mount /dev/${IN4_BASEDISK}2  $BUILD_ENV/loop/
mkdir -p  $BUILD_ENV/loop/media/sysdata
mount /dev/${IN4_BASEDISK}4 $BUILD_ENV/loop/media/sysdata
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
