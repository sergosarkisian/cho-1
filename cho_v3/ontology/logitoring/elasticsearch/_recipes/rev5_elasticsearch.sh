#!/bin/bash 

## BIND9 ##
mkdir -p /media/storage/database/elasticsearch
chown elasticsearch:elasticsearch /media/storage/database/elasticsearch
chmod 755 /media/storage/database/elasticsearch
chmod 755 /media/storage/database

rm -f /etc/systemd/system/rev5_elasticsearch.service 			&& cp /media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/_systemd/rev5_elasticsearch.service 	/etc/systemd/system/ 
#rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_elasticsearch && ln -s /media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/_firewall/rev5_elasticsearch /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_elasticsearch.service && systemctl restart rev5_elasticsearch.service 
systemctl status rev5_elasticsearch.service 
##
