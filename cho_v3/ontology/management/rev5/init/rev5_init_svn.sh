#!/bin/bash

if [[ ! -d /media/sysdata/rev5/techpool ]]; then  

	. /media/sysdata/rev5/static/naming.sh os

	echo "Enter SVN password: "
	read SVNPass

	## SVN
	svn status
	sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
	sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers
	##
	
	## PROXY
	sed -i "s/HTTP_PROXY=.*/HTTP_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
	sed -i "s/HTTPS_PROXY=.*/HTTPS_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
	sed -i "s/FTP_PROXY=.*/FTP_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
	sed -i "s/NO_PROXY=.*/NO_PROXY=\"localhost, 127.0.0.1, .ccm, .pool\"/" /etc/sysconfig/proxy	
	sed -i "s/PROXY_ENABLED=.*/PROXY_ENABLED=\"yes\"/" /etc/sysconfig/proxy	
	##
	
	svn co --username $Org --password $SVNPass https://svn.edss.ee/techpool /media/sysdata/rev5/techpool
	svn co --username $Org --password $SVNPass https://svn.edss.ee/client/companies/$Org/sdata /media/sysdata/rev5/_context/
	
	rm -f /etc/systemd/system/rev5.service && cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.service /etc/systemd/system/
	rm -f /etc/systemd/system/rev5.timer && cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.timer /etc/systemd/system/	
	
	systemctl enable rev5.timer	
	systemctl daemon-reload
	systemctl restart rev5.timer		

fi 
