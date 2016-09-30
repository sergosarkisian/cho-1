

## BIND9 ##
 /media/sysdata/rev5/techpool/ontology/proxies/bind9/_recipes/rev5_bind9.sh
 echo "search s.pool
nameserver 127.0.0.1
#nameserver 8.8.8.8" > /etc/resolv.conf

##

## EXIM ##
 /media/sysdata/rev5/techpool/ontology/mail/exim/mta-router/_recipes/rev5_exim.sh
##


## HAPROXY ##
 /media/sysdata/rev5/techpool/ontology/proxies/haproxy/_recipes/rev5_haproxy-gate.sh
##

##SUSEFW2 ##
systemctl enable rev5_SuSEfirewall2_i@netfilter && systemctl restart rev5_SuSEfirewall2_i@netfilter
##

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os
rm -f  /etc/iproute2/rt_tables && ln -s /media/sysdata/rev5/_context/conf/netfilter/$Net/$SrvType/$SrvName/rt_tables_symlink /etc/iproute2/rt_tables
#exec iprules
#+ADD SYSTEMD SERVICE
