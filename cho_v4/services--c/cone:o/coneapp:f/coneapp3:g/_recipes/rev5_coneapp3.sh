#!/bin/bash 

zypper ar -cf http://download.opensuse.org/repositories/server:/proxy/openSUSE_13.2/server:proxy.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/http/openSUSE_13.2/server:http.repo


zypper --gpg-auto-import-keys in "exim" "haproxy" "nginx-syslog" "git-daemon"
zypper --gpg-auto-import-keys in "java-1_8_0-openjdk-headless" "log4j" "gcc-java" "java-1_8_0-openjdk-devel" "javacc" "javacc3"
zypper --gpg-auto-import-keys in "perl-JSON-XS" "perl-List-MoreUtils"
zypper --gpg-auto-import-keys in http://dl.bintray.com/sbt/rpm/sbt-0.13.9.rpm

#Android SDK 32-bit
zypper --gpg-auto-import-keys in ant libstdc++6-32bit zlib-devel-32bit libncurses6-32bit libSDL2-2_0-0-32bit libX11-6-32bit libXrandr2-32bit libstdc++6-locale libz1-32bit

## DIRS ##
ln -s /media/storage/web /
mkdir  -p /media/storage/web

mkdir -p /web/_coneapp3

groupadd -g 2000 http
useradd -g http -u 2000 -M -d /web/http http

echo 'http:$6$qJEkrJcMsaNw$gKdxOs6v0WbsElUDSBhbc0TjSSS1FVwxD4asZvH0tHjFwKi3kyRP1y51j1DyqzKkPMmy4PXM7GlCSqKOk35/N1' |chpasswd -e
usermod -G sysapp http

chown -R http:http /media/storage/web
setfacl -R -m d:u:http:rwx /media/storage/web
setfacl -R -m d:g:http:rwx /media/storage/web

setfacl -R -m u:http:rwx /media/storage/web
setfacl -R -m g:http:rwx /media/storage/web

setfacl -R -m d:u::rwx /media/storage/web
setfacl -R -m u::rwx /media/storage/web



rm -f /etc/systemd/system/rev5_coneapp3_i@.service && cp /media/sysdata/rev5/techpool/ontology/cone/coneapp3/_systemd/rev5_coneapp3_i@.service /etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_coneapp3 && ln -s /media/sysdata/rev5/techpool/ontology/cone/coneapp3/_firewall/rev5_coneapp3 /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload


##
