#!/bin/bash

if [[ ! -d /media/sysdata/in4/_context ]]; then  

	. /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh os

	echo "Enter SVN password: "
	read SVNPass

	## SVN
	svn status
	sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
	sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers
	##
		
	svn co --username $Org --password $SVNPass https://svn.edss.ee/client/companies/$Org/sdata /media/sysdata/in4/_context/
	
	#rm -f /etc/systemd/system/rev5.service && cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.service /etc/systemd/system/
	#rm -f /etc/systemd/system/rev5.timer && cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.timer /etc/systemd/system/	
	
	#systemctl enable rev5.timer	
	#systemctl daemon-reload
	#systemctl restart rev5.timer		

fi 
