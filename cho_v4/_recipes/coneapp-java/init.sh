
zypper --non-interactive in java-1_8_0-openjdk java-1_8_0-openjdk-devel javacc javacc3 gcc-java
zypper --non-interactive in http://dl.bintray.com/sbt/rpm/sbt-0.13.9.rpm


echo "http      ALL=(ALL) NOPASSWD: /usr/sbin/sendmail" > /etc/sudoers.d/http
sed -i "s/net.ipv4.ip_local_port_range.*/net.ipv4.ip_local_port_range = 20000 59999/" /etc/sysctl.d/network.conf

mkdir -p /media/storage/web
rm -rf /web && ln -s /media/storage/web /
mkdir -p /web/c3 /web/c3/dev /web/c3/test /web/c3/prod

groupadd -g 9000 http   
useradd -u 9000 -md /media/storage/web/http -G users -g http http

loginctl enable-linger http
#c3test status
#c3 status

mkdir -p /media/storage/web/http/.config/systemd/user/
cp  /media/storage/web/http/.config/systemd/user/c3_test@.service
