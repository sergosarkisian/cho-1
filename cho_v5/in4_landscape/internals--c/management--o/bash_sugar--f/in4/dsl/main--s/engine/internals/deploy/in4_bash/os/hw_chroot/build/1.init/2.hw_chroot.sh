#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

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

        echo "If sysdata belongs to in4 linux base disk ($HWBaseDisk) "
        select IN4_SYSDATA_DISK in Yes No
        do
            case $IN4_SYSDATA_DISK in
            "Yes") break;;
            "No") exit 1 ;;
            esac
        done

        echo "!!!   DATA WILL BE DESTROYED ON partition $HWBaseDisk"
        select IN4_SYSDATA_DISK in Yes No
        do
            case $IN4_SYSDATA_DISK in
            "Yes") 
                sudo parted  /dev/$HWBaseDisk mklabel gpt
                sudo parted  /dev/$HWBaseDisk mkpart primary 1MiB 4MiB
                sudo parted  /dev/$HWBaseDisk set 1 bios_grub on
                sudo parted  /dev/$HWBaseDisk mkpart primary btrfs 5MiB ${IN4_SYSTEM_SIZE}GiB                
                sudo parted  /dev/$HWBaseDisk set 2 boot on                                               
                sleep 1
                sudo mkfs.btrfs -f -L "system" /dev/${HWBaseDisk}2
                sudo parted  /dev/$HWBaseDisk mkpart primary linux-swap ${IN4_SYSTEM_SIZE}GiB $(($IN4_SYSTEM_SIZE+$IN4_SWAP_SIZE))GiB
                sleep 1
                sudo mkswap -f -L "swap" /dev/${HWBaseDisk}3
                sudo parted  /dev/$HWBaseDisk mkpart primary btrfs $(($IN4_SYSTEM_SIZE+$IN4_SWAP_SIZE))GiB $(($IN4_SYSTEM_SIZE+$IN4_SWAP_SIZE+$IN4_SYSDATA_SIZE))GiB
                sleep 1
                sudo mkfs.btrfs -f -L "sysdata" /dev/${HWBaseDisk}4
                
            break ;;
            "No") exit 1;;
            esac
        done
        break ;;
    "No") break ;;
    esac
done



### GENERATE LOOP MOUNT & UNTAR ###
sudo mount /dev/${HWBaseDisk}2  $BUILD_ENV/loop/
sudo mkdir -p  $BUILD_ENV/loop/media/sysdata
sudo mount /dev/${HWBaseDisk}4 $BUILD_ENV/loop/media/sysdata
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
