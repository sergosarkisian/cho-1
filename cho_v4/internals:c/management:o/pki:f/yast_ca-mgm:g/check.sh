#!/bin/bash
#USAGE: certcheck.sh "{PATH}" "{STATE}"
CERT_PATH=$1
STATE=$2
CURRENT_TIME=`date +%s`

find $CERT_PATH -type f  \( -name "*.pem" -o -name "*pem*" \) | while read file; do
    DUE_DATE=`openssl x509 -noout -in $file -enddate|cut -d"=" -f 2`
    if [[ $DUE_DATE != "" ]]; then
        DUE_DATE_UNIX=`date --date="$DUE_DATE" +%s`
            if (($((DUE_DATE_UNIX - CURRENT_TIME)) < 2419200)); then
                echo "WARNING!!! Certificate will be expired in one month - $file"
                openssl x509 -noout -in $file -subject -issuer -dates
            else
                if [[ $STATE == "all" ]]; then
                echo "Valid Certificate - $file"
                openssl x509 -noout -in $file -subject -issuer -dates
                fi
            fi
    fi
    #
done
