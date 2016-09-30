#!/bin/bash 

## POSTGRES ##
usermod -G sysapp postgres

	
mkdir -p /media/storage/database/postgres
chmod 755 /media/storage/database

chown postgres:postgres /media/storage/database/postgres/
chmod 770 /media/storage/database/postgres/

su - postgres -c "/usr/bin/pg_ctl -D /media/storage/database/postgres initdb -o \"-U localadmin \""

rm -f  /etc/tmpfiles.d/rev5_postgres.conf && ln -s /media/sysdata/rev5/techpool/ontology/database/postgres/_systemd/tmpfiles.conf /etc/tmpfiles.d/rev5_postgres.conf
systemd-tmpfiles --create

rm -f /etc/systemd/system/rev5_postgres.service 			&& cp /media/sysdata/rev5/techpool/ontology/database/postgres/_systemd/rev5_postgres.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_postgres && ln -s /media/sysdata/rev5/techpool/ontology/database/postgres/_firewall/rev5_postgres /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_postgres.service && systemctl restart rev5_postgres.service 
systemctl status rev5_postgres.service 
##
