#!/bin/bash

if [[ ! -d /media/sysdata/rev5/techpool ]]; then  

	. /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh os

	echo "Enter SVN password: "
	read SVNPass

	## SVN
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
	
	### REV5 SERVICE & TIMER
        rm -f /etc/systemd/system/rev5_sync.service 	&& ln -s /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/sync_service/rev5_sync.service 	/etc/systemd/system/
        rm -f /etc/systemd/system/rev5_sync.timer 	&& ln -s /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/sync_service/rev5_sync.timer 	/etc/systemd/system/ 
        ln -s /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/sync_service/rev5_sync.timer /etc/systemd/system/multi-user.target.wants/
        systemctl restart rev5_sync.timer
        ###

fi 
