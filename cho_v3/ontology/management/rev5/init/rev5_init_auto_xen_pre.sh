#!/bin/bash

mkdir -p /media/sysdata/rev5/static
cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/ifcfg-tmpl /media/sysdata/rev5/static/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/hosts /media/sysdata/rev5/static/

cp /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh  /media/sysdata/rev5/static/

cp /media/sysdata/rev5/techpool/ontology/management/rev5/init/rev5_init_auto_xen.sh  /media/sysdata/rev5/static/
cp /media/sysdata/rev5/techpool/ontology/management/rev5/init/rev5_init_svn.sh  /media/sysdata/rev5/static/
rm -f  /etc/systemd/system/rev5_init_auto_xen.service && cp /media/sysdata/rev5/techpool/ontology/management/rev5/init/_systemd/rev5_init_auto_xen.service /etc/systemd/system/rev5_init_auto_xen.service

