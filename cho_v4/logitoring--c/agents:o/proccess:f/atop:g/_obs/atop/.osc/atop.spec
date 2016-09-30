# vim: set ts=4 sw=4 et:

# Copyright (c) 2012 Pascal Bleser <pascal.bleser@opensuse.org>
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

Summary:        Monitor for System Resources and Process Activity
Patch1:         atop-makefile.patch
URL:            http://www.atoptool.nl/
Group:          System/Monitoring
License:        GPL-2.0
BuildRoot:      %{_tmppath}/build-%{name}-%{version}
Requires:	zlib
Requires:	ncurses
BuildRequires:  ncurses-devel make glibc-devel gcc
BuildRequires:  zlib-devel
# not really, just for directory ownership:
%if 0%{?suse_version} >= 1210
BuildRequires:  systemd
%endif
%if 0%{?suse_version:1}
BuildRequires:  update-desktop-files
%endif

%description
Atop is an ASCII full-screen performance monitor, similar to the top
command. At regular intervals, it shows system-level activity related to
the CPU, memory, swap, disks and network layers, and it shows for every
active process the CPU utilization in system and user mode, the virtual
and resident memory growth, priority, username, state, and exit code. The
process level activity is also shown for processes which finished during
the last interval, to get a complete overview about the consumers of things
such as CPU time. Atop only shows the active system-resources and processes,
and only shows the deviations since the previous interval.

%package daemon
Summary:        System Resource and Process Monitoring History Daemon
Group:          System/Monitoring
Requires:       %{name} = %{version}-%{release}
Recommends:     logrotate
Recommends:     cron

%description daemon
Atop is an ASCII full-screen performance monitor, similar to the top
command. At regular intervals, it shows system-level activity related to
the CPU, memory, swap, disks and network layers, and it shows for every
active process the CPU utilization in system and user mode, the virtual
and resident memory growth, priority, username, state, and exit code. The
process level activity is also shown for processes which finished during
the last interval, to get a complete overview about the consumers of things
such as CPU time. Atop only shows the active system-resources and processes,
and only shows the deviations since the previous interval.

This subpackage contains the permanent monitoring daemon, to store history
information about processes and system resources.

%prep
## // REV5 \\
%setup -n %{name}-%{version}-%{_my_release_num}
## \\ REV5 //

%patch1

%build
%__make %{?_smp_mflags} \
%if 0%{suse_version} <= 1000
    	  OPTFLAGS="%{optflags}" \
%else
    	  OPTFLAGS="%{optflags} -fstack-protector" \
%endif
    	  CC="%__cc" \

%install
%makeinstall systemdinstall 

%__rm -f "%{buildroot}%{_localstatedir}/log/atop"/*

%if 0%{?suse_version} >= 1210
%__install -D -m0644 "atop.service" "%{buildroot}/usr/lib/systemd/system/%{name}.service"
%endif

%__install -d "%{buildroot}/usr/sbin"

%postun daemon
%restart_on_update "%{name}"
%insserv_cleanup

%preun daemon
%stop_on_removal "%{name}"

%clean
%{?buildroot:%__rm -rf "%{buildroot}"}

%files
%defattr(-,root,root)
%doc COPYING README
%attr(0755,root,root) %{_bindir}/atop
%attr(0755,root,root) %{_bindir}/atopsar
%{_bindir}/atop-%{version}-%{_my_release_num}
%{_bindir}/atopsar-%{version}-%{_my_release_num}
%doc %{_mandir}/man1/atop.1%{ext_man}
%doc %{_mandir}/man1/atopsar.1%{ext_man}
%doc %{_mandir}/man5/atoprc.5%{ext_man}

%files daemon
%defattr(-,root,root)
%doc COPYING README
%{_sbindir}/atopacctd
%doc %{_mandir}/man8/atopacctd.8%{ext_man}
%attr(0700,root,root) %dir %{_sysconfdir}/atop
%attr(0700,root,root) %{_sysconfdir}/atop/atop.daily
%config(noreplace) /etc/logrotate.d/psaccs_atop
%config(noreplace) /etc/logrotate.d/psaccu_atop
%config(noreplace) /etc/cron.d/%{name}
%{_localstatedir}/log/atop
%if 0%{?suse_version} >= 1210
%dir /usr/lib/systemd/system
%config /usr/lib/systemd/system/%{name}.service
%config /usr/lib/systemd/system/atopacct.service
%config /usr/lib/systemd/system-sleep/atop-pm.sh

%endif

%changelog
