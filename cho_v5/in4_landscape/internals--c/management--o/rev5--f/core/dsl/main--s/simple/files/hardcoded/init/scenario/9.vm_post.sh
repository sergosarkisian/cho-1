#!/bin/bash

### XEN DOMU AUTONAMING  ###
#SYSTEMD
 rm -f  /etc/systemd/system/init_auto_xen.service && cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/xen_domu/init_auto_xen.service /etc/systemd/system/
systemctl enable init_auto_xen
###
