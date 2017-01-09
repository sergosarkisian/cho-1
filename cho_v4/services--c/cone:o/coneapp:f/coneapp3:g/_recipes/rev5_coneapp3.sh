#!/bin/bash 

zypper ar -cf http://download.opensuse.org/repositories/server:/proxy/openSUSE_Leap_42.2/server:proxy.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/http/openSUSE_Leap_42.2/server:http.repo


zypper --gpg-auto-import-keys in "exim" "haproxy" "nginx-syslog" "git-daemon"
zypper --gpg-auto-import-keys in "java-1_8_0-openjdk-headless" "log4j" "gcc-java" "java-1_8_0-openjdk-devel" "javacc" "javacc3" "libfonts"
zypper --gpg-auto-import-keys in "perl-JSON-XS" "perl-List-MoreUtils"
zypper --gpg-auto-import-keys --non-interactive in http://dl.bintray.com/sbt/rpm/sbt-0.13.13.rpm

#Android SDK 32-bit
zypper --gpg-auto-import-keys in ant libstdc++6-32bit zlib-devel-32bit libncurses6-32bit libSDL2-2_0-0-32bit libX11-6-32bit libXrandr2-32bit libstdc++6-locale libz1-32bit

## DIRS ##
ln -s /media/storage/web /
mkdir  -p /media/storage/web

mkdir -p /web/_c3

groupadd -g 2000 http
useradd -g http -u 2000 -M -d /web/http http

echo 'http:$6$qJEkrJcMsaNw$gKdxOs6v0WbsElUDSBhbc0TjSSS1FVwxD4asZvH0tHjFwKi3kyRP1y51j1DyqzKkPMmy4PXM7GlCSqKOk35/N1' |chpasswd -e
usermod -G sysdata http

chown -R http:http /media/storage/web
setfacl -R -m d:u:http:rwx /media/storage/web
setfacl -R -m d:g:http:rwx /media/storage/web

setfacl -R -m u:http:rwx /media/storage/web
setfacl -R -m g:http:rwx /media/storage/web

setfacl -R -m d:u::rwx /media/storage/web
setfacl -R -m u::rwx /media/storage/web

loginctl enable-linger http
mkdir -p /media/storage/web/http/.config/systemd/user/
usermod -G sysdata http

cp /usr/lib/systemd/system/getty@.service  /etc/systemd/system/autologin@.service
 ln -s /etc/systemd/system/autologin@.service   /etc/systemd/system/getty.target.wants/getty@tty8.service
ln -s /media/sysdata/in4/cho/cho_v4/services--c/cone:o/coneapp:f/coneapp3:g/in4__c3.bash /etc/profile.d/in4__c3.bash
chmod 755 /etc/profile.d/in4__c3.bash

##MANUAL
 #ExecStart=-/sbin/mingetty --autologin USERNAME %I
#Restart=no
#...
#Alias=getty.target.wants/getty@tty8.service
 ##

rm -f  /media/storage/web/http/.config/systemd/user/in4__cone_c3_i@.service; cp /media/sysdata/in4/cho/cho_v4/services--c/cone:o/coneapp:f/coneapp3:g/_systemd/in4__cone_c3_i@.service /media/storage/web/http/.config/systemd/user/
#rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_coneapp3 && ln -s /media/sysdata/rev5/techpool/ontology/cone/coneapp3/_firewall/rev5_coneapp3 /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload


##
