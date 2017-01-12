#!/bin/bash
set -e

###     1 - ORG    ###
if [[ -z $Org ]]; then
    DESC="Please specify organisation deploy this unit for: "
    echo $DESC; read Org;
fi
###

###     2 - View    ###
View="os" 
###

###     3 -  NET   ###
if [[ -z $Net ]]; then
    DESC="Please specify main network ID (VLAN): "
    echo $DESC; read Net;
fi
###

###     4 - OsSrvType    ###
if [[ -z $OsSrvType ]]; then
    export $(cat /etc/os-release | xargs);
    OsVersionWoDot=`"$VERSION"|sed -e "s/\./_/" -e "s/\-/_/"`
    OsSrvType="$OsVersionWoDot-$ID-l"
fi
###

###     5 -  OsBuild   ###
if [[ -z $OsBuild ]]; then
    export $(cat /etc/in4-release | xargs);
    OsBuild="$OsBuildDate-$OsBuildGitTag-in4"
fi
###

###     6 -  SrvName   ###
if [[ -z $SrvRole ]]; then
    DESC="Please specify server role: "
    echo $DESC; select  SrvRole in basic c2db c2app c2ccm c3app gate infra php we2;  do  break ; done;
fi

if [[ -z $DeplType ]]; then
    DESC="Please specify deployment type "
    echo $DESC; select  DeplType in test dev prod ;  do  break ; done; 
fi

if [[ -z $VM_IP ]]; then
    DESC="Please specify IP address of the main interface + CIDR net (for ex. 10.0.0.1/24)"
    echo $DESC; read VM_IP; 
fi

if [[ -z $SrvContext ]]; then
    DESC="Please specify VM 'alias' - use 'vm' if no alias: "
    echo $DESC; read SrvContext; 
fi
###



#NET
VM_IP2MAC_OCT1=$( printf "%02x" `echo $VM_IP|cut -d. -f 1`)
VM_IP2MAC_OCT2=$( printf "%02x" `echo $VM_IP|cut -d. -f 2`)
VM_IP2MAC_OCT3=$( printf "%02x" `echo $VM_IP|cut -d. -f 3`)
VM_IP2MAC_OCT4=$( printf "%02x" `echo $VM_IP|cut -d. -f 4|cut -d/ -f 1`)
VM_NETMASK=$( printf "%02x" `echo $VM_IP|cut -d. -f 4|cut -d/ -f 2`)
MACIP="${VM_NETMASK}${VM_IP2MAC_OCT1}${VM_IP2MAC_OCT2}${VM_IP2MAC_OCT3}${VM_IP2MAC_OCT4}"
#MACIP_HA
#

SrvName="$MACIP-$SrvContext-$SrvRole-$DeplType"	
FullSrvName="$SrvName.$OsBuild.$OsSrvType.$Net.$View.$Org.pool"
