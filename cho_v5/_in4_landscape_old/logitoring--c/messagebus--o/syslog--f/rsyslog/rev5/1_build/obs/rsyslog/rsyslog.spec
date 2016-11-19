#
# spec file for package rsyslog
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
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
Version: %{_my_release_version}
Name:    %{_my_release_name}
Release: 1
Source0: %{_obs_filename}

#
## \\ REV5 //


Summary:        The enhanced syslogd for Linux and Unix
License:        (GPL-3.0+ and Apache-2.0)
Group:          System/Daemons
%if 0%{?suse_version} >= 1210
%bcond_without  systemd
%bcond_without  udpspoof
%bcond_without  dbi
%else
%bcond_with     systemd
%bcond_with     udpspoof
%bcond_with     dbi
%endif
%if 0%{?suse_version} >= 1230
%bcond_with     systemv
%else
%bcond_without  systemv
%endif
%if 0%{?suse_version} > 1230
%bcond_without  journal
%else
%bcond_with     journal
%endif
%bcond_with  gssapi
%bcond_without  mmcount
%bcond_without  mmsequence
%bcond_without  mmfields
%bcond_without  gnutls
%bcond_without  gcrypt
%bcond_without  guardtime
%bcond_without  mysql
%bcond_without  pgsql
%bcond_without  relp
%bcond_without  rfc3195
%bcond_without  snmp
%bcond_without  diagtools
%bcond_without  mmnormalize
%bcond_without  elasticsearch
%bcond_without  mmexternal
# TODO: ... doesnt have a proper configure check but wants hdfs.h
%bcond_with     hdfs
%bcond_with     mongodb
%bcond_with     hiredis
%bcond_with     zeromq
%define         upstream_version            %{version}
%define         rsyslogdocdir               %{_docdir}/%{name}
%define         rsyslog_rundir              /run/rsyslog
%define         rsyslog_sockets_cfg         %{rsyslog_rundir}/additional-log-sockets.conf
%define         rsyslog_module_dir_nodeps   %{_libdir}/rsyslog/
%define         rsyslog_module_dir_withdeps %{_libdir}/rsyslog/
Url:            http://www.rsyslog.com/
%if %{with systemd}
Provides:       syslog
Provides:       sysvinit(syslog)
Conflicts:      otherproviders(syslog)
Requires(pre):  %fillup_prereq
%if %{with systemv}
Requires(pre):  %insserv_prereq
Requires(pre):  syslog-service < 2.0
Requires(pre):  /etc/init.d/syslog
%else
Requires(pre):  syslog-service >= 2.0
%endif
%{?systemd_requires}
BuildRequires:  pkgconfig(systemd)
%if %{with journal}
BuildRequires:  pkgconfig(libsystemd-journal) >= 197
%endif
%else
Requires(pre):  %insserv_prereq %fillup_prereq /etc/init.d/syslog
BuildRequires:  klogd
%endif

BuildRequires:  autoconf >= 2.61
BuildRequires:  automake
BuildRequires:  libtool
#
BuildRequires:  bison
BuildRequires:  flex
BuildRequires:  openssl-devel >= 0.9.7
BuildRequires:  pcre-devel
BuildRequires:  pkgconfig
BuildRequires:  zlib-devel
%if %{with rfc3195}
BuildRequires:  pkgconfig(liblogging-rfc3195) >= 1.0.1
%endif
BuildRequires:  pkgconfig(liblogging-stdlog) >= 1.0.1

%if %{with elasticsearch}
BuildRequires:  curl-devel
%endif
%if %{with hiredis}
BuildRequires:  hiredis-devel >= 0.10.1
%endif
%if %{with mongodb}
# TODO: PKG_CHECK_MODULES(LIBMONGO_CLIENT, libmongo-client >= 0.1.4)
%endif
%if %{with zeromq}
BuildRequires:  czmq-devel >= 1.1.0
%endif
%if %{with gssapi}
BuildRequires:  krb5-devel
%endif
%if %{with gnutls}
BuildRequires:  libgnutls-devel
%endif
%if %{with gcrypt}
BuildRequires:  libgcrypt-devel
%endif
%if %{with guardtime}
BuildRequires:  libgt-devel >= 0.3.1
%endif
%if %{with dbi}
BuildRequires:  libdbi-devel
%endif
%if %{with mysql}
BuildRequires:  mysql-devel
%endif
%if %{with snmp}
BuildRequires:  net-snmp-devel
%endif
%if %{with pgsql}
BuildRequires:  postgresql-devel
%endif
%if %{with relp}
# RELP support
BuildRequires:  pkgconfig(relp) >= 1.2.5
%endif
%if %{with udpspoof}
# UDP spoof support
BuildRequires:  libnet-devel
%endif
%if %{with mmnormalize}
# mmnormalize support
BuildRequires:  pkgconfig(libee) >= 0.4.0
BuildRequires:  pkgconfig(lognorm) >= 2.0.0
%endif
#
BuildRequires:  pkgconfig(libee) >= 0.4.0
BuildRequires:  pkgconfig(libestr) >= 0.1.9
BuildRequires:  pkgconfig(uuid) >= 2.21.0
BuildRequires:  pkgconfig(libfastjson)

%if 0%{?suse_version} >= 1200
BuildRequires:  python-docutils
%bcond_without  rst2man
%else
%bcond_with     rst2man
%endif
%if %{with systemd}
%{?systemd_requires}
BuildRequires:  pkgconfig(systemd)
%endif
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source1:        rsyslog.sysconfig
Source2:        rsyslog.conf.in
Source4:        rsyslog.d.remote.conf.in
Source5:        rsyslog-service-prepare.in
# PATCH-FIX-OPENSUSE rsyslog-unit.patch crrodriguez@opensuse.org Customize upstream systemd unit for openSUSE needs.
Patch0:         rsyslog-unit.patch

%description
Rsyslog is an enhanced multi-threaded syslogd supporting, among others,
MySQL, syslog/tcp, RFC 3195, permitted sender lists, filtering on any
message part, and fine grain output format control. It is quite
compatible to stock sysklogd and can be used as a drop-in replacement.
Its advanced features make it suitable for enterprise-class, encryption
protected syslog relay chains while at the same time being very easy to
setup for the novice user.

%if %{with diagtools}

%package diag-tools
Requires:       %{name} = %{version}
Summary:        Diagnostic tools
Group:          System/Daemons

%description diag-tools
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This package provides additional diagnostic tools (small helpers,
usually not needed).

%endif

%if %{with mmcount}

%package module-mmcount
Requires:       %{name} = %{version}
Summary:        Message modification plugin which counts messages
Group:          System/Daemons

%description module-mmcount
This module provides the capability to count log messages by severity
or json property of given app-name.  The count value is added into the 
log message as json property named 'mmcount'

%endif

%if %{with mmsequence}

%package module-mmsequence
Requires:       %{name} = %{version}
Summary:        Number generator and counter module
Group:          System/Daemons

%description module-mmsequence
This module generates numeric sequences of different kinds. 
It can be used to count messages up to a limit and to number them. 
It can generate random numbers in a given range.
This module is implemented via the output module interface, so it is called 
just as an action. The number generated is stored in a variable.
%endif

%if %{with mmfields}

%package module-mmfields
Requires:       %{name} = %{version}
Summary:        Fields Extraction Module
Group:          System/Daemons

%description module-mmfields
The mmfield module permits to extract fields. It is an alternate
to using the property replacer field extraction capabilities. In contrast 
to the property 
%endif

%if %{with gssapi}

%package module-gssapi
Requires:       %{name} = %{version}
Summary:        GSS-API support module for rsyslog
Group:          System/Daemons

%description module-gssapi
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides the support to receive syslog messages from the
network protected via Kerberos 5 encryption and authentication.

%endif

%if %{with mysql}

%package module-mysql
Requires:       %{name} = %{version}
Summary:        MySQL support module for rsyslog
Group:          System/Daemons

%description module-mysql
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This package provides a module with the support for logging into MySQL
databases.

%endif

%if %{with pgsql}

%package module-pgsql
Requires:       %{name} = %{version}
Summary:        PostgreSQL support module for rsyslog
Group:          System/Daemons

%description module-pgsql
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides the support for logging into PostgreSQL databases.

%endif

%if %{with dbi}

%package module-dbi
Requires:       %{name} = %{version}
Summary:        Database support via DBI
Group:          System/Daemons

%description module-dbi
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This package provides a module with the support for logging into DBI
supported databases.

%endif

%if %{with snmp}

%package module-snmp
Requires:       %{name} = %{version}
Summary:        SNMP support module for rsyslog
Group:          System/Daemons

%description module-snmp
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides the ability to send syslog messages as an SNMPv1 &
v2c traps.

%endif

%if %{with gnutls}

%package module-gtls
Requires:       %{name} = %{version}
Summary:        TLS encryption support module for rsyslog
Group:          System/Daemons

%description module-gtls
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides the ability for TLS encrypted TCP logging (based
on current syslog-transport-tls internet drafts).
%endif

%if %{with gcrypt}

%package module-gcrypt
Requires:       %{name} = %{version}
Summary:        Libgcrypt log file encryption support module for rsyslog
Group:          System/Daemons

%description module-gcrypt
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides log file encryption support using libgcrypt and
a rsgtutil utility to manage the files.
%endif

%if %{with guardtime}

%package module-guardtime
Requires:       %{name} = %{version}
Summary:        GuardTime log file signing support module for rsyslog
Group:          System/Daemons

%description module-guardtime
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides log file signing support using GuardTime Keyless
Signature Service and a rsgtutil utility to manage the files.

The digital timestamping component of the service is officially certified
and Guardtime is accredited as a timestamp authority by the European Union.
%endif

%if %{with relp}

%package module-relp
Requires:       %{name} = %{version}
Summary:        RELP protocol support module for syslog
Group:          System/Daemons

%description module-relp
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides Reliable Event Logging Protocol support.

%endif

%if %{with mmnormalize}

%package module-mmnormalize
Requires:       %{name} = %{version}
Summary:        Contains the mmnormalize support module for syslog
Group:          System/Daemons

%description module-mmnormalize
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides log normalizing support.

%endif

%if %{with mmexternal}

%package module-mmexternal
Requires:       %{name} = %{version}
Summary:        Contains the mmexternal support module for syslog
Group:          System/Daemons

%description module-mmexternal
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides external message modification.

%endif

%if %{with udpspoof}

%package module-udpspoof
Requires:       %{name} = %{version}
Summary:        UDP spoof support module for syslog
Group:          System/Daemons

%description module-udpspoof
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides a UDP forwarder that allows changing the sender address.

%endif

%if %{with elasticsearch}

%package module-elasticsearch
Requires:       %{name} = %{version}
Summary:        ElasticSearch output module for syslog
Group:          System/Daemons

%description module-elasticsearch
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides support to output to an ElasticSearch database.

%endif

%if %{with hdfs}

%package module-hdfs
Requires:       %{name} = %{version}
Summary:        HDFS output module for syslog
Group:          System/Daemons

%description module-hdfs
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides support to output to an HDFS database.

%endif

%if %{with mongodb}

%package module-mongodb
Requires:       %{name} = %{version}
Summary:        MongoDB output module for syslog
Group:          System/Daemons

%description module-mongodb
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides support to output to a MongoDB database.

%endif

%if %{with hiredis}

%package module-hiredis
Requires:       %{name} = %{version}
Summary:        Redis output module for syslog
Group:          System/Daemons

%description module-hiredis
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides support to output to a Redis database.

%endif

%if %{with zeromq}

%package module-zeromq
Requires:       %{name} = %{version}
Summary:        ZeroMQ support module for syslog
Group:          System/Daemons

%description module-zeromq
Rsyslog is an enhanced multi-threaded syslog daemon. See rsyslog
package.

This module provides support for ZeroMQ.

%endif

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%patch0 -p1
#
%if %{with systemd}
for file in rsyslog-service-prepare; do
	sed \
	-e 's;RUN_DIR;%{rsyslog_rundir};g' \
	-e 's;ADDITIONAL_SOCKETS;%{rsyslog_sockets_cfg};g' \
	"%{_sourcedir}/${file}.in" > "${file}"
done
%endif
#dos2unix doc/*.html

%build
#export CFLAGS="$RPM_OPT_FLAGS -fno-strict-aliasing -W -Wall -I../grammar -I../../grammar -std=c99"

# for Patch3 rsyslog-8.4.0-json-c-0.12-configure.patch
autoreconf -fiv
export CFLAGS="$RPM_OPT_FLAGS -fno-strict-aliasing -W -Wall -I../grammar -I../../grammar"

# needs java
#        --enable-gui            \
%configure			\
	--with-moddirs=%{rsyslog_module_dir_withdeps} \
%if ! %{with rst2man}
	--enable-cached-man-pages	\
%endif
	--enable-option-checking	\
	--enable-largefile	\
	--enable-regexp		\
	--enable-zlib		\
	--enable-klog		\
	--enable-kmsg		\
	--enable-inet		\
	--enable-unlimited-select	\
	--enable-rsyslogd	\
%if %{with elasticsearch}
	--enable-elasticsearch	\
%endif
%if %{with gnutls}
	--enable-gnutls		\
%endif
%if %{with gssapi}
	--enable-gssapi-krb5	\
%endif
%if %{with dbi}
	--enable-libdbi		\
%endif
%if %{with mysql}
	--enable-mysql		\
%endif
%if %{with pgsql}
	--enable-pgsql		\
%endif
%if %{with relp}
	--enable-relp		\
%endif
%if %{with rfc3195}
        --enable-rfc3195        \
%endif
%if %{with snmp}
	--enable-snmp		\
	--enable-mmsnmptrapd	\
%endif
	--enable-mail		\
	--enable-imfile		\
	--enable-imptcp		\
	--enable-imttcp		\
	--enable-impstats	\
	--enable-omprog		\
	--enable-omuxsock	\
%if %{with udpspoof}
	--enable-omudpspoof	\
%endif
	--enable-omstdout	\
	--enable-pmlastmsg	\
	--enable-pmcisconames	\
	--enable-pmaixforwardedfrom	\
	--enable-pmsnare	\
	--enable-pmrfc3164sd	\
	--enable-omruleset	\
%if %{with mmnormalize}
	--enable-mmnormalize \
	--enable-mmjsonparse	\
	--enable-mmaudit	\
%endif
%if %{with mmcount}
	--enable-mmcount	\
%endif
%if %{with mmsequence}
	--enable-mmsequence	\
%endif    
%if %{with mmfields}
	--enable-mmfields	\
%endif 
%if %{with hdfs}
	--enable-omhdfs		\
%endif
%if %{with mongodb}
	--enable-ommongodb	\
%endif
%if %{with hiredis}
	--enable-omhiredis	\
%endif
%if %{with zeromq}
	--enable-imzmq3		\
	--enable-omzmq3		\
%endif
%if %{with diagtools}
	--enable-imdiag		\
	--enable-diagtools	\
%endif
%if %{with systemd} && %{with journal}
	--enable-imjournal	\
	--enable-omjournal	\
%endif
	--enable-mmanon		\
%if %{with guardtime}
	--enable-guardtime	\
%endif
%if %{with gcrypt}
	--enable-libgcrypt	\
%else
	--disable-libgcrypt	\
%endif
	--enable-usertools	\
	--disable-static


%install
make install DESTDIR="%{buildroot}"  V=1
#
rm -f %{buildroot}%{rsyslog_module_dir_nodeps}/*.la
#
# move all modules linking libraries in /usr to /usr/lib[64]
# the user has to specify them with full path then...
install -d -m0755 %{buildroot}%{rsyslog_module_dir_withdeps}
if test "%{rsyslog_module_dir_nodeps}" != "%{rsyslog_module_dir_withdeps}" ; then
	for mod in  \
%if %{with gnutls}
		lmnsd_gtls.so \
%endif
%if %{with gcrypt}
		lmcry_gcry.so \
%endif
%if %{with guardtime}
		lmsig_gt.so  \
%endif
%if %{with gssapi}
		omgssapi.so imgssapi.so lmgssutil.so \
%endif
%if %{with dbi}
		omlibdbi.so \
%endif
%if %{with mysql}
		ommysql.so \
%endif
%if %{with pgsql}
		ompgsql.so \
%endif
%if %{with relp}
		imrelp.so omrelp.so \
%endif
%if %{with snmp}
		omsnmp.so \
%endif
%if %{with mmnormalize}
		mmnormalize.so  \
		mmjsonparse.so \
		mmaudit.so \
%endif
%if %{with elasticsearch}
		omelasticsearch.so \
%endif
	; do
		mv -f %{buildroot}%{rsyslog_module_dir_nodeps}/$mod \
		      %{buildroot}%{rsyslog_module_dir_withdeps}
	done
fi
if test "%{_sbindir}" != "/sbin" ; then
	install -d -m0755 %{buildroot}/sbin
	ln -sf %{_sbindir}/rsyslogd $RPM_BUILD_ROOT/sbin/rsyslogd
fi
#
%if %{with systemd} && ! %{with systemv}
install -m755 rsyslog-service-prepare %{buildroot}%{_sbindir}/
%else
if test -e %{buildroot}%{_unitdir}/rsyslog.service ; then
	rm -f %{buildroot}%{_unitdir}/rsyslog.service
fi
%endif
#
install -d -m0755 %{buildroot}%{_sysconfdir}/rsyslog.d
install -d -m0755 %{buildroot}/run/rsyslog
install -d -m0755 %{buildroot}%{_localstatedir}/spool/rsyslog
for file in rsyslog.conf rsyslog.d.remote.conf ; do
	sed \
%ifarch s390 s390x
	-e 's;tty10;console;g' \
%endif
	-e 's;ADDITIONAL_SOCKETS;%{rsyslog_sockets_cfg};g' \
	-e 's;ETC_RSYSLOG_CONF;%{_sysconfdir}/rsyslog.conf;g' \
	-e 's;ETC_RSYSLOG_D_DIR;%{_sysconfdir}/rsyslog.d;g' \
	-e 's;ETC_RSYSLOG_D_GLOB;%{_sysconfdir}/rsyslog.d/*.conf;g' \
	-e 's;RSYSLOG_SPOOL_DIR;%{_localstatedir}/spool/rsyslog;g' \
	%{_sourcedir}/${file}.in > ${file}.$$
done
install    -m0600 rsyslog.conf.$$ \
                  %{buildroot}%{_sysconfdir}/rsyslog.conf
install    -m0600 rsyslog.d.remote.conf.$$ \
                  %{buildroot}%{_sysconfdir}/rsyslog.d/remote.conf
#
install -d -m0755 %{buildroot}/var/adm/fillup-templates
install    -m0600 %{_sourcedir}/rsyslog.sysconfig \
                  %{buildroot}/var/adm/fillup-templates/sysconfig.syslog-rsyslog
#
rm -f doc/Makefile*
install -d -m0755 %{buildroot}%{rsyslogdocdir}/
find ChangeLog README AUTHORS COPYING COPYING.LESSER \
	\( -type d -exec install -m755 -d   %{buildroot}%{rsyslogdocdir}/\{\} \; \) \
     -o \( -type f -exec install -m644 \{\} %{buildroot}%{rsyslogdocdir}/\{\} \; \)
#
%if %{with mysql}
install -m644 plugins/ommysql/createDB.sql \
	%{buildroot}%{rsyslogdocdir}/mysql-createDB.sql
%endif
%if %{with pgsql}
install -m644 plugins/ompgsql/createDB.sql \
	%{buildroot}%{rsyslogdocdir}/pgsql-createDB.sql
%endif
# create ghosts
install -d -m0755 %{buildroot}%{rsyslog_rundir}
touch %{buildroot}%{rsyslog_sockets_cfg}
chmod 644 %{buildroot}%{rsyslog_sockets_cfg}

%clean
if [ -n "%{buildroot}" ] && [ "%{buildroot}" != "/" ] ; then
	rm -rf "%{buildroot}"
fi

%if %{with systemd} && ! %{with systemv}

%pre
%{service_add_pre rsyslog.service}

%endif

%post
#
# update linker caches
#
/sbin/ldconfig
#
# remove obsolete variables
#
%{remove_and_set -n syslog SYSLOG_DAEMON SYSLOG_REQUIRES_NETWORK}
%{remove_and_set -n syslog RSYSLOGD_COMPAT_VERSION RSYSLOGD_NATIVE_VERSION}
%if %{with systemv}
%{fillup_and_insserv -ny syslog syslog}
%endif
#
# add RSYSLOGD_* variables
#
%{fillup_only -ns syslog rsyslog}
%if %{with systemv}
#
# switch SYSLOG_DAEMON to outself
#
if test -f etc/sysconfig/syslog ; then
	sed -i \
		-e 's/^SYSLOG_DAEMON=.*/SYSLOG_DAEMON="rsyslogd"/g' \
		etc/sysconfig/syslog
fi
%endif
#
# Do not use multiple facilities with the same priority pattern.
# It causes start failure since rsyslog-6.4.x (bnc#780607).
#
# FIXME: it seems to be a valid syntax -> rsyslog bug?
#
if grep -qs '^local[0246],' etc/rsyslog.conf ; then
   sed -i -e 's/^local\([0246]\),/local\1.*;/g' etc/rsyslog.conf
fi
#
# create dirs, touch log default files
#
mkdir -p var/log
touch var/log/messages;  chmod 640 var/log/messages
touch var/log/mail;      chmod 640 var/log/mail
touch var/log/mail.info; chmod 640 var/log/mail.info
touch var/log/mail.warn; chmod 640 var/log/mail.warn
touch var/log/mail.err;  chmod 640 var/log/mail.err
test -f var/log/news && mv -f var/log/news var/log/news.bak
mkdir -p -m 0750 var/log/news
chown news:news  var/log/news
touch var/log/news/news.crit;   chmod 640 var/log/news/news.crit
chown news:news var/log/news/news.crit
touch var/log/news/news.err;    chmod 640 var/log/news/news.err
chown news:news var/log/news/news.err
touch var/log/news/news.notice; chmod 640 var/log/news/news.notice
chown news:news var/log/news/news.notice
#
# touch the additional log files we are using
#
touch var/log/acpid;            chmod 640 var/log/acpid
touch var/log/firewall;         chmod 640 var/log/firewall
touch var/log/NetworkManager;   chmod 640 var/log/NetworkManager
#
# touch the additional log sockets config file
#
mkdir -p -m750 ".%{rsyslog_rundir}"
touch ".%{rsyslog_sockets_cfg}"
chmod 640 ".%{rsyslog_sockets_cfg}"
#
# Enable the rsyslogservice to be started by systemd
#
%if %{with systemd} && ! %{with systemv}
# This macro enables based on a systemctl preset config file only
%{service_add_post rsyslog.service}
# But we want to enable a syslog-daemon regardless of the preset;
# force the creation of a syslog.service alias link (bnc#790805).
# We do not check the obsolete SYSLOG_DAEMON variable as we want
# to switch when installing it and there is a provider conflict.
/usr/bin/systemctl -f enable rsyslog.service >/dev/null 2>&1 || :
%endif

%preun
#
# stop the rsyslogd daemon when it is running
#
%if %{with systemd} && ! %{with systemv}
%{service_del_preun syslog.socket}
%{service_del_preun rsyslog.service}
%else
if test -x /etc/init.d/syslog ; then
	%{stop_on_removal syslog}
fi
#
# reset SYSLOG_DAEMON variable on removal
#
if test "$1" = "0" -a -f etc/sysconfig/syslog ; then
	sed -i \
		-e 's/^SYSLOG_DAEMON=.*/SYSLOG_DAEMON=""/g' \
		etc/sysconfig/syslog
fi
%endif

%postun
#
# update linker caches
#
/sbin/ldconfig
%if %{with systemd} && ! %{with systemv}
#
# cleanup init scripts
#
%{service_del_postun rsyslog.service}
%else
#
# stop the rsyslogd daemon when it is running
#
if test -x /etc/init.d/syslog ; then
	%{restart_on_update syslog}
fi
#
# cleanup init scripts
#
%{insserv_cleanup}
%endif

%files
%defattr(-,root,root)
%dir %{_sysconfdir}/rsyslog.d
%config(noreplace) %attr(600,root,root) %{_sysconfdir}/rsyslog.conf
%config(noreplace) %attr(600,root,root) %{_sysconfdir}/rsyslog.d/remote.conf
%{_sbindir}/rsyslogd
%if "%{_sbindir}" != "/sbin"
/sbin/rsyslogd
%endif
%dir %{rsyslog_module_dir_nodeps}
%{rsyslog_module_dir_nodeps}/imfile.so
%{rsyslog_module_dir_nodeps}/imklog.so
%{rsyslog_module_dir_nodeps}/imkmsg.so
%{rsyslog_module_dir_nodeps}/immark.so
%{rsyslog_module_dir_nodeps}/impstats.so
%{rsyslog_module_dir_nodeps}/imtcp.so
%{rsyslog_module_dir_nodeps}/imudp.so
%{rsyslog_module_dir_nodeps}/imuxsock.so
%{rsyslog_module_dir_nodeps}/lmnet.so
%{rsyslog_module_dir_nodeps}/lmnetstrms.so
%{rsyslog_module_dir_nodeps}/lmnsd_ptcp.so
%{rsyslog_module_dir_nodeps}/imptcp.so
%{rsyslog_module_dir_nodeps}/lmregexp.so
%{rsyslog_module_dir_nodeps}/lmstrmsrv.so
%{rsyslog_module_dir_nodeps}/lmtcpclt.so
%{rsyslog_module_dir_nodeps}/lmtcpsrv.so
%{rsyslog_module_dir_nodeps}/lmzlibw.so
%{rsyslog_module_dir_nodeps}/mmanon.so
%{rsyslog_module_dir_nodeps}/ommail.so
%{rsyslog_module_dir_nodeps}/omprog.so
%{rsyslog_module_dir_nodeps}/omruleset.so
%{rsyslog_module_dir_nodeps}/omstdout.so
%{rsyslog_module_dir_nodeps}/omtesting.so
%{rsyslog_module_dir_nodeps}/omuxsock.so
%{rsyslog_module_dir_nodeps}/pmlastmsg.so
%{rsyslog_module_dir_nodeps}/pmaixforwardedfrom.so
%{rsyslog_module_dir_nodeps}/pmcisconames.so
%{rsyslog_module_dir_nodeps}/pmsnare.so
%if %{with rfc3195}
%{rsyslog_module_dir_nodeps}/im3195.so
%endif
%if %{with systemd} && %{with journal}
%{rsyslog_module_dir_nodeps}/imjournal.so
%{rsyslog_module_dir_nodeps}/omjournal.so
%endif
%dir %{rsyslog_module_dir_withdeps}
%{_mandir}/man5/rsyslog.conf.5*
%{_mandir}/man8/rsyslogd.8*
%dir %{rsyslogdocdir}
%doc %{rsyslogdocdir}/ChangeLog
%doc %{rsyslogdocdir}/README
%doc %{rsyslogdocdir}/AUTHORS
%doc %{rsyslogdocdir}/COPYING
%doc %{rsyslogdocdir}/COPYING.LESSER
%dir %{_localstatedir}/spool/rsyslog
/var/adm/fillup-templates/sysconfig.syslog-rsyslog
%attr(0755,root,root) %dir %ghost %{rsyslog_rundir}
%attr(0644,root,root) %ghost %{rsyslog_sockets_cfg}
%if %{with systemd} && ! %{with systemv}
%{_sbindir}/rsyslog-service-prepare
%{_unitdir}/rsyslog.service
%endif

%if %{with diagtools}

%files diag-tools
%defattr(-,root,root)
%{_sbindir}/msggen
%{_sbindir}/rsyslog_diag_hostname
%{rsyslog_module_dir_nodeps}/imdiag.so
%endif

%if %{with gssapi}

%files module-gssapi
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/omgssapi.so
%{rsyslog_module_dir_withdeps}/imgssapi.so
%{rsyslog_module_dir_withdeps}/lmgssutil.so
%endif

%if %{with mmcount}

%files module-mmcount
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/mmcount.so
%endif

%if %{with mmfields}

%files module-mmfields
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/mmfields.so
%endif

%if %{with mmsequence}

%files module-mmsequence
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/mmsequence.so
%endif

%if %{with mysql}

%files module-mysql
%defattr(-,root,root)
%doc %{rsyslogdocdir}/mysql-createDB.sql
%{rsyslog_module_dir_withdeps}/ommysql.so
%endif

%if %{with pgsql}

%files module-pgsql
%defattr(-,root,root)
%doc %{rsyslogdocdir}/pgsql-createDB.sql
%{rsyslog_module_dir_withdeps}/ompgsql.so
%endif

%if %{with dbi}

%files module-dbi
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/omlibdbi.so
%endif

%if %{with snmp}

%files module-snmp
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/omsnmp.so
%{rsyslog_module_dir_nodeps}/mmsnmptrapd.so
%endif

%if %{with gnutls}

%files module-gtls
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/lmnsd_gtls.so
%endif

%if %{with relp}

%files module-relp
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/imrelp.so
%{rsyslog_module_dir_withdeps}/omrelp.so
%endif

%if %{with mmnormalize}

%files module-mmnormalize
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/mmnormalize.so
%{rsyslog_module_dir_withdeps}/mmjsonparse.so
%{rsyslog_module_dir_withdeps}/mmaudit.so
%endif

%if %{with mmexternal}
%files module-mmexternal
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/mmexternal.so
%endif

%if %{with udpspoof}

%files module-udpspoof
%defattr(-,root,root)
%{rsyslog_module_dir_nodeps}/omudpspoof.so
%endif

%if %{with elasticsearch}

%files module-elasticsearch
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/omelasticsearch.so
%endif

%if %{with hdfs}

%files module-hdfs
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/omhdfs.so
%endif

%if %{with mongodb}

%files module-mongodb
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/ommongodb.so
%endif

%if %{with hiredis}

%files module-hiredis
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/omhiredis.so
%endif

%if %{with zeromq}

%files module-zeromq
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/imzmq3.so
%{rsyslog_module_dir_withdeps}/omzmq3.so
%endif

%if %{with gcrypt}

%files module-gcrypt
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/lmcry_gcry.so
%{_bindir}/rscryutil
#%{_mandir}/man1/rscryutil.1*
%endif

%if %{with guardtime}

%files module-guardtime
%defattr(-,root,root)
%{rsyslog_module_dir_withdeps}/lmsig_gt.so
%{_bindir}/rsgtutil
#%{_mandir}/man1/rsgtutil.1*
%endif

%changelog
