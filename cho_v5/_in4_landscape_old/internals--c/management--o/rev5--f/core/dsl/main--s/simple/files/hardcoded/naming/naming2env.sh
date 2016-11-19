#!/bin/bash

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os
echo  "\
Org=\"$Org\"
Net=\"$Net\"
View=\"$View\" 
SrvType=\"$SrvType\"
SrvName=\"$SrvName\"
MACIP=\"$MACIP\"
MACIP_HA=\"$MACIP_HA\"
SrvContext=\"$SrvContext\"
SrvRole=\"$SrvRole\"
DeplType=\"$DeplType\"" > /run/naming_os
