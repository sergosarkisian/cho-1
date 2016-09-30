#!/bin/bash
rm -f /etc/postfix/mailaliases
wget http://intra./mailaliases -P /etc/postfix -T 10 

SIZE=$(du -sb /etc/postfix/mailaliases | awk '{ print $1 }')

if ((SIZE<50)); then 
    echo "Seems file is wrong"; 
    exit 1
else 
    echo "Applying virtuals"; 
    /usr/sbin/postmap /etc/postfix/mailaliases
    mv /etc/postfix/mailaliases /etc/postfix/mailaliases_current
fi
