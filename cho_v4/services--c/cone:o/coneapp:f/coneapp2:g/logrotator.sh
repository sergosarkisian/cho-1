#!/bin/bash
type=$1

curr_date="`date +%d.%m`"
prev_date="`date +%d.%m -d "1 day ago"`"


case $type in
    "cone")
        logsource="/web/_deploy/*/logs/*#*"
        find $logsource -type d|while read log_dir; do
            schema=`echo $log_dir|sed -e "s/\/web\/_deploy//"|cut -d "/" -f 2`
            site=`echo $log_dir|sed -e "s/\/web\/_deploy//"|cut -d "/" -f 4`
            logpath="/web/_deploy/$schema/logs/app"

            mkdir -p $logpath/$prev_date && chown -R http:http $logpath/$prev_date
            mv $log_dir $logpath/$prev_date

            #DELETE OLD LOGS
            count_logs=`ls -1A $logpath/|wc -l`
            if [ $count_logs -gt 7 ]; then
                file_to_del=`find $logpath/ -type d -maxdepth 1 -exec stat -c "%Y %n" {} \; | tail +2 |sort -n | head -1 | cut -d' ' -f2`
                echo "Deleting $file_to_del"
                rm -rf $file_to_del
            fi
            done
    ;;

esac
