#!/bin/bash
set -e
View="os" 
i=1

if [[ -z $Org ]]; then
    DESC="Please specify organisation deploy this unit for: "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read Org; else Org=$ARG_NUM; fi
fi

if [[ -z $SrvType ]]; then
    DESC="Please specify server type: "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select  SrvType in in4a1-suse-l ;  do  break ; done; else SrvType=$ARG_NUM; fi
fi

if [[ -z $SrvRole ]]; then
    DESC="Please specify server role: "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select  SrvRole in in4 cone2_db cone2_app cone2_ccm cone3_app gate infra ;  do  break ; done; else SrvRole=$ARG_NUM; fi
fi

if [[ -z $DeplType ]]; then
    DESC="Please specify deployment type "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select  DeplType in test dev prod ;  do  break ; done; else DeplType=$ARG_NUM; fi
fi

if [[ -z $Net ]]; then
    DESC="Please specify main network ID (VLAN): "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read Net; else Net=$ARG_NUM; fi
fi

if [[ -z $VM_IP ]]; then
    DESC="Please specify IP address of the main interface + CIDR net (for ex. 10.0.0.1/24)"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read VM_IP; else VM_IP=$ARG_NUM; fi
fi

if [[ -z $SrvContext ]]; then
    DESC="Please specify VM 'alias' - use 'vm' if no alias: "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read SrvContext; else SrvContext=$ARG_NUM; fi
fi



#NET
VM_IP2MAC_OCT1=$( printf "%02x" `echo $VM_IP|cut -d. -f 1`)
VM_IP2MAC_OCT2=$( printf "%02x" `echo $VM_IP|cut -d. -f 2`)
VM_IP2MAC_OCT3=$( printf "%02x" `echo $VM_IP|cut -d. -f 3`)
VM_IP2MAC_OCT4=$( printf "%02x" `echo $VM_IP|cut -d. -f 4|cut -d/ -f 1`)
VM_NETMASK=$( printf "%02x" `echo $VM_IP|cut -d. -f 4|cut -d/ -f 2`)
MACIP="${VM_IP2MAC_OCT1}${VM_IP2MAC_OCT2}${VM_IP2MAC_OCT3}${VM_IP2MAC_OCT4}${VM_NETMASK}"
#MACIP_HA
#

SrvName="$MACIP-$SrvContext-$SrvRole-$DeplType"	
FullSrvName="$SrvName.$SrvType.$Net.$View.$Org.pool"
