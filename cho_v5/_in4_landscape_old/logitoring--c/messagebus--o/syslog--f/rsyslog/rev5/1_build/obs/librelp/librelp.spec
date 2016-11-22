#
# spec file for package librelp
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


%define library_name librelp0

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Url:            http://www.librelp.com/
Summary:        A reliable logging library
License:        GPL-3.0+
Group:          Development/Libraries/C and C++
BuildRequires:  pkgconfig
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
%if 0%{?sles_version} && 0%{?sles_version} <= 11
BuildRequires:  libgnutls-devel >= 1.4.0
%else
BuildRequires:  pkgconfig(gnutls) >= 1.4.0
%endif

%description
librelp is an easy to use library for the RELP protocol. RELP in turn provides
reliable event logging over the network (and consequently RELP stands for
Reliable Event Logging Protocol). RELP was initiated by Rainer Gerhards after
he was finally upset by the lossy nature of plain tcp syslog and wanted a cure
for all these dangling issues.

RELP (and hence) librelp assures that no message is lost, not even when
connections break and a peer becomes unavailable. The current version of RELP
has a minimal window of opportunity for message duplication after a session has
been broken due to network problems. In this case, a few messages may be
duplicated (a problem that also exists with plain tcp syslog). Future versions
of RELP will address this shortcoming. 

Please note that RELP is a general-purpose, extensible logging protocol. Even
though it was designed to solve the urgent need of rsyslog-to-rsyslog
communication, RELP supports many more applications. Extensible command verbs
provide ample opportunity to extend the protocol without affecting existing
applications.


Authors:
--------
    Rainer Gerhards <rgerhards@adiscon.com>


%package -n %library_name
Summary:        A reliable logging library
Group:          Development/Libraries/C and C++

%description -n %library_name
librelp is an easy to use library for the RELP protocol. RELP in turn provides
reliable event logging over the network (and consequently RELP stands for
Reliable Event Logging Protocol). RELP was initiated by Rainer Gerhards after
he was finally upset by the lossy nature of plain tcp syslog and wanted a cure
for all these dangling issues.

RELP (and hence) librelp assures that no message is lost, not even when
connections break and a peer becomes unavailable. The current version of RELP
has a minimal window of opportunity for message duplication after a session has
been broken due to network problems. In this case, a few messages may be
duplicated (a problem that also exists with plain tcp syslog). Future versions
of RELP will address this shortcoming. 

Please note that RELP is a general-purpose, extensible logging protocol. Even
though it was designed to solve the urgent need of rsyslog-to-rsyslog
communication, RELP supports many more applications. Extensible command verbs
provide ample opportunity to extend the protocol without affecting existing
applications.


Authors:
--------
    Rainer Gerhards <rgerhards@adiscon.com>

%package devel
Requires:       %{library_name} = %{version}
Summary:        A reliable logging library
Group:          Development/Libraries/C and C++
Requires:       libgnutls-devel >= 1.4.0

%description devel
librelp is an easy to use library for the RELP protocol. RELP in turn provides
reliable event logging over the network (and consequently RELP stands for
Reliable Event Logging Protocol). RELP was initiated by Rainer Gerhards after
he was finally upset by the lossy nature of plain tcp syslog and wanted a cure
for all these dangling issues.

RELP (and hence) librelp assures that no message is lost, not even when
connections break and a peer becomes unavailable. The current version of RELP
has a minimal window of opportunity for message duplication after a session has
been broken due to network problems. In this case, a few messages may be
duplicated (a problem that also exists with plain tcp syslog). Future versions
of RELP will address this shortcoming. 

Please note that RELP is a general-purpose, extensible logging protocol. Even
though it was designed to solve the urgent need of rsyslog-to-rsyslog
communication, RELP supports many more applications. Extensible command verbs
provide ample opportunity to extend the protocol without affecting existing
applications.


Authors:
--------
    Rainer Gerhards <rgerhards@adiscon.com>

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%build
libtoolize
autoreconf --install
%configure --disable-static --with-pic
make %{?_smp_mflags}

%install
%makeinstall
%{__rm} %{buildroot}%{_libdir}/librelp.la

%post   -n %{library_name} -p /sbin/ldconfig

%postun -n %{library_name} -p /sbin/ldconfig

%files -n librelp0
%defattr(-,root,root,-)
%{_libdir}/librelp.so.*

%files devel
%defattr(-,root,root,-)
%doc AUTHORS ChangeLog COPYING NEWS README doc/*.html
%{_includedir}/librelp.h
%{_libdir}/librelp.so
%{_libdir}/pkgconfig/relp.pc

%changelog
