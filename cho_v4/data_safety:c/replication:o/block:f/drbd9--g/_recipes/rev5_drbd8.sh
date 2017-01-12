#!/bin/bash 

## DRBD9 ##

rm -f /etc/drbd.conf && ln -s /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/drbd.conf /etc/

rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_drbd8 && ln -s /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/_firewall/rev5_drbd8 /etc/sysconfig/SuSEfirewall2.d/services/


rm -f /etc/systemd/system/media-storage.mount 			&& cp /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/_systemd/ext4_media-storage.mount 	/etc/systemd/system/media-storage.mount
rm -f /etc/systemd/system/rev5_drbd8-makemaster_storage.service 			&& cp /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/_systemd/rev5_drbd8-makemaster_storage.service 	/etc/systemd/system/ 
rm -f /etc/systemd/system/rev5_drbd8-up_storage.service 			&& cp /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/_systemd/rev5_drbd8-up_storage.service 	/etc/systemd/system/ 
rm -f /etc/systemd/system/rev5_replica-master_storage.service 			&& cp /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/_systemd/rev5_replica-master_storage.service 	/etc/systemd/system/ 
rm -f /etc/systemd/system/rev5_replica-slave_storage.service 			&& cp /media/sysdata/rev5/techpool/ontology/data_safety/drbd8/_systemd/rev5_replica-slave_storage.service 	/etc/systemd/system/ 


systemctl daemon-reload
##
