#fstab
mkdir -p /media/storage

mount -a

mkdir -p /media/storage/web
mkdir -p /web/_deploy /web/_data /web/_dsch

mv /web/http /media/storage/web/
rm -rf /web/
ln -s /media/storage/web /

groupadd -g 9000 http   
useradd -u 9000 -md /web/http -G users -g http http


chown -R http:http /media/storage/web
setfacl -R -m d:u:http:rwx /media/storage/web
setfacl -R -m d:g:http:rwx /media/storage/web

setfacl -R -m u:http:rwx /media/storage/web
setfacl -R -m g:http:rwx /media/storage/web

setfacl -R -m d:u::rwx /media/storage/web
setfacl -R -m u::rwx /media/storage/web


echo "http      ALL=(ALL) NOPASSWD: /usr/sbin/sendmail" > /etc/sudoers.d/http


rm -f /etc/apache2/mime.types && ln -s /media/sysdata/rev5/techpool/ontology/web/apache/mime.types_cone /etc/apache2/mime.types



##move to systemd
echo "*/5 * * * * rm -R /web/_data/removing/*" > /tmp/http_cron
crontab -u http /tmp/http_cron
systemctl restart cron.service
##

