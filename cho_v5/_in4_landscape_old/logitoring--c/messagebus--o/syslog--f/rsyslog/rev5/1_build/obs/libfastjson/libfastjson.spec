#
# spec file for package libfastjson
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

%define somajor 4
Summary:        Fast JSON parsing library, a fork of json-c
License:        MIT
Group:          Development/Libraries/C and C++
Url:            https://github.com/rsyslog/libfastjson
BuildRequires:  pkgconfig
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
A fast JSON parsing library, a fork of json-c, developed by the rsyslog team
and used for rsyslog and liblognorm.

%package -n libfastjson%{somajor}
Summary:        Fast JSON parsing library
Group:          System/Libraries

%description -n libfastjson%{somajor}
A fast JSON parsing library, a fork of json-c, developed by the rsyslog team
and used for rsyslog and liblognorm.

This package includes the libfastjson library.

%package -n libfastjson-devel
Summary:        Development headers and libraries for libfastjson
Group:          Development/Libraries/C and C++
Requires:       libfastjson%{somajor} = %{version}

%description -n libfastjson-devel
A fast JSON parsing library, a fork of json-c, developed by the rsyslog team
and used for rsyslog and liblognorm.

This package includes header files and scripts needed for developers
using the libfastjson library

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%build
libtoolize
autoreconf --install
%configure --disable-static --with-pic
make %{?_smp_mflags}

%check
make %{?_smp_mflags} check

%install
make DESTDIR=%{buildroot} install %{?_smp_mflags}
find %{buildroot} -type f -name "*.la" -delete -print

%post -n libfastjson%{somajor} -p /sbin/ldconfig

%postun -n libfastjson%{somajor} -p /sbin/ldconfig

%files -n libfastjson%{somajor}
%defattr(-,root,root)
%doc COPYING
%{_libdir}/libfastjson.so.%{somajor}*

%files -n libfastjson-devel
%defattr(-,root,root)
%doc AUTHORS COPYING
%{_libdir}/libfastjson.so
%{_includedir}/libfastjson
%{_libdir}/pkgconfig/libfastjson.pc

%changelog