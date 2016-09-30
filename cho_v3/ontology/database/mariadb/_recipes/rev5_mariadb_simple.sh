#!/bin/bash 

## MARIADB ##
usermod -G sysapp mysql

	
mkdir -p /media/storage/database/mysql
chmod 755 /media/storage/database

chown mysql:mysql /media/storage/database/mysql/
chmod 770 /media/storage/database/mysql/

mount -t tmpfs size=1G /tmp/mariadb
tmpfs /tmp/mariadb tmpfs rw,gid=485,uid=60,size=1G,nr_inodes=10k,mode=0770 0 0

rm -f  /etc/tmpfiles.d/rev5_mariadb.conf && ln -s /media/sysdata/rev5/techpool/ontology/database/mariadb/_systemd/tmpfiles.conf /etc/tmpfiles.d/rev5_mariadb.conf
systemd-tmpfiles --create

rm -f /etc/systemd/system/rev5_mariadb_i@.service && cp /media/sysdata/rev5/techpool/ontology/database/mariadb/_systemd/rev5_mariadb_i@.service /etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_mariadb && ln -s /media/sysdata/rev5/techpool/ontology/database/mariadb/_firewall/rev5_mariadb /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_mariadb_i@simple && systemctl restart rev5_mariadb_i@simple

mysql mysql < /media/sysdata/rev5/techpool/ontology/database/mariadb/sql/long_usernames.sql
mysql < /usr/share/mariadb/mysql_performance_tables.sql

#'/usr/bin/mysqladmin' -u root password 'new-password'
#'/usr/bin/mysqladmin' -u root -h 0a64678d-vm-webapp-prod password 'new-password'

##
