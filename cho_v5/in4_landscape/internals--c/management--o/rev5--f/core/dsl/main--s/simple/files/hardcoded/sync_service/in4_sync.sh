#!/bin/bash

SVN_UP_CONTEXT=`svn st -u /media/sysdata/in4/_context/|grep "*" -c`

if [[ $SVN_UP_CONTEXT != "0" ]]; then
	svn up /media/sysdata/rev5/techpool/
	svn up /media/sysdata/in4/_context/
	
	# Set root permissions	
	setfacl -R -m u:root:rwx /etc/rev5
	setfacl -R -m d:u:root:rwx /etc/rev5
	
	#Set system app permissions
	setfacl -R -m g:sysapp:rx /etc/rev5
	setfacl -R -m d:g:sysapp:rx /etc/rev5	
	
	#setfacl - others
	setfacl -R -m u::rwx /etc/rev5
	setfacl -R -m g::rwx /etc/rev5
	setfacl -R -m d:u::rwx /etc/rev5
	setfacl -R -m d:g::rwx /etc/rev5	
fi
