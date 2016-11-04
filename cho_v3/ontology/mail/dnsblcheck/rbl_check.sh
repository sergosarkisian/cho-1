#!/usr/bin/env bash
SRV="$1"
DEBUG="$2"

. ./dnsbl_list

for server in $SRV
do
if [[ $server =~ [0-9]*\.[0-9]*\.[0-9]*\.[0-9]* ]]; then
    ip=$server
else
    ip=$(dig +short $server)
fi
    r_ip=$(echo $ip|awk -F"." '{for(i=NF;i>0;i--) printf i!=1?$i".":"%s",$i}')
    for rbl in $RBL
    do
        if [ ! -z "$DEBUG" ]
        then
            echo "testing $server ($ip) against $rbl"
        fi
        result=$(dig +short +time=5 $r_ip.$rbl)
        if [ ! -z "$result" ]
        then
            echo "$server ($ip) is in $rbl with code $result"
        fi
        if [[ ! -z "$DEBUG" && -z "$result" ]]
        then
            echo "\`->negative"
        fi
    done
done
