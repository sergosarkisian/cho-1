#zypper
cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/zypp.conf loop/etc/zypp/zypp.conf
cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/zypper.conf loop/etc/zypp/zypper.conf
#++ profile.d
#


#
systemd = profile.d + conf
sssd =  conf + systemd service
sysctl = conf
atop =  profile.d + conf + systemd service
rsyslog = conf + systemd service
exim = conf
sshd = conf + systemd service + swf2
sudo =  conf
bash = conf
 ###
