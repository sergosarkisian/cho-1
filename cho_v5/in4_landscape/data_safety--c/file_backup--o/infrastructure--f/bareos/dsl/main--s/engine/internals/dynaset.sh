#!/bin/bash

service=$1
task_type=$2
instance=$3

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os


if [[ $SrvRole =~ ("_4_") ]]; then
	techname=`echo "$SrvRole"|cut -d "-" -f2|sed -e "s/_4_.*//"`
else
	techname=$SrvRole
fi

############  //  CLIENTSIDE LIST \\ ############



############  \\  CLIENTSIDE LIST // ############



############  // CONE \\ ############

##CONECCM !!
if [[ $SrvRole == "coneccm" ]]; then
	if [[ $task_type == "include" ]]; then
	echo "\
/web/_dsch/$techname/cc
/web/_dsch/$techname/cctrash"
	fi
fi

##CONEAPP2
if [[ $SrvRole == "coneapp2" ]]; then
	if [[ $task_type == "include" ]]; then
	echo "\
/web/_dsch/$techname/user
/web/_dsch/$techname/tmpl
/web/_dsch/$techname/files"
	fi
fi

##CONEAPP3
if [[ $SrvRole == "coneapp3" ]]; then
	if [[ $task_type == "include" ]]; then
	echo "\
/web/_dsch/$techname/neo_db/work
/web/_dsch/$techname/tmpl
/web/_dsch/$techname/files"
	fi
fi

############  \\ CONE // ############


##ORACLE !!
if [[ $SrvRole == "oracle_data" ]]; then

	if [[ $task_type == "include" ]]; then
	echo "\
/media/storage/database/oracle/$SID/manage/conf
/media/storage/database/oracle/$SID/data/main
    "
	fi

	if [[ $task_type == "exclude" ]]; then
	echo ""
	fi

fi

############  // PHP HOSTING \\ ############

if [[ $SrvRole == "phphosting" ]]; then
    if [[ $task_type == "include" ]]; then
    phptechname=`echo $techname |tr _ .`
    echo "\
/media/storage/sites/$phptechname/htdocs
/media/storage/sites/$phptechname/conf"

    fi
fi
############  \\ PHP HOSTING // ############


############  //  CLIENTSIDE LIST \\ ############

if [[ $task_type == "clientside-list" ]]; then
	DIR=$SrvName
	. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os $instance
	cat /media/sysdata/rev5/_context/conf/bareos/backup/$View/$Net/$SrvType/$SrvName/clientside-list
fi
############  \\  CLIENTSIDE LIST // ############
