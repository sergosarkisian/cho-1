#
# spec file for package kibana
#
# Copyright (c) 2015 Thomas Neuburger, t.neuburger@telekom.de
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

Name:           kibana
Version:        4.x
Release:        1
Summary:        Make sense of a mountain of logs
Group:          Productivity/Networking/Web/Frontends
License:        Apache-2.0
Url:            https://github.com/elastic/kibana
#Source:         https://download.elastic.co/kibana/kibana/kibana-%{version}-linux-x64.tar.gz
Source:         kibana-4.x.zip
Source1:        kibana.service
Source2:        kibana.logrotate
Source3:        kibana.sysconfig
Source5:        kibana.conf
Source6:        kibana.conf.sysv
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Requires:       logrotate
Requires(pre):  pwdutils
BuildRequires:	fdupes
BuildRequires: npm
BuildRequires: nodejs

# needed for brp-check-bytecode-version (jar, fastjar would do as well)
BuildRequires:	unzip

%if 0%{?suse_version} >= 1210
BuildRequires:  systemd-rpm-macros
%{?systemd_requires}
%bcond_without  systemd
%else
%bcond_with     systemd
%endif

%description
Kibana is a highly scalable interface for kibana and ElasticSearch that allows you to
efficiently search, graph, analyze and otherwise make sense of a mountain of logs.

%prep
%setup -q -n %{name}-%{version}

%build
npm install



%install
export NO_BRP_CHECK_BYTECODE_VERSION=true

## usr
%{__install} -d -m 755 %{buildroot}/%{_sbindir}

## etc
%{__install} -d -m 755 %{buildroot}%{_sysconfdir}/%{name}

## config without or with pidfile enabled(systemd or sysVinit)
%if %{with systemd}
%{__install} -D -m 644 %{S:5} %{buildroot}%{_sysconfdir}/%{name}/kibana.yml
%else
%{__install} -D -m 644 %{S:6} %{buildroot}%{_sysconfdir}/%{name}/kibana.yml
%endif

%{__install} -D -m 644 %{S:2} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}

## opt
%{__install} -d -m 755 %{buildroot}/opt/%{name}/
%{__install} -m 644 LICENSE.txt %{buildroot}/opt/%{name}/
%{__install} -m 644 README.txt %{buildroot}/opt/%{name}/
%{__install} -m 644 package.json %{buildroot}/opt/%{name}/
%{__install} -d -m 755 %{buildroot}/opt/%{name}/bin
%{__install} -m 755 bin/kibana %{buildroot}/opt/%{name}/bin/
%{__install} -d -m 755 %{buildroot}/opt/%{name}/installedPlugins
%{__install} -d -m 755 %{buildroot}/opt/%{name}/node
cp -rp node/* %{buildroot}/opt/%{name}/node/
%{__install} -d -m 755 %{buildroot}/opt/%{name}/node_modules
cp -rp node_modules/* %{buildroot}/opt/%{name}/node_modules/
%{__install} -d -m 755 %{buildroot}/opt/%{name}/optimize
cp -rp optimize/* %{buildroot}/opt/%{name}/optimize/
%{__install} -d -m 755 %{buildroot}/opt/%{name}/src
cp -rp src/* %{buildroot}/opt/%{name}/src/
%{__install} -d -m 755 %{buildroot}/opt/%{name}/webpackShims
cp -rp webpackShims/* %{buildroot}/opt/%{name}/webpackShims/

## var
%{__install} -d -m 755 %{buildroot}/var/log/%{name}/
%{__install} -d -m 755 %{buildroot}/var/lib/%{name}/

## sysconfig template
%{__mkdir} -p %{buildroot}/var/adm/fillup-templates/
%{__install} -m 644 %{S:3} %{buildroot}/var/adm/fillup-templates/sysconfig.%{name}

## service (systemd or sysVinit)
%if %{with systemd}
%{__mkdir} -p %{buildroot}%{_unitdir}
%{__install} -m 444 %{S:1} %{buildroot}%{_unitdir}/%{name}.service
ln -sf /usr/sbin/service %{buildroot}%{_sbindir}/rc%{name}
%endif

## delete waste files
find %{buildroot} -type f -name "*.un~" -delete

## finds duplicate files in a given set of directories
%fdupes $RPM_BUILD_ROOT


%pre
## Register service systemd
%if %{with systemd}
%service_add_pre %{name}.service
%endif

## create kibana group and user
getent group kibana >/dev/null || groupadd -r kibana
getent passwd kibana >/dev/null || useradd -r -g kibana -d /var/lib/empty -s /sbin/nologin -c "service user for kibana" kibana
exit 0

%post
## fill up sysconfig file
%{fillup_and_insserv -n -y %{name}}

## Register service systemd
%if %{with systemd}
%service_add_post %{name}.service
%endif


cat <<EOF

================================================================================
kibana 4.4 requires elasticsearch >= 2.1
=> this is not a requirement in the rpm cause elasticsearch 
   can be installed on a different host
================================================================================

EOF


%preun
## Stop service (systemd or sysVinit)
%if %{with systemd}
%service_del_preun %{name}.service
%else
%stop_on_removal
%endif


%postun
## no auto restart on update
export DISABLE_RESTART_ON_UPDATE=1

## Unregister service (systemd or sysVinit)
%if %{with systemd}
%service_del_postun %{name}.service
%else
%insserv_cleanup
%endif

# only execute in case of package removal, not on upgrade
if [ $1 -eq 0 ] ; then

    getent passwd kibana > /dev/null
    if [ "$?" == "0" ] ; then
        userdel kibana
    fi

    getent group kibana >/dev/null
    if [ "$?" == "0" ] ; then
        groupdel kibana
    fi
fi


%files
%defattr(-,root,root)

%if %{with systemd}
%{_unitdir}/%{name}.service
%else
%{_initrddir}/%{name}
%endif

%{_sbindir}/rc%{name}
%dir /opt/%{name}
/opt/%{name}/*
%dir /etc/%{name}/
%config /etc/%{name}/kibana.yml
/var/adm/fillup-templates/sysconfig.%{name}
%config(noreplace) /etc/logrotate.d/%{name}

%doc LICENSE.txt README.txt

%defattr(-,kibana,kibana)
%dir /var/log/%{name}
%dir /var/lib/%{name}
%dir /opt/%{name}/optimize/


%changelog

