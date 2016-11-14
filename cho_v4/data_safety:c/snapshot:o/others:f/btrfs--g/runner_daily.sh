#!/bin/bash

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh os
     
for SNAP_TASK /media/sysdata/in4/_context/conf/snapshots/$Net/$SrvType/$SrvName/daily/; do
    source $SNAP_TASK
    /bin/sh /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/daily.sh	
done
