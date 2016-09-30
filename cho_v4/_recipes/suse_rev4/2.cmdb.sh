#!/bin/bash
 

##CMDB
mkdir /etc/faster && cd /etc/faster && svn co https://svn.edss.ee/sys/cmdb

	groupadd -g 999 sysapp
	usermod -G sysapp named 
	usermod -G sysapp mail
	usermod -G sysapp haproxy
	usermod -G sysapp bareos
	
	##ACLs
	# Set root permissions	
	chmod -R 700 /etc/faster/cmdb
	chown -R root:root /etc/faster/cmdb
	setfacl -R -m u:root:rwx /etc/faster/cmdb
	setfacl -R -m d:u:root:rwx /etc/faster/cmdb
	
	#Set system app permissions
	setfacl -R -m g:sysapp:rx /etc/faster/cmdb
	setfacl -R -m d:g:sysapp:rx /etc/faster/cmdb	
	

	#setfacl - others
	setfacl -R -m u::rwx /etc/faster/cmdb
	setfacl -R -m g::rwx /etc/faster/cmdb
	setfacl -R -m d:u::rwx /etc/faster/cmdb
	setfacl -R -m d:g::rwx /etc/faster/cmdb

	cp /etc/faster/cmdb/cmdb.service /usr/lib/systemd/system/
	cp /etc/faster/cmdb/cmdb.timer /usr/lib/systemd/system/
	systemctl enable cmdb.timer	
	systemctl daemon-reload
	systemctl restart cmdb.timer	