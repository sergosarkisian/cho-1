#!/bin/bash
. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os
if [ ! -f /media/sysdata/rev5/_context/conf/monitoring/$View/$Net/$SrvType/$SrvName.json ]; then
    echo "No JSON file - /media/sysdata/rev5/_context/conf/monitoring/$View/$Net/$SrvType/$SrvName.json"
    exit 1
fi

/usr/bin/nslookup `/bin/hostname -f`
