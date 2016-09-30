zypper ar -cf --name "home::conecenter::coneapp" http://download.opensuse.org/repositories/home:/conecenter:/coneapp/openSUSE_Leap_42.1/ "home::conecenter::coneapp"
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rework/openSUSE_Leap_42.1/home:conecenter:rework.repo
zypper ar -cf --name "devel::languages::perl::CPAN-X" http://download.opensuse.org/repositories/devel:/languages:/perl/openSUSE_Leap_42.1/  "devel::languages::perl"
zypper ar -cf --name "devel::languages::python"  http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_Leap_42.1/  "devel::languages::python"
zypper ar -cf --name "server::proxy" http://download.opensuse.org/repositories/server:/proxy/openSUSE_Leap_42.1/ "server::proxy"
zypper ar -cf --name "server::http" http://download.opensuse.org/repositories/server:/http/openSUSE_Leap_42.1/ "server::http"
zypper ar -cf http://download.opensuse.org/repositories/server:/database:/postgresql/openSUSE_Leap_42.1/server:database:postgresql.repo

zypper ar -cf --name "Apache" http://download.opensuse.org/repositories/Apache/openSUSE_Leap_42.1/  "Apache"
zypper ar -cf --name "Apache:Modules" http://download.opensuse.org/repositories/Apache:/Modules/openSUSE_Leap_42.1/ "Apache:Modules"
#zypper --gpg-auto-import-keys in "apache2" "apache2-utils" "apache2-mod_perl" "apache2-mod_auth_kerb"  "nginx" "tidy" "ImageMagick"  "bitstream-vera-fonts" "dejavu-fonts" "pure-ftpd"
zypper --gpg-auto-import-keys in "apache2-cone" "apache2-cone-utils" "apache2-cone-mod_perl"  "nginx" "tidy" "ImageMagick"  "bitstream-vera-fonts" "dejavu-fonts" "pure-ftpd" "haproxy"

zypper --gpg-auto-import-keys in "perl-ExtUtils-XSpp" "perl-Crypt-OpenSSL-RSA" "perl-Crypt-X509" "perl-Email-Folder" "perl-Email-FolderType" "perl-Email-MIME-Attachment-Stripper" "perl-Email-FolderType-Net" "perl-PDF-API2" "perl-Spreadsheet-WriteExcel" "perl-Spreadsheet-ParseExcel" "perl-Convert-ASN1" "perl-Unicode-Transform" "perl-XML-Twig" "perl-XML-RSS" "perl-Text-CSV_XS" "perl-List-MoreUtils" "perl-MIME-Lite" "perl-Archive-Zip" "perl-Xbase" "perl-DBD-XBase" "perl-PerlMagick" "perl-GD" "perl-GD-Barcode" "perl-Spreadsheet-XLSX" "perl-Printer" "perl-Net-OpenSSH" "perl-Net-Daemon" "perl-Sys-Syslog-OO" "perl-JSON-XS" "perl-SOAP-Lite" "perl-ldap" "perl-LWP-Protocol-https" "perl-Net-SFTP-Foreign" "perl-JavaScript-V8" "perl-Net-ASN" "perl-MQSeries" "perl-Net-AS2" "perl-Math-Round" "perl-Business-PayPal-IPN" "perl-HTML-Tree" "perl-MLDBM" "perl-I18N-AcceptLanguage" "perl-CGI" "perl-Term-ReadKey" "perl-Digest-SHA1" "perl-Tie-IxHash"

zypper --gpg-auto-import-keys in "postgresql"  "postgresql-server" "postgresql-contrib"

./media/sysdata/rev5/techpool/ontology/storage/pure-ftpd/_recipes/rev5_pure-ftpd.sh

