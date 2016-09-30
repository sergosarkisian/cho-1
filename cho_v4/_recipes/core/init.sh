## REPO & SW ##
zypper ar -cf http://download.opensuse.org/repositories/server:/database:/postgresql/openSUSE_Leap_42.1/server:database:postgresql.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/monitoring:/zabbix/openSUSE_Leap_42.1/server:monitoring:zabbix.repo

#zypper --gpg-auto-import-keys in "zabbix24-server-postgresql" "zabbix24-server" "zabbix24-bash-completion"
#zypper --gpg-auto-import-keys in "bareos-bconsole" "bareos-common" "bareos-database-postgresql" "bareos-database-tools" "bareos-director" "bareos-storage" "bareos-tools"
#zypper --gpg-auto-import-keys in "postgresql"  "postgresql-server" "postgresql-contrib"

#zypper in elasticsearch java-1_8_0-openjdk
##

usermod -G sysapp postgres
usermod -G sysapp zabbixs	
usermod -G sysapp bareos


mkdir  -p /media/storage
mount -a

##ES
./media/sysdata/rev5/techpool/ontology/logitoring/elasticsearch/_recipes/rev5_elasticsearch.sh # non working
##


##Rsyslog
#umount meda-logs
mkdir /media/storage/logs
rm -rf /media/logs/ && ln -s /media/storage/logs /media/logs

mkdir -p /media/logs/atop
mkdir -p /media/logs/syslog_bus/_client
mkdir -p /media/logs/syslog
mkdir -p /media/logs/files
mkdir -p /media/logs/syslog_bus/_core
systemctl enable rev5_rsyslog_i@core
systemctl restart rev5_rsyslog_i@core && systemctl status rev5_rsyslog_i@core
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_rsyslog && ln -s /media/sysdata/rev5/techpool/ontology/logitoring/rsyslog/_firewall/rev5_rsyslog /etc/sysconfig/SuSEfirewall2.d/services/

##

## SQUID ##
/media/sysdata/rev5/techpool/ontology/database/postgres/_recipes/rev5_postgres_simple.sh
##
