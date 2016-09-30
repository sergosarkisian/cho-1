zypper in mc 
wget -q -nc https://www.cape-it.de/files/downloads/KIX4OTRS/otrs-5.0.6.tar.gz  -P /storage/sites/o/otrs/source
wget -q -nc https://www.cape-it.de/files/downloads/KIX4OTRS/ITSM-5.0.6.opm  -P /storage/sites/o/otrs/source
wget -q -nc https://www.cape-it.de/files/downloads/KIX4OTRS/KIXCore-5.0.0.opm  -P /storage/sites/o/otrs/source
wget -q -nc https://www.cape-it.de/files/downloads/KIX4OTRS/KIX4OTRS-8.0.0.opm  -P /storage/sites/o/otrs/source


zypper ar -cf http://download.opensuse.org/repositories/Apache:/Modules/openSUSE_Leap_42.1/Apache:Modules.repo
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/perl/openSUSE_Leap_42.1/devel:languages:perl.repo
zypper ar -cf http://download.opensuse.org/repositories/server:/database:/postgresql/openSUSE_Leap_42.1/server:database:postgresql.repo

zypper in apache2-mod_perl
zypper in postgresql postgresql-server libpq5
zypper in perl-Archive-Zip perl-Crypt-Eksblowfish perl-Crypt-SSLeay perl-TimeDate perl-DBI perl-DBD-Pg perl-Encode-HanExtra perl-IO-Socket-SSL perl-JSON-XS perl-Mail-IMAPClient perl-IO-Socket-SSL perl-Net-DNS perl-ldap perl-Template-Toolkit perl-Text-CSV_XS perl-XML-LibXSLT perl-XML-LibXML perl-XML-Parser perl-YAML-LibYAML perl-Apache-DBI perl-IO-Interactive perl-Crypt-PasswdMD5 perl-Email-Valid perl-FCGI


mkdir -p  /media/storage/sites/o/otrs/source
mkdir -p /media/storage/database/postgres

##pg perms & path

########
./bin/otrs.Console.pl Admin::User::SetPassword localadmin pi=3.141592
##ldap auth

####
Email Settings - > Mail Account Management


