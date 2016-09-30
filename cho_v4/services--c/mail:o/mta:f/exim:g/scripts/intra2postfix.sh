#!/bin/bash
rm -f /etc/postfix/mailaliases_
wget http://intra./mailaliases_ -P /etc/postfix -T 10 

SIZE=$(du -sb /etc/postfix/mailaliases_ | awk '{ print $1 }')

if ((SIZE<50)); then 
    echo "Seems file is wrong"; 
    exit 1
else 
    echo "Applying virtuals"; 
    /usr/sbin/postmap /etc/postfix/mailaliases_
    mv /etc/postfix/mailaliases_ /etc/postfix/mailaliases__current
fi
