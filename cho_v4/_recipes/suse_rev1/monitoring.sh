zypper --gpg-auto-import-keys --non-interactive rm unixODBC-devel unixODBC
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/erlang/openSUSE_12.2/devel:languages:erlang.repo
zypper --non-interactive  in ftp://mirror.switch.ch/pool/4/mirror/opensuse/distribution/12.1/repo/oss/suse/x86_64/unixODBC-2.2.12-212.1.2.x86_64.rpm
zypper --gpg-auto-import-keys --non-interactive in erlang erlang-jiffy
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/ruby/openSUSE_12.1/devel:languages:ruby.repo
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/ruby:/extensions/openSUSE_12.2/devel:languages:ruby:extensions.repo
zypper --non-interactive up ruby*
zypper --gpg-auto-import-keys --non-interactive in rubygem-json

mkdir -p /etc/faster && mkdir  -p /etc/zabbix
   cd /etc/faster && svn co http://svn.edss.ee/sys/cmdb --non-interactive
   
   
/usr/bin/ruby /etc/faster/cmdb/cmdb.rb
   
   
cat > /lib/systemd/system/cmdb.service

[Unit]
Description=Runs CMDB tasks configuration
Requires=var-run.mount nss-lookup.target network.target remote-fs.target rsyslog.service time-sync.target
After=var-run.mount nss-lookup.target network.target remote-fs.target rsyslog.service time-sync.target
# Wants=
# Before=
# Conflicts=

[Service]
Type=oneshot
User=root
Group=root
StandardOutput=syslog
ExecStart=/usr/bin/ruby /etc/faster/cmdb/cmdb.rb

[Install]
WantedBy=multi-user.target


cat > /lib/systemd/system/cmdb.timer
[Unit]
Description=Timer for CMDB task configuration
Requires=var-run.mount nss-lookup.target network.target remote-fs.target rsyslog.service
After=var-run.mount nss-lookup.target network.target remote-fs.target rsyslog.service
# Wants=
# Before=
# Conflicts=

[Install]
WantedBy=multi-user.target

[Timer]
OnBootSec=5min
OnUnitActiveSec=2min
Unit=cmdb.service 


#
systemctl enable cmdb.timer
systemctl restart cmdb.timer
systemctl status cmdb.timer

#
cat > /lib/systemd/system/monitoring.service

[Unit]
Description=Erlang Monitoring Daemon
Wants=network.target

[Service]
User=root
WorkingDirectory=/etc/zabbix
ExecStartPre=/bin/bash /etc/faster/cmdb/modules/Monitoring/files/default/make.sh
ExecStart=/usr/bin/erl -run monitoring -noshell

[Install]
WantedBy=multi-user.target

#
systemctl enable monitoring.service
systemctl restart monitoring.service
systemctl status monitoring.service
