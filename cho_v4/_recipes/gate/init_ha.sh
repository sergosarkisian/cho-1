##SUSEFW2 ##

systemctl disable rev5_SuSEfirewall2_i@netfilter && systemctl stop rev5_SuSEfirewall2_i@netfilter && systemctl status rev5_SuSEfirewall2_i@netfilter

systemctl enable rev5_SuSEfirewall2_i@netfilter-ha && systemctl restart rev5_SuSEfirewall2_i@netfilter-ha && systemctl status rev5_SuSEfirewall2_i@netfilter-ha
##


## BIND9 ##
 /media/sysdata/rev5/techpool/ontology/proxies/bind9/_recipes/rev5_bind9-ha.sh
  echo "search s.pool
nameserver 127.0.0.1
#nameserver 8.8.8.8" > /etc/resolv.conf
##

## EXIM ##
 /media/sysdata/rev5/techpool/ontology/mail/exim/mta-router/_recipes/rev5_exim-ha.sh
##


## HAPROXY ##
 /media/sysdata/rev5/techpool/ontology/proxies/haproxy/_recipes/rev5_haproxy-ha-gate.sh
##


## NETFILTER ##
 /media/sysdata/rev5/techpool/ontology/network/netfilter/_recipes/rev5_netfilter.sh
##
