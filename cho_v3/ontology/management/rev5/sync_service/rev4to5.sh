#!/bin/bash

SVN_UP_CONTEXT=`svn st -u /media/sysdata/rev5/_context/|grep "*" -c`
SVN_UP_TECHPOOL=`svn st -u /media/sysdata/rev5/techpool/|grep "*" -c`

if [[ $SVN_UP_CONTEXT != "0" || $SVN_UP_TECHPOOL != "0" ]]; then
	svn up /media/sysdata/rev5/*
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

SVN_UP_REV4=`svn st -u /etc/faster/cmdb/|grep "*" -c`

if [[ $SVN_UP_REV4 != "0" ]]; then
        svn up /etc/faster/cmdb/
        # Set root permissions
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

        #Set admin permissions
        setfacl -m g:admin:rx /etc/faster/cmdb
        setfacl -m d:g:admin:rx /etc/faster/cmdb
        setfacl -m g:admin:rx /etc/faster/cmdb/techpool
        setfacl -m d:g:admin:rx /etc/faster/cmdb/techpool
        setfacl -R -m g:admin:rx /etc/faster/cmdb/techpool/_admin
        setfacl -R -m d:g:admin:rx /etc/faster/cmdb/techpool/_admin

        #Set power permissions
        setfacl -m g:power:rx /etc/faster/cmdb
        setfacl -m d:g:power:rx /etc/faster/cmdb
        setfacl -m g:power:rx /etc/faster/cmdb/techpool
        setfacl -m d:g:power:rx /etc/faster/cmdb/techpool
        setfacl -R -m g:power:rx /etc/faster/cmdb/techpool/_admin
        setfacl -R -m d:g:power:rx /etc/faster/cmdb/techpool/_admin

fi


