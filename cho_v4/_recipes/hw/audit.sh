#!/bin/bash
#zypper dmidecode ipmiutil

DmidecodeDump="/tmp/dmidecode"
dmidecode -q --dump-bin $DmidecodeDump
DmiDecode="dmidecode --from-dump $DmidecodeDump"
StorCli="/tmp/storecli"
/opt/MegaRAID/storcli/storcli64 /c0 show > $StorCli

echo -e "\n\n ### 1 - Base ###\n"
echo "1.1 Base - HW platform : `$DmiDecode -t 1|grep "Manufacturer:"|awk '{print $2}'`"
echo "1.2 Base - motherboard : `$DmiDecode -t 2|grep "Manufacturer:"|awk '{print $2}'` - `$DmiDecode -t 2|grep "Product Name:"|awk '{ $1=$2="";$0=$0;} NF=NF'`"
echo "1.3 Base - FQDN : ` hostname -f`"


echo -e "\n\n ### 2.1 - CPU ###\n"
echo "CPU - model : `$DmiDecode -t 4|grep -m1 "Version:"|awk '{ $1=$2="";$0=$0;} NF=NF'`"
echo "CPU - count : `$DmiDecode -t 4|grep "Family:" -c`"
echo "CPU - overall (with HT) - `$DmiDecode -t 4|grep "Thread Count:"|awk '{print $3}'|xargs | tr ' ' + | bc`"


echo -e "\n\n ### 2.2 - RAM ###\n"
echo "RAM - type :`$DmiDecode -t 17|grep -m1 "Manufacturer:"|awk '{print $2}'` - `$DmiDecode -t 17|grep -m1 "Type:"|awk '{print $2}'`"
echo "RAM - count : `$DmiDecode -t 17|grep "Size:" -c`"
RamMb=`$DmiDecode -t 17|grep "Size:"|awk '{print $2}'|xargs | tr ' ' + | bc`
echo "RAM - usable volume : `echo $(($RamMb/1024))` GB"


echo -e "\n\n ### 2.3 - Disks ### \n"
echo "Disks - count : `cat $StorCli|grep SATA -c`"
echo "Disks - raw volume : `cat $StorCli|grep SATA| awk '{print $5}'|xargs | tr ' ' + | bc`"
echo "Disks - RAID levels : `cat $StorCli|grep RAID|grep "0/"|awk '{print $2" - "$9" "$10}'`"
echo -e "Disks - disks : \n`cat $StorCli|grep SATA| awk '{print $5" "$6" - "$13}'`"


echo -e "\n\n ### 2.4  - Network cards###\n"
echo -e "Network cards: \n `lspci |grep -i network|cut -d: -f3`"


echo -e "\n\n ### 2.5  - FSB ###\n"
echo "FSB : `$DmiDecode -t 17 |grep -m1 "Speed:"|cut -d: -f 2`"


echo -e "\n\n ### 4  - Remote access ###\n"
echo "Remote access - iLO/IPMI : `ipmiutil lan|grep version`"
echo "Remote access - IP: `ipmiutil lan|grep "IP address:"|cut -d: -f 2`"


echo -e "\n\n ### 5  - HW RAID Controller ###\n"
echo "5.1 - HW RAID controller onboard (PCI) : `lspci |grep -i raid -c`"
echo "5.1 - HW RAID controller onboard (sw) : `cat $StorCli|grep "Product Name"|cut -d= -f2 `"
echo "5.2 - HW RAID controller model : `lspci |grep -i raid|cut -d ":" -f3`"
echo "5.3 - HW RAID controller serial: `cat $StorCli|grep "Serial Number"|cut -d= -f 2`"
echo "5.3 - HW RAID controller FW version : `cat $StorCli|grep "FW Version"|cut -d= -f 2`"
echo "5.4 - HW RAID controller BIOS version : `cat $StorCli|grep "BIOS Version"|cut -d= -f 2`"

echo -e "\n\n ### 7  - Additional ###\n"
echo "7.1 - BIOS vendor : `dmidecode -t 0|grep "Vendor:"|awk  '{ $1="";$0=$0;} NF=NF'`"
echo "7.2 - BIOS version : `$DmiDecode -t 0|grep "Version:"|awk '{print $2}'` from `$DmiDecode -t 0|grep "Release Date:"|awk '{print $3}'`"
