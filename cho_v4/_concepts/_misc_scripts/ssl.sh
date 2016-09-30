#!/bin/bash
client=$1
cert_name=$2
file_name=$3

cat /etc/faster/cmdb/data/cert/$client/$cert_name.pem > /etc/ssl/$file_name.both
echo -e "\n" >> /etc/ssl/$file_name.both
svn cat  https://svn.edss.ee/sys/cert/$client/$cert_name.key --no-auth-cache --username your_name >> /etc/ssl/$file_name.both
