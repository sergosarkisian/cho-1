## sssd
cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/sssd_basic.conf /etc/sssd/sssd.conf	
sed -i "s/%ORG%/$Org/" /etc/sssd/sssd.conf	
sed -i "s/%NET%/$Net/" /etc/sssd/sssd.conf	
rm -f /etc/systemd/system/rev5_sssd.service  				&& ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/_systemd/rev5_sssd.service 		/etc/systemd/system/  
systemctl disable sssd && systemctl stop sssd && systemctl enable rev5_sssd && systemctl restart rev5_sssd
##

snapper test


#emerg access
-GPG_TTY=/dev/tty1
+GPG_TTY=/dev/pts/1
-TERM=linux
+TERM=xterm
+TERM=vt220

-XDG_VTNR=1
-XDG_SESSION_ID=3

