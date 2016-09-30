#
# spec file for package exim
#
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


%bcond_without  mysql
%bcond_without  pgsql
%bcond_without  sqlite
%bcond_without  ldap

## // REV5 \\
%global _obs_filename %(ls %{_sourcedir}/*.obs.tar.*)
%global _obs_path     %(echo %{_obs_filename}|sed -e "s/.*\\///" -e "s/obs.tar.*/obs/")
%global _compression_format %(echo %{_obs_filename}| sed -e "s/.*.obs.tar.//")

%global _my_release_name    %(echo %{_obs_filename}|sed -e "s/.*__Name@//" -e "s/__.*//")
%global _my_release_version %(echo %{_obs_filename}|sed -e "s/.*__Ver@//" -e "s/__.*//")
%global _my_release_num     %(echo %{_obs_filename}|sed -e "s/.*__Rel@//" -e "s/__.*//")
%global _my_release_date    %(echo %{_obs_filename}|sed -e "s/.*__RelDate@//" -e "s/__.*//")
%global _my_release_tag     %(echo %{_obs_filename}|sed -e "s/.*__Tag@//" -e "s/__.*//")

#MANDATORY FIELDS
Version:        %{_my_release_version}
Release:        0
Name:           %{_my_release_name}
Source0:        %{_obs_filename}

#
## \\ REV5 //

BuildRequires:  cyrus-sasl-devel
BuildRequires:  db-devel
BuildRequires:  libidn-devel
BuildRequires:  libspf2-devel
BuildRequires:  libtool
BuildRequires:  libtool
BuildRequires:  pam-devel
%if %{with_ldap}
BuildRequires:  openldap2-devel
%endif
BuildRequires:  pcre-devel
%if %{?suse_version:1}%{?!suse_version:0}
BuildRequires:  libopenssl-devel
BuildRequires:  tcpd-devel
BuildRequires:  xorg-x11-devel
%else
BuildRequires:  libXaw-devel
BuildRequires:  libXext-devel
BuildRequires:  libXt-devel
BuildRequires:  openssl-devel
BuildRequires:  tcp_wrappers
%endif
Url:            http://www.exim.org/
Conflicts:      sendmail sendmail-tls postfix
Provides:       smtp_daemon
%if %{?suse_version:%suse_version}%{?!suse_version:0} > 800
Requires:       logrotate
%if 0%{?suse_version} > 1220
BuildRequires:  pkgconfig(systemd)
%{?systemd_requires}
%else
Requires(pre):  %insserv_prereq
%endif
Requires(pre):  %fillup_prereq
Requires(pre):  /usr/sbin/useradd
Requires(pre):  fileutils textutils
%endif
%if %{with_mysql}
BuildRequires:  mysql-devel
%endif
%if %{with_pgsql}
BuildRequires:  postgresql-devel
%endif
%if %{with_sqlite}
BuildRequires:  sqlite3-devel
%endif
Summary:        The Exim Mail Transfer Agent, a Replacement for sendmail
License:        GPL-2.0+
Group:          Productivity/Networking/Email/Servers
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
# http://ftp.exim.org/pub/exim/Exim-Maintainers-Keyring.asc
Source2:        version.sh
Source1:        sysconfig.exim
Source12:       permissions.exim
Source13:       apparmor.usr.sbin.exim
Source20:       http://www.logic.univie.ac.at/~ametzler/debian/exim4manpages/exim4-manpages.tar.bz2
Source21:       exim-doc.tar.bz2
Source40:       exim.service
Patch1:         cee_acl_logwrite.patch
Patch2:         cee_log.patch
Patch3:         cee_macros.patch
Patch4:         cee_rewrite.patch
Patch5:         cee_deliver.patch
Patch6:         cee_expand.patch

%description
Exim is a mail transport agent (MTA) developed at the University of
Cambridge for use on Unix systems connected to the Internet. It is
freely available under the terms of the GNU General Public Licence. In
style, it is similar to Smail 3, but its facilities are more extensive.
In particular, it has options for verifying incoming sender and
recipient addresses, for refusing mail from specified hosts, networks,
or senders, and for controlling mail relaying.


%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%patch1 -p0
%patch2 -p0
%patch3 -p0
%patch4 -p0
%patch5 -p0
%patch6 -p0

cp -p %{S:2} ./src/src/
mkdir src/Local
# build with fPIE/pie on SUSE 10.0 or newer, or on any other platform
%if %{?suse_version:%suse_version}%{?!suse_version:99999} > 930
fPIE="-fPIE"
pie="-pie"
%endif
%if 0%{?suse_version} > 1100 || 0%{?centos_version} > 599 || 0%{?rhel_version} > 599
CFLAGS_OPT_WERROR="-Werror=format-security -Werror=missing-format-attribute"
%endif
cat <<-EOF > src/Local/Makefile
	# see src/EDITME for comments.
	BIN_DIRECTORY=/usr/sbin
	CONFIGURE_FILE=/etc/exim/exim.conf
	EXIM_USER=mail
	EXIM_GROUP=mail
	SPOOL_DIRECTORY=/var/spool/exim
	ROUTER_ACCEPT=yes
	ROUTER_DNSLOOKUP=yes
	ROUTER_IPLITERAL=yes
	ROUTER_MANUALROUTE=yes
	ROUTER_QUERYPROGRAM=yes
	ROUTER_REDIRECT=yes
	TRANSPORT_APPENDFILE=yes
	TRANSPORT_AUTOREPLY=yes
	TRANSPORT_PIPE=yes
	TRANSPORT_SMTP=yes
	TRANSPORT_LMTP=yes
	SUPPORT_MAILDIR=yes
	SUPPORT_MAILSTORE=yes
	SUPPORT_MBX=yes
	LOOKUP_DBM=yes
	LOOKUP_LSEARCH=yes
	LOOKUP_CDB=yes
	LOOKUP_DNSDB=yes
	LOOKUP_DSEARCH=yes
%if %{with_ldap}
	LOOKUP_LDAP=yes
%endif
%if %{with_mysql}
	LOOKUP_MYSQL=yes
%endif
%if %{with_pgsql}
	LOOKUP_PGSQL=yes
%endif
%if %{with_sqlite}
	LOOKUP_SQLITE=yes
%endif
	LOOKUP_NIS=yes
	LOOKUP_PASSWD=yes
	CYRUS_SASLAUTHD_SOCKET=/var/run/sasl2/mux
	LOOKUP_LIBS=-llber
%if %{with_ldap}
	LDAP_LIB_TYPE=OPENLDAP2
	LOOKUP_LIBS+=-lldap
%endif
%if %{with_mysql}
	LOOKUP_INCLUDE+=-I /usr/include/mysql
	LOOKUP_LIBS+=-L %{_libdir}/mysql -lmysqlclient
%endif
%if %{with_pgsql}
	LOOKUP_INCLUDE+=-I /usr/include/pgsql
	LOOKUP_LIBS+=-lpq
%endif
%if %{with_sqlite}
	LOOKUP_INCLUDE+=-I /usr/include/sqlite3
	LOOKUP_LIBS+=-lsqlite3
%endif
	WITH_CONTENT_SCAN=yes
	AUTH_CRAM_MD5=yes
        AUTH_CYRUS_SASL=yes
	AUTH_PLAINTEXT=yes
	AUTH_SPA=yes
	AUTH_DOVECOT=yes
        AUTH_TLS=yes
	AUTH_LIBS=-lsasl2
	SUPPORT_TLS=yes
	TLS_LIBS=-lssl -lcrypto
            #HAVE_ICONV=yes
	INFO_DIRECTORY=%{_infodir}
	LOG_FILE_PATH=syslog
	EXICYCLOG_MAX=10
	SYSLOG_LOG_PID=yes
        SYSLOG_LONG_LINES=yes
	COMPRESS_COMMAND=/bin/gzip
	COMPRESS_SUFFIX=gz
	ZCAT_COMMAND=/usr/bin/zcat
	SUPPORT_PAM=yes
	# RADIUS_CONFIG_FILE=/etc/radiusclient/radiusclient.conf
	NO_SYMLINK=yes
	CHOWN_COMMAND=/bin/chown
	CHGRP_COMMAND=/bin/chgrp
	MV_COMMAND=/bin/mv
	RM_COMMAND=/bin/rm
	PERL_COMMAND=/usr/bin/perl
	# APPENDFILE_MODE=0600
	# APPENDFILE_DIRECTORY_MODE=0700
	# APPENDFILE_LOCKFILE_MODE=0600
	# CONFIGURE_FILE_USE_NODE=yes
	# CONFIGURE_FILE_USE_EUID=yes
	# DELIVER_BUFFER_SIZE=8192
	# EXIMDB_DIRECTORY_MODE=0750
	# EXIMDB_MODE=0640
	# EXIMDB_LOCKFILE_MODE=0640
	# HEADER_MAXSIZE="(1024*1024)"
	# INPUT_DIRECTORY_MODE=0750
	# LOG_DIRECTORY_MODE=0750
	# LOG_MODE=0640
	# LOOKUP_TESTDB=yes
	MAKE_SHELL=/bin/bash
	MAX_NAMED_LIST=64
	# MAXINTERFACES=250
	# MSGLOG_DIRECTORY_MODE=0750
	PID_FILE_PATH=/var/run/exim.pid
	# SPOOL_DIRECTORY_MODE=0750
	# SPOOL_MODE=0640
	SUPPORT_MOVE_FROZEN_MESSAGES=yes
	HAVE_IPV6=YES
	EXPERIMENTAL_SPF=yes
	LOOKUP_LIBS+=-lspf2
	SUPPORT_PROXY=yes
        SUPPORT_SOCKS=yes
            #EXPERIMENTAL_DMARC=yes
	#CFLAGS += -I/usr/local/include
	#LDFLAGS += -lopendmarc
	EXPERIMENTAL_EVENT=yes
	EXPERIMENTAL_CERTNAMES=yes
	EXPERIMENTAL_DSN=yes
	EXPERIMENTAL_DSN_INFO=yes
	EXPERIMENTAL_DANE=yes
	EXPERIMENTAL_INTERNATIONAL=yes
	LDFLAGS += -lidn    
	CFLAGS=$RPM_OPT_FLAGS -Wall $CFLAGS_OPT_WERROR -fno-strict-aliasing -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DLDAP_DEPRECATED $fPIE
	EXTRALIBS=-ldl -lpam -L/usr/X11R6/%{_lib} $pie

#CFLAGS=%{optflags} %{?gcc_lto} -fpie -fPIC
#LDFLAGS+=-Wl,--as-needed -Wl,--strip-all -Wl,--export-dynamic %{?gcc_lto} -pie -fPIC
EOF
rm -f doc/*.{orig,txt~}

%build
cd src
%{__make}

%install
%if 0%{?suse_version} > 1220
mkdir -p $RPM_BUILD_ROOT/%{_unitdir}
%endif
mkdir -p $RPM_BUILD_ROOT/usr/{bin,sbin,lib}
mkdir -p $RPM_BUILD_ROOT/var/log/exim
mkdir -p $RPM_BUILD_ROOT/var/spool/mail/
mkdir -p $RPM_BUILD_ROOT/var/adm/fillup-templates
mkdir -p $RPM_BUILD_ROOT%{_mandir}/man8
mkdir -p $RPM_BUILD_ROOT/usr/bin
cd src && pwd
make 	inst_dest=$RPM_BUILD_ROOT/usr/sbin \
	inst_conf=$RPM_BUILD_ROOT/etc/exim/exim.conf \
	inst_info=$RPM_BUILD_ROOT/%{_infodir} \
	INSTALL_ARG=-no_chown 	install
mv $RPM_BUILD_ROOT/usr/sbin/exim-%{version}* $RPM_BUILD_ROOT/usr/sbin/exim
mv $RPM_BUILD_ROOT/etc/exim/exim.conf src/configure.default # with all substitutions done
install -m 0644 %{S:40} $RPM_BUILD_ROOT/%{_unitdir}/exim.service
# aka...
for i in \
	/usr/lib/sendmail \
	/usr/bin/runq \
	/usr/bin/rsmtp \
	/usr/bin/mailq \
	/usr/bin/newaliases
do
	ln -sf ../sbin/exim $RPM_BUILD_ROOT$i
done
ln -sf exim $RPM_BUILD_ROOT/usr/sbin/sendmail
%if 0%{?suse_version} > 1220
ln -sv service $RPM_BUILD_ROOT/usr/sbin/rcexim
%else
ln -sv ../../etc/init.d/exim $RPM_BUILD_ROOT/usr/sbin/rcexim
%endif
cp -p %{S:1} $RPM_BUILD_ROOT/var/adm/fillup-templates/sysconfig.exim
# man pages
tar xvjf %{S:21}
mv doc/exim.8 $RPM_BUILD_ROOT/%{_mandir}/man8/
tar xvjf %{S:20}
cp -p exim4-manpages/* $RPM_BUILD_ROOT/%{_mandir}/man8/
for i in \
	sendmail \
	runq \
	rsmtp \
	mailq \
	newaliases
do
	ln -sf exim.8.gz $RPM_BUILD_ROOT/%{_mandir}/man8/$i.8.gz
done
for i in \
	exim_dumpdb \
	exim_fixdb \
	exim_tidydb
do
	ln -sf exim_db.8.gz $RPM_BUILD_ROOT/%{_mandir}/man8/$i.8.gz
done
perl -pi -e 's%/usr/share/doc/exim4%/usr/share/doc/packages/exim%g' `find $RPM_BUILD_ROOT/%{_mandir}/man8 -name "*.8"`
gzip -9 doc/*.txt
#
# package the utilities without executable permissions, to silence rpmlint warnings
chmod 644 util/*.{pl,sh} src/convert4r*
#
# apparmor profile
install -D -m 0644 $RPM_SOURCE_DIR/apparmor.usr.sbin.exim $RPM_BUILD_ROOT/usr/share/apparmor/extra-profiles/usr.sbin.exim

%pre
%if 0%{?suse_version} > 1220
%service_add_pre exim.service
%endif

%post
%if 0%{?suse_version} < 1131
%run_permissions
%else
%set_permissions /usr/sbin/exim
%endif

%verifyscript
%verify_permissions -e /usr/sbin/exim

%files
%defattr(-,root,root)
#%doc ACKNOWLEDGMENTS CHANGES LICENCE NOTICE README.UPDATING README
%doc doc
#%doc util
%doc %{_mandir}/man8/*
/usr/sbin/exicyclog
/usr/sbin/exigrep
/usr/sbin/exiqgrep
%verify(not mode) %attr(4755,root,root) /usr/sbin/exim
/usr/sbin/exim_*
/usr/sbin/exinext
/usr/sbin/exipick
/usr/sbin/exiqsumm
/usr/sbin/exiwhat
/usr/sbin/eximstats
%dir /etc/exim
%if 0%{?suse_version} > 1220
%{_unitdir}/exim.service
%endif
%if %{?suse_version:%suse_version}%{?!suse_version:99999} < 1000
%config(noreplace) /etc/permissions.d/exim
%endif
%dir /usr/share/apparmor
%dir /usr/share/apparmor/extra-profiles
%config(noreplace) /usr/share/apparmor/extra-profiles/usr.sbin.exim
/usr/sbin/rcexim
/usr/bin/mailq
/usr/bin/runq
/usr/bin/rsmtp
/usr/bin/newaliases
/usr/sbin/sendmail
/usr/lib/sendmail
/var/adm/fillup-templates/sysconfig.exim
%dir %attr(750,mail,mail) /var/log/exim

%changelog
