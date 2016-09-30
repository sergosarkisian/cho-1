###REPO    
zypper ar -cf --name "systemsmanagement" http://download.opensuse.org/repositories/systemsmanagement/openSUSE_13.1/ "systemsmanagement"
zypper ar -cf --name "home::conecenter::coneapp" http://download.opensuse.org/repositories/home:/conecenter:/coneapp/openSUSE_13.1/ "home::conecenter::coneapp"
zypper ar -cf --name "devel::languages::perl"  http://download.opensuse.org/repositories/devel:/languages:/perl/openSUSE_13.1/  "devel::languages::perl"
zypper ar -cf --name "devel::languages::perl::CPAN-B" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-B/openSUSE_13.1/  "devel::languages::perl::CPAN-B"
zypper ar -cf --name "devel::languages::perl::CPAN-C" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-C/openSUSE_13.1/  "devel::languages::perl::CPAN-C"
zypper ar -cf --name "devel::languages::perl::CPAN-E" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-E/openSUSE_13.1/  "devel::languages::perl::CPAN-E"
zypper ar -cf --name "devel::languages::perl::CPAN-I" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-I/openSUSE_13.1/  "devel::languages::perl::CPAN-I"
zypper ar -cf --name "devel::languages::perl::CPAN-J" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-J/openSUSE_13.1/  "devel::languages::perl::CPAN-J"
zypper ar -cf --name "devel::languages::perl::CPAN-N" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-N/openSUSE_13.1/  "devel::languages::perl::CPAN-N"
zypper ar -cf --name "devel::languages::perl::CPAN-P" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-P/openSUSE_13.1/  "devel::languages::perl::CPAN-P"
zypper ar -cf --name "devel::languages::perl::CPAN-S" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-S/openSUSE_13.1/  "devel::languages::perl::CPAN-S"
zypper ar -cf --name "devel::languages::perl::CPAN-U" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-U/openSUSE_13.1/  "devel::languages::perl::CPAN-U"
zypper ar -cf --name "devel::languages::perl::CPAN-X" http://download.opensuse.org/repositories/devel:/languages:/perl:/CPAN-X/openSUSE_13.1/  "devel::languages::perl::CPAN-X"
zypper ar -cf --name "devel::languages::python"  http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_13.1/  "devel::languages::python"
zypper ar -cf --name "server::mail" http://download.opensuse.org/repositories/server:/mail/openSUSE_13.1/ "server::mail"
zypper ar -cf --name "server::proxy" http://download.opensuse.org/repositories/server:/proxy/openSUSE_13.1/ "server::proxy"
zypper ar -cf --name "server::http" http://download.opensuse.org/repositories/server:/http/openSUSE_13.1/ "server::http"

## locks
repo: openSUSE_Tumbleweed
type: package
match_type: glob
case_sensitive: on
solvable_name: kernel*

repo: OSS
type: package
match_type: glob
case_sensitive: on
solvable_name: *v8*

repo: Updates
type: package
match_type: glob
case_sensitive: on
solvable_name: *v8*

##PACKAGES

"ServicesNet": [
    "exim"
],
"ServicesWeb": [
    "python-web",
    "haproxy"
],
"Cone": [
    "All"
],  
zypper --gpg-auto-import-keys in -C --no-recommends "exim"  "python-Twisted" "python-pyflakes" "python-pep8" "python-setuptools" "python-pip" "haproxy-1.5" "apache2-cone" "apache2-cone-utils" "apache2-cone-mod_perl" "apache2-cone-mod_auth_kerb" "libv8-3" "v8-devel"  "nginx-syslog-cone" "tidy" "poppler-tools" "tidy" "ImageMagick" "inkscape" "bitstream-vera-fonts" "dejavu-fonts"

"Java": [
    "common",
    "digisign"
],
zypper --gpg-auto-import-keys in -C --no-recommends "java-1_8_0-openjdk" "log4j" "bouncycastle" "apache-commons-codec"        
        
"Perl": [
    "All"
],

zypper --gpg-auto-import-keys in -C --no-recommends "perl-ExtUtils-XSpp" "perl-Crypt-OpenSSL-RSA" "perl-Crypt-X509" "perl-Email-Folder" "perl-Email-FolderType" "perl-Email-MIME-Attachment-Stripper" "perl-Email-FolderType-Net" "perl-PDF-API2" "perl-Spreadsheet-WriteExcel" "perl-Spreadsheet-ParseExcel" "perl-Convert-ASN1" "perl-Unicode-Transform" "perl-XML-Twig" "perl-XML-RSS" "perl-Text-CSV_XS" "perl-List-MoreUtils" "perl-MIME-Lite" "perl-Archive-Zip" "perl-Xbase" "perl-DBD-XBase" "perl-PerlMagick" "perl-GD" "perl-GD-Barcode" "perl-Spreadsheet-XLSX" "perl-Printer" "perl-Net-OpenSSH" "perl-Net-Daemon" "perl-Sys-Syslog-OO" "perl-JSON-XS" "perl-SOAP-Lite" "perl-ldap" "perl-LWP-Protocol-https" "perl-Net-SFTP-Foreign" "perl-JavaScript-V8" "perl-Net-ASN" "perl-MQSeries" "perl-Net-AS2" "perl-Math-Round" "perl-Business-PayPal-IPN" "perl-HTML-Tree" "perl-MLDBM" "perl-I18N-AcceptLanguage"

"Python": [
    "All"
]
        
zypper --gpg-auto-import-keys in -C --no-recommends "python" "python-base" "dbus-1-python" "audit-libs-python" "python-numpy" "python-httplib2" "python-pycurl" "python-jsonschema" "python-simplejson" "python-anyjson" "python-pycrypto" "python-pyasn1-modules" "python-cairo"


"Devel": [
    "gcc_env",
    "java"
],          
zypper --gpg-auto-import-keys in -C --no-recommends "bison" "flex" "gcc" "make" "gcc-c++" "pcre-devel" "zlib-devel" "patch" "m4" "glibc" "binutils" "glibc-devel" "libaio1" "libaio-devel" "libelf0" "libelf1" "libelf-devel" "numactl" "libtool" "libstdc++6" "libstdc++-devel" "libgcc_s1" "expat" "libopenssl-devel" "binutils-devel" "gcc-java" "java-1_8_0-openjdk" "java-1_8_0-openjdk-devel" "javacc" "javacc3" "gcc-java"        


##SYS

mkdir -p /media/storage
ln -s /media/storage/web /
echo "*/5 * * * * rm -R /web/_data/removing/*" > /tmp/http_cron
crontab -u http /tmp/http_cron
systemctl restart cron.service
echo "http      ALL=(ALL) NOPASSWD: /usr/sbin/sendmail" > /etc/sudoers.d/http
sed -i "s/net.ipv4.ip_local_port_range.*/net.ipv4.ip_local_port_range = 14000 65000/" /etc/sysctl.d/network.conf

/faster/techpool/apache2/mime.types_cone


##ON MASTER
mkdir -p /media/storage/web
mkdir -p /web/_deploy /web/_data /web/_dsch

#--- systemd services
systemctl --system daemon-reload

wget -q -nc http://public.edss.ee/software/Linux/Oracle/instantclient10_1.zip -P /tmp
unzip -oqq /tmp/instantclient10_1.zip -d /web/_data/

##FR - use custom nginx compilation
chown -R http:http /var/lib/nginx /var/log/nginx/
chown -R http:http /media/storage/web
setfacl -R -m d:u:http:rwx /media/storage/web
setfacl -R -m d:g:http:rwx /media/storage/web

setfacl -R -m u:http:rwx /media/storage/web
setfacl -R -m g:http:rwx /media/storage/web

setfacl -R -m d:u::rwx /media/storage/web
setfacl -R -m u::rwx /media/storage/web


##MQ
MQSeriesClient-7.5.0-2.x86_64.rpm MQSeriesRuntime-7.5.0-2.x86_64.rpm MQSeriesSDK-7.5.0-2.x86_64.rpm MQSeriesSamples-7.5.0-2.x86_64.rpm
