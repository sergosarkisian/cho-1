#!/bin/bash
set -e
View="os" 
i=1

if [[ -z $Org ]]; then
    DESC="Please specify organisation deploy this unit for: "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read Org; else Org=$ARG_NUM; fi
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

if [[ -z $DeplType ]]; then
    DESC="Please specify deployment type "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select  DeplType in test dev prod ;  do  break ; done; else DeplType=$ARG_NUM; fi
fi

if [[ -z $SrvRole ]]; then
    DESC="Please specify network ID (VLAN): "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read SrvRole; else SrvRole=$ARG_NUM; fi
fi

if [[ -z $SrvContext ]]; then
    DESC="Please specify network ID (VLAN): "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read SrvContext; else SrvContext=$ARG_NUM; fi
fi

if [[ -z $SrvType ]]; then
    DESC="Please specify network ID (VLAN): "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read SrvType; else SrvType=$ARG_NUM; fi
fi

if [[ -z $SrvName ]]; then
    DESC="Please specify network ID (VLAN): "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read SrvName; else SrvName=$ARG_NUM; fi
fi



if [[ -z $Net ]]; then
    DESC="Please specify network ID (VLAN): "
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; read Net; else Net=$ARG_NUM; fi
fi

MACIP=\"$MACIP\"
MACIP_HA=\"$MACIP_HA\"

SrvName="$MACIP-$SrvContext-$SrvRole-$DeplType"	
NAME="$SrvName.$SrvType.$Net.$View.$Org.pool"
