
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #
### FIRMWARE UPGRADE
#IPMI - > SUPERMICRO GUI
# SETUP - #ipmiutil lan -I 10.251.2.101 -S 255.255.255.0 -h 2521 -G 10.251.2.254 -e

#BIOS -> http://blog.smalleycreative.com/administration/updating-the-bios-firmware-on-the-supermicro-x9drw-if/fi
mkdir /boot/dos
wget http://public.edss.ee/software/HW/BIOS/bios.tar.gz -P /boot/dos
cd /boot/dos && tar -xzf bios.tar.gz
chmod -R 755 /boot/dos
#change bios.rom to MB model BIOS ROM

#add to grub.cfg after 00_header:
### BEGIN /etc/grub.d/01_linux ###
menuentry 'bios_upgrade'  --class dos --class os $menuentry_id_option 'msdos' {
set gfxpayload=text
insmod gzio
insmod part_gpt.
echo 'Loading bios_upgrade ...'
  linux16 /boot/dos/memdisk
echo 'Loading initial ramdisk ...'
  initrd16 /boot/dos/bios.img  
  }
##reboot, select grub menu

# in DOS run ami

#RAID
#2208
wget http://public.edss.ee/software/HW/RAID/mr2208fw.rom -P /tmp/firmware
#2108
wget http://public.edss.ee/software/HW/RAID/mr2108fw.rom -P /tmp/firmware

/opt/MegaRAID/storcli/storcli64 /c0 download file=/tmp/firmware/mr2208fw.rom
##
