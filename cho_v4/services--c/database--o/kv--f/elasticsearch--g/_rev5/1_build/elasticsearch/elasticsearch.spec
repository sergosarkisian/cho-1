#
# spec file for package elasticsearch 
#
# Copyright (c) 2014 SUSE LINUX Products GmbH, Nuernberg, Germany.
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

%define debug_package %{nil}
%define base_install_dir %{_javadir}/%{name}

%define _binaries_in_noarch_packages_terminate_build 0
%global _binaries_in_noarch_packages_terminate_build 0

%{!?_tmpfilesdir:%global _tmpfilesdir /usr/lib/tmpfiles.d}

# Macro that print mesages to syslog at package (un)install time
%define         nnmmsg logger -t %{name}/rpm

%{?systemd_requires}

Summary:        Open Source, Distributed, RESTful Search Engine

Group:          Productivity/Databases/Servers
License:        Apache-2.0
URL:            http://www.elasticsearch.org
Source1:        elasticsearch.logrotate.d
Source2:        elasticsearch.sysconfig
Source3:        elasticsearch.tmpfiles.d
Source4:        elasticsearch.service


BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       systemd
Requires:       cron
Requires:       logrotate
Requires:       jpackage-utils
Requires:       jre >= 1.6.0

%if 0%{?suse_version} >= 1210
BuildRequires:  systemd
%endif

Requires(pre):  pwdutils
Requires(pre):  %fillup_prereq
Requires(pre):  /bin/logger

Recommends:     %{name}-reverse-proxy

%description
ElasticSearch - a distributed, RESTful and full-text indexing and search engine
build on top of Apache Lucene.
- Real time data and analytics
- High availability
- Multi-tenancy
- Document oriented and Schema free
- Per-operation persistence


%prep
## // REV5 \\ WITH FIX
%setup -n %{name}-%{version}
## \\ REV5 //

%build
true

%install
export NO_BRP_CHECK_BYTECODE_VERSION=true

# bins
%{__mkdir} -p %{buildroot}%{_javadir}/%{name}/bin
%{__install} -p -m 755 bin/elasticsearch %{buildroot}%{_javadir}/%{name}/bin
%{__install} -p -m 755 bin/elasticsearch.in.sh %{buildroot}%{_javadir}/%{name}/bin
%{__install} -p -m 755 bin/plugin %{buildroot}%{_javadir}/%{name}/bin

# libs
%{__mkdir} -p %{buildroot}%{_javadir}/%{name}/lib/sigar
%{__install} -p -m 644 lib/*.jar %{buildroot}%{_javadir}/%{name}/lib


# config
%{__mkdir} -p %{buildroot}%{_sysconfdir}/%{name}
%{__install} -m 644 config/* %{buildroot}%{_sysconfdir}/%{name}

# data
%{__mkdir} -p %{buildroot}%{_localstatedir}/lib/%{name}

# logs
%{__mkdir} -p %{buildroot}%{_localstatedir}/log/%{name}
%{__install} -D -m 644 %{S:1} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}

# plugins
%{__mkdir} -p %{buildroot}%{_javadir}/%{name}/plugins

# docs
%{__install} -m 644 LICENSE.txt %{buildroot}%{_javadir}/%{name}
%{__install} -m 644 NOTICE.txt %{buildroot}%{_javadir}/%{name}
%{__install} -m 644 README.textile %{buildroot}%{_javadir}/%{name}

# sysconfig
%{__mkdir} -p %{buildroot}/var/adm/fillup-templates/
%{__install} -m 644 %{S:2} %{buildroot}/var/adm/fillup-templates/sysconfig.%{name}

# tmpfiles.d
%{__install} -d -m 0755 %{buildroot}%{_tmpfilesdir}/
%{__install} -m 0644 %{S:3} %{buildroot}%{_tmpfilesdir}/%{name}.conf

# systemd
%{__mkdir} -p %{buildroot}%{_unitdir}
%{__install} -m 644 %{S:4} %{buildroot}%{_unitdir}/%{name}.service

%{__mkdir} -p %{buildroot}%{_localstatedir}/lock/subsys/%{name}


%clean
%{__rm} -rf %{buildroot}

%pre
# create elasticsearch group
if ! getent group elasticsearch >/dev/null; then
        groupadd -r elasticsearch
fi

# create elasticsearch user
if ! getent passwd elasticsearch >/dev/null; then
        useradd -r -g elasticsearch -d %{_javadir}/%{name} \
            -s /sbin/nologin -c "You know for search" elasticsearch
fi

#
%service_add_pre %{name}.service

%post
# update linker caches
ldconfig

# fill up sysconfig file
%fillup_only

#directory to be available after package installation
systemd-tmpfiles --create %{_tmpfilesdir}/%{name}.conf

# Enable the elasticsearch service to be started by systemd
%service_add_post %{name}.service

%preun
# stop the elasticsearch daemon when it is running
%service_del_preun %{name}.service

%postun
# update linker caches
ldconfig

# cleanup init scripts
%service_del_postun %{name}.service

# only execute in case of package removal, not on upgrade
if [ $1 -eq 0 ] ; then

    getent passwd elasticsearch > /dev/null
    if [ "$?" == "0" ] ; then
        userdel elasticsearch
    fi

    getent group elasticsearch >/dev/null
    if [ "$?" == "0" ] ; then
        groupdel elasticsearch
    fi
fi

%service_del_postun %{name}.service


%files
%defattr(-,root,root,-)
%dir %{_javadir}/%{name}
%dir %{_javadir}/%{name}/bin/
%dir %{_javadir}/%{name}/lib/
%dir %{_javadir}/%{name}/plugins
%{_javadir}/%{name}/bin/*
%{_javadir}/%{name}/lib/*
%doc %{_javadir}/%{name}/LICENSE.txt
%doc %{_javadir}/%{name}/NOTICE.txt
%doc %{_javadir}/%{name}/README.textile
%config(noreplace) %{_sysconfdir}/%{name}
/var/adm/fillup-templates/sysconfig.%{name}
%{_unitdir}/%{name}.service
%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}
%{_tmpfilesdir}/%{name}.conf

%defattr(-,elasticsearch,elasticsearch,-)
%dir %{_localstatedir}/lib/%{name}
%dir %{_localstatedir}/log/%{name}


%changelog
