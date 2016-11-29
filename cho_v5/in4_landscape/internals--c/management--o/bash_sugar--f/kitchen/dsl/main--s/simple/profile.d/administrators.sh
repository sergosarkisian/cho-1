alias sget_http='sudo /usr/bin/su - http'
alias sget_oracle='sudo /usr/bin/su - oracle'
alias ssystemctl='sudo /usr/bin/systemctl'
alias sxl='sudo /usr/sbin/xl'
alias siotop='sudo /usr/sbin/iotop'
alias satop='sudo /usr/bin/atop'
alias szypper='sudo /usr/bin/zypper'
alias sreboot='sudo /sbin/reboot'
alias sdrbdadm='sudo /usr/sbin/drbdadm'
alias sdrbdsetup='sudo /usr/sbin/drbdsetup'
alias smount='sudo /usr/bin/mount'
alias smkfs.ext4='sudo /usr/sbin/mkfs.ext4'
alias smount.ocfs2='sudo /sbin/mount.ocfs2'
alias smkfs.ocfs2='sudo /sbin/mkfs.ocfs2'
alias sget_vmadmin='sudo /usr/bin/su - vmadmin'
alias sless='sudo /usr/bin/less'
alias smore='sudo /usr/bin/more'
alias sl='sudo /usr/bin/ls -alF'
alias sls='sudo /usr/bin/ls'
alias stailf='sudo /usr/bin/tailf'
alias stail='sudo /usr/bin/tail'
alias spure-pw='sudo /usr/bin/pure-pw'
alias scat='sudo /usr/bin/cat'
alias sswapoff='sudo /usr/sbin/swapoff'
alias sswapon='sudo /usr/sbin/swapon'
alias sbconsole='sudo /usr/sbin/bconsole'
alias szabbix-sender='sudo /usr/sbin/zabbix-sender'
alias szabbix-lld='sudo /etc/faster/cmdb/techpool/_admin/lld.rb'
alias sget_root='sudo /etc/faster/cmdb/techpool/_admin/get_root.sh'
alias sraid_lsi_status_megacli="sudo /opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -Lall -aALL|grep State"
alias sraid_lsi_status="sudo /opt/MegaRAID/storcli/storcli64 /c0 /vall show |grep RAID"
alias sraid_lsi_disks_megacli="sudo /opt/MegaRAID/MegaCli/MegaCli64 -PDlist -aALL -NoLog|egrep 'Slot|state'"
alias sraid_lsi_disks="sudo /opt/MegaRAID/storcli/storcli64 /c0 /eall /sall show |grep SATA'"
alias sraid_lsi_rebuild_megacli="sudo /opt/MegaRAID/MegaCli/MegaCli64 -PDRbld -ShowProg PhysDrv"
#YAST
alias syast_firewall='sudo /sbin/yast firewall'
alias syast_lan='sudo /sbin/yast lan'
#HAPROXY
alias scheck_haproxy_http='sudo /usr/sbin/haproxy -c -f /etc/faster/cmdb/data/haproxy/`hostname`_http.conf'
alias scheck_haproxy_tcp='sudo /usr/sbin/haproxy -c -f /etc/faster/cmdb/data/haproxy/`hostname`_tcp.conf'
#HAPROXYi
alias scheck_haproxyi_rev4to5='sudo ls /media/sysdata/rev5/_context/conf/haproxy/rev4/`hostname`/|grep ".conf"| while read x; do echo -e "\n ## conf - $x"; sudo /usr/sbin/haproxy -c -f  /media/sysdata/rev5/_context/conf/haproxy/rev4/`hostname`/$x; done'
#BIND9
alias scheck_named='sudo /usr/sbin/named-checkconf -z|grep -E "(error|failed)"; echo "Bind9 check"'
#BACULA
alias scheck_bacula='sudo /usr/sbin/bacula-dir -t; sudo /usr/sbin/bacula-sd -t; '
#SSL CERTS
alias gen_ssl_both='sudo /etc/faster/cmdb/techpool/_admin/ssl.sh'
#PHP SITES
alias site_add='sudo /etc/faster/cmdb/techpool/_admin/site_add.sh'
