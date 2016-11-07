#!/bin/bash

SVN_UP_CONTEXT=`svn st -u /media/sysdata/rev5/_context/|grep "*" -c`
SVN_UP_TECHPOOL=`svn st -u /media/sysdata/rev5/techpool/|grep "*" -c`

if [[ $SVN_UP_CONTEXT != "0" || $SVN_UP_TECHPOOL != "0" ]]; then
	svn up /media/sysdata/rev5/techpool/
	svn up /media/sysdata/rev5/_context/
	
	# Set root permissions	
	setfacl -R -m u:root:rwx /media/sysdata/rev5
	setfacl -R -m d:u:root:rwx /media/sysdata/rev5
	
	#Set system app permissions
	setfacl -R -m g:sysapp:rx /media/sysdata/rev5
	setfacl -R -m d:g:sysapp:rx /media/sysdata/rev5	
	
	#setfacl - others
	setfacl -R -m u::rwx /media/sysdata/rev5
	setfacl -R -m g::rwx /media/sysdata/rev5
	setfacl -R -m d:u::rwx /media/sysdata/rev5
	setfacl -R -m d:g::rwx /media/sysdata/rev5	
	
fi


if [[ ! -f /media/sysdata/rev5/firstinit.invasive && ! -d /etc/faster/cmdb ]]; then  

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os

exec once.sh
	touch /media/sysdata/rev5/firstinit.invasive
fi
