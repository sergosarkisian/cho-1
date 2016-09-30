#!/bin/sh
. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os

URL="https://ZABBIX/zabbix/api_jsonrpc.php"
ZPass=`cat /media/sysdata/rev5/_context/secure/passwords/zabbix-api.pass`
Template="OS - Linux - Main"

# Authenticate with Zabbix API

AUTH_TOKEN=`wget -O- -o /dev/null $URL --header 'Content-Type: application/json-rpc' --post-data '{"jsonrpc": "2.0","method": "user.login","params": {"user": "org_'"$Org"'","password": "'"$ZPass"'"},"id": 0}' | cut -d'"' -f8`

GET_HOST=`wget -O- -o /dev/null $URL --header 'Content-Type: application/json-rpc' --post-data '{"jsonrpc": "2.0", "method": "host.get", "params": {"output": "extend","filter": {"host": ["'"$hostname"'"]}},"auth": "'"$AUTH_TOKEN"'","id": 1}'`
GET_GROUP_ID=`wget -O- -o /dev/null $URL --header 'Content-Type: application/json-rpc' --post-data '{"jsonrpc": "2.0", "method": "hostgroup.get", "params": {"real_hosts":1,"output": "extend","filter": {"host": ["4.Client - '"$Org"'"]}},"auth": "'"$AUTH_TOKEN"'","id": 1}'| sed -e 's/[{}]/''/g' | sed -e 's/[""]/''/g' | grep -Eo groupid:[0-9]* | cut -d":" -f2;`
GET_TMPL_ID=`wget -O- -o /dev/null $URL --header 'Content-Type: application/json-rpc' --post-data '{"jsonrpc": "2.0", "method": "template.get", "params": {"output": "extend","filter": {"host": ["'"$Template"'"]}},"auth": "'"$AUTH_TOKEN"'","id": 1}' | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^templateid/ {print $2}' | sed 's/\(^"\|"$\)//g' | sed -e 's/["]]/''/g'`


CREATE_HOST=`wget -O- -o /dev/null $URL --header 'Content-Type: application/json-rpc' --post-data '{"jsonrpc": "2.0", "method": "host.create", "params": {"host": "'"$hostname"'", "proxy_hostid": "10228","interfaces": [{"type": 1,"main": 1,"useip": 0,"ip": "0.0.0.0","dns": "'"$hostname"'","port": "10050"}],"groups": [{"groupid":"27"}],"templates":[ {"templateid": "10105"}] },"auth": "'"$AUTH_TOKEN"'","id": 1}'`

