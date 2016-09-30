## REPO & SW ##
zypper ar -cf http://download.opensuse.org/repositories/server:/proxy/openSUSE_Leap_42.1/server:proxy.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/monitoring:/zabbix/openSUSE_Leap_42.1/server:monitoring:zabbix.repo
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/proxy--o:/multi--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:services--c:proxy--o:multi--f.repo
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/mail--o:/mta--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:services--c:mail--o:mta--f.repo
zypper --gpg-auto-import-keys in "haproxy" "nginx-syslog" "squid" "zabbix30-proxy" "zabbix30-proxy-sqlite" "bind" "bind-chrootenv" "bind-utils" "proxy-suite" "exim"

suricata suricata-rules-etopen
# "openvpn"
##

usermod -G sysdata zabbixs	
usermod -G sysdata named	
usermod -G sysdata haproxy
usermod -G sysdata mail

. /media/sysdata/rev5/techpool/ontology/virtualization/xen/domu/xen_udev_gen.sh
. /media/sysdata/rev5/techpool/ontology/virtualization/xen/domu/xen_interfaces_gen.sh 


rm -f /etc/sysconfig/network/ifcfg-eth0
rm -f /etc/sysconfig/network/routes



## SQUID ##
/media/sysdata/rev5/techpool/ontology/proxies/squid/_recipes/rev5_squid_minimal.sh
##

## FTP-PROXY ##
 /media/sysdata/rev5/techpool/ontology/proxies/ftp-proxy/_recipes/rev5_ftp-proxy.sh
##


## ZABBIX PROXY ##
 /media/sysdata/rev5/techpool/ontology/logitoring/zabbix/_recipes/rev5_zabbix-proxy.sh
##


