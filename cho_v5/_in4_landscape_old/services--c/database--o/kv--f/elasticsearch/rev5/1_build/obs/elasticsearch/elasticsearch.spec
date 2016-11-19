#
# spec file for "elasticsearch"
#
# Copyright (c) 2016 kkaempf
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

%define is_devel 0


%if 0%{?suse_version} > 1140 || 0%{?fedora_version} > 14
%define has_systemd 1
%else
%define has_systemd 0
%endif

%if 0%{?suse_version} > 1310
%define rundir /run
%else
%define rundir %{_localstatedir}/run
%endif


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
License:        APL-2.0
Summary:        Open Source, Distributed, RESTful Search Engine
Url:            https://github.com/elastic/elasticsearch
Group:          Productivity/Databases/Tools
Source1:        m2.tar.gz
Source2:        %{name}.logrotate
Source3:        %{name}.sysconfig
Source4:        %{name}.conf
Source5:        %{name}.tmpfiles.d
Source6:        %{name}.in.sh
Source7:        %{name}.service


BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  git
BuildRequires: java-1_8_0-openjdk-devel
BuildRequires: maven  

## DEVEL 
%if 0%{?is_devel}
BuildRequires: obs-resolv_dns
%endif

%if 0%{?has_systemd}
BuildRequires:  systemd
%{?systemd_requires}
%endif

# SLE_12 and Leap 42 need this:
BuildRequires: mozilla-nss 

BuildArch:      noarch
Provides:       mvn(org.elasticsearch:dev-tools) == %{version}-SNAPSHOT
Provides:       mvn(org.elasticsearch:rest-api-spec) == %{version}-SNAPSHOT
Provides:       mvn(org.elasticsearch:core) == %{version}-SNAPSHOT
Provides:       mvn(org.elasticsearch:modules) == %{version}-SNAPSHOT
Provides:       mvn(org.elasticsearch:distribution) == %{version}-SNAPSHOT
Provides:       mvn(org.elasticsearch:plugins) == %{version}-SNAPSHOT
Provides:       mvn(org.elasticsearch:qa) == %{version}-SNAPSHOT
Provides:       mvn(org:elasticsearch) == %{version}
Requires:       java-1_8_0-openjdk-headless
Requires:       logrotate
# mkdir, chown in %pre
Requires(pre):  coreutils

%description
Elasticsearch is a distributed RESTful search engine built for the
cloud. Reference documentation can be found at
https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
and the 'Elasticsearch: The Definitive Guide' book can be found at
https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html

%prep
## // REV5 \\
%if 0%{?is_devel}
echo "DEVEL MODE"
%else
%setup -b 1 -D -n .m2
%endif

%setup -n %{_obs_path}
## \\ REV5 //



%build
%if 0%{?is_devel}
echo "DEVEL MODE"
%else
cp -r %{_builddir}/.m2 %{_builddir}/../../
%endif

%if 0%{?is_devel}
mvn -am -pl '!distribution/rpm,!distribution/deb,!distribution/zip' -DskipTests package
%else
mvn -o -am -pl '!distribution/rpm,!distribution/deb,!distribution/zip' -DskipTests package
%endif

%install
export NO_BRP_CHECK_BYTECODE_VERSION=true
%if 0%{?is_devel}
mvn -am -pl '!distribution/rpm,!distribution/deb,!distribution/zip' -DskipTests install
%else
mvn -o -am -pl '!distribution/rpm,!distribution/deb,!distribution/zip' -DskipTests install
%endif
#
# /etc/sysconfig

install -d %{buildroot}%{_sysconfdir}
install -d %{buildroot}%{_sysconfdir}/%{name}
install -d %{buildroot}%{_sysconfdir}/%{name}/scripts
install distribution/src/main/resources/config/elasticsearch.yml %{buildroot}%{_sysconfdir}/%{name}
install distribution/src/main/resources/config/logging.yml %{buildroot}%{_sysconfdir}/%{name}

#
# bin

install -d %{buildroot}%{_datadir}/%{name}/bin
install -m 755 distribution/tar/target/bin/%{name} %{buildroot}%{_datadir}/%{name}/bin
install -m 755 distribution/tar/target/bin/plugin %{buildroot}%{_datadir}/%{name}/bin
install -m 755 %{S:6} %{buildroot}%{_datadir}/%{name}/bin

#
# lib

install -d %{buildroot}%{_datadir}/%{name}/lib
install distribution/tar/target/lib/*.jar %{buildroot}%{_datadir}/%{name}/lib

#
# modules

install -d %{buildroot}%{_datadir}/%{name}/modules
install -d %{buildroot}%{_datadir}/%{name}/modules/lang-expression
install -m 644 distribution/tar/target/modules/lang-expression/* %{buildroot}%{_datadir}/%{name}/modules/lang-expression
install -d %{buildroot}%{_datadir}/%{name}/modules/lang-groovy
install -m 644 distribution/tar/target/modules/lang-groovy/* %{buildroot}%{_datadir}/%{name}/modules/lang-groovy

#
# plugins

install -d %{buildroot}%{_datadir}/%{name}/plugins

#
# var

%{__install} -d -m 755 %{buildroot}%{_localstatedir}/log/%{name}
%{__install} -d -m 755 %{buildroot}%{_localstatedir}/lib/%{name}
%{__install} -d -m 755 %{buildroot}%{_localstatedir}/lib/%{name}/data
%{__install} -d -m 755 %{buildroot}%{_localstatedir}/lib/%{name}/work
%{__install} -d -m 755 %{buildroot}%{rundir}/%{name}


#
# /usr/share
%{__install} -d %{buildroot}%{_datadir}/%{name}

#
# sysconfig template
%{__mkdir} -p %{buildroot}%{_localstatedir}/adm/fillup-templates/
%{__install} -m 644 %{S:3} %{buildroot}%{_localstatedir}/adm/fillup-templates/sysconfig.%{name}

#
# sysctl.d
%{__install} -d -m 755 %{buildroot}%{_libexecdir}/sysctl.d
%{__install} -m 644 %{S:4} %{buildroot}%{_libexecdir}/sysctl.d/%{name}.conf

#
# tmpfiles.d
%{__install} -d -m 755 %{buildroot}%{_libexecdir}/tmpfiles.d
%{__install} -m 644 %{S:5} %{buildroot}%{_libexecdir}/tmpfiles.d/%{name}.conf


#
# sbin
install -d %{buildroot}%{_sbindir}

#
# init scripts / systemd

%if 0%{?has_systemd}
install -D -m 644 %{S:7} $RPM_BUILD_ROOT%{_unitdir}/%{name}.service
%endif

#
# logrotate

%{__install} -D -m 644 %{S:2} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}

%pre
%if 0%{?has_systemd}
%service_add_pre %{name}.service
%endif

## create %{name} group and user
getent group %{name} >/dev/null || groupadd -r %{name}
getent passwd %{name} >/dev/null || useradd -r -g %{name} -d %{_localstatedir}/lib/%{name} -s /sbin/nologin -c "service user for elasticsearch" %{name}
exit 0

%post
%{fillup_and_insserv -n -y %{name}}

# rpm is kinda stupid ...
# Create our dirs immediatly, after a manual package install.
# After a reboot systemd/aaa_base will take care.
test -d %{rundir}/%{name} || mkdir -m 755 %{rundir}/%{name} && chown %{name}.%{name} %{rundir}/%{name}

%preun
%if 0%{?has_systemd}
%service_del_preun %{name}.service
%else
%stop_on_removal
%endif

%postun
## no auto restart on update
export DISABLE_RESTART_ON_UPDATE=1

%if 0%{?has_systemd}
%service_del_postun %{name}.service
%else
%insserv_cleanup
%endif

# only execute in case of package removal, not on upgrade
if [ $1 -eq 0 ] ; then
  getent passwd %{name} > /dev/null
  if [ "$?" == "0" ] ; then
    userdel %{name}
  fi
                     
  getent group %{name} >/dev/null
  if [ "$?" == "0" ] ; then
    groupdel %{name}
  fi
fi
                                         

%files
%defattr(-,root,root)

#%doc %{name}-%{version}/README.textile
#%doc %{name}-%{version}/LICENSE.txt
#%doc %{name}-%{version}/NOTICE.txt

%config(noreplace) %dir %attr(750,root,%{name}) %{_sysconfdir}/%{name}
%config(noreplace) %attr(750,root,%{name}) %{_sysconfdir}/%{name}/%{name}.yml
%config(noreplace) %attr(750,root,%{name}) %{_sysconfdir}/%{name}/logging.yml
%config(noreplace) %dir %attr(750,root,%{name}) %{_sysconfdir}/%{name}/scripts

%dir %{_datadir}/%{name}

%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}

%dir %{_datadir}/%{name}
%{_datadir}/%{name}/*

#%attr(755,root,root) "%{_datadir}/%{name}/bin/"
# "%{_datadir}/%{name}/lib"
# "%{_datadir}/%{name}/modules"

%if 0%{?has_systemd}
%config %{_unitdir}/%{name}.service
%else
%config %attr(755,root,root)  "%{_sysconfdir}/init.d/%{name}"
%endif

#%{_sbindir}/rc%{name}

%{_localstatedir}/adm/fillup-templates/sysconfig.%{name}

%config %{_libexecdir}/sysctl.d/%{name}.conf
%config %{_libexecdir}/tmpfiles.d/%{name}.conf

%dir %attr(755,%{name},%{name}) %{_localstatedir}/lib/%{name}
%dir %attr(755,%{name},%{name}) %{_localstatedir}/log/%{name}
%dir %attr(755,%{name},%{name}) %{_datadir}/%{name}/plugins
%ghost %dir %attr(755,%{name},%{name}) %{rundir}/%{name}

%changelog
