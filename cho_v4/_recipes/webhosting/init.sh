## REPO & SW ##
#REPO - PHP
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_42.1/devel:languages:php.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/php:/extensions/openSUSE_Leap_42.1/server:php:extensions.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/php:/applications/openSUSE_Leap_42.1/server:php:applications.repo

#REPO - DB
zypper ar -cf http://download.opensuse.org/repositories/server:/database/openSUSE_Leap_42.1/server:database.repo

#REPO - OTHERS
zypper ar -cf http://download.opensuse.org/repositories/server:/database/openSUSE_Leap_42.1/server:database.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/search/openSUSE_Tumbleweed/server:search.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/proxy/openSUSE_Leap_42.1/server:proxy.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/http/openSUSE_Leap_42.1/server:http.repo

#SW - PHP
#zypper --gpg-auto-import-keys in "php5" "bitstream-vera-fonts" "php5-bcmath" "php5-bz2" "php5-curl" "php5-ctype" "php5-dom" "php5-gd" "php5-gettext" "php5-iconv" "php5-fpdf" "php5-fpm" "php5-imagick" "php5-inotify" "php5-json" "php5-mbstring" "php5-mcrypt" "php5-mysql" "php5-ldap" "php5-openssl" "php5-pdo" "php5-pecl-memcache" "php5-pgsql" "php5-soap" "php5-sockets" "php5-sqlite" "php5-snmp" "php5-sysvmsg" "php5-sysvsem" "php5-sysvshm" "php5-suhosin" "php5-tidy" "php5-tokenizer" "php5-zip" "php5-zlib" "php5-ZendFramework" "php5-xcache" "php5-xmlreader" "php5-xmlwriter" "ImageMagick"

#SW - DB
#zypper --gpg-auto-import-keys in  "mariadb" "mariadb-client" "mariadb-tools"  "xtrabackup" "percona-toolkit"

#SW - servers
#zypper --gpg-auto-import-keys in "haproxy" "nginx-syslog" "pure-ftpd" "exim"
# add apache 2.4
##

## FSTAB, MOUNT ##
echo "LABEL=storage        /media/storage      ext4      noatime,acl,user_xattr 1 1" >> /etc/fstab
mount -a
##

## DIRECTORIES ##
mkdir -p /media/storage/sites
chmod -R 755 /media/storage/       
mkdir -p /media/storage/sites_env/default_sessions
##


## MARIADB ##
 /media/sysdata/rev5/techpool/ontology/database/mariadb/_recipes/rev5_mariadb.sh
##


## PURE-FTPD ##
 /media/sysdata/rev5/techpool/ontology/storage/pure-ftpd/_recipes/rev5_pure-ftpd.sh
##



#PHP
mkdir /etc/php5/fpm/pool.d/
cp /etc/faster/cmdb/techpool/php5/files/php-fpm.conf  /etc/php5/fpm/php-fpm.conf
cp /etc/faster/cmdb/techpool/php5/files/php.ini /etc/php5/fpm/php.ini
cp /etc/faster/cmdb/techpool/php5/files/php.ini /etc/php5/cli/php.ini
cp /etc/faster/cmdb/techpool/php5/files/suhosin.ini /etc/php5/conf.d/suhosin.ini

systemctl enable php-fpm
systemctl restart php-fpm
##FIREWALL - 80


## NGINX
cp /etc/faster/cmdb/techpool/nginx/files/fastcgi.conf /etc/nginx/fastcgi.conf
cat /etc/faster/cmdb/techpool/nginx/files/fastcgi_php.conf >> /etc/nginx/fastcgi.conf
##

## HAPROXY ##
 /media/sysdata/rev5/techpool/ontology/proxies/haproxy/_recipes/rev5_haproxy-web.sh
##

setfacl  -x o:: /media/storage/
setfacl  -x d:o:: /media/storage/
