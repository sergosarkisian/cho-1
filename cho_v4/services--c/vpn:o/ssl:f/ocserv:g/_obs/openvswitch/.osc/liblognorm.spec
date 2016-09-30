#
# spec file for package liblognorm
#
# Copyright (c) 2015 SUSE LINUX GmbH, Nuernberg, Germany.
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
%define service_main_version   %(ls %{_sourcedir}/*+.tar.* | cut -d "+" -f 3)
%define service_release_date   %(ls %{_sourcedir}/*+.tar.* | cut -d "+" -f 5)
%define service_release_commit %(ls %{_sourcedir}/*+.tar.* | cut -d "+" -f 7)
%define version %{service_main_version}
%define base_filename %{name}-git_+Ver+%{version}+Date+%{service_release_date}+Comm+%{service_release_commit}+
Source0: %{base_filename}.tar.gz
Version: %{version}
Release: 1
## \\ REV5 //


%define sover 2
%define with_html_docs 0%{?suse_version} >= 1310 && 0%{?suse_version} != 1315
Name:           liblognorm
Summary:        Library and tool to normalize log data
License:        LGPL-2.1+ and Apache-2.0
Group:          Development/Libraries/C and C++
Url:            http://www.liblognorm.com/
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
%if 0%{?suse_version} >= 1210
BuildRequires:  pkgconfig(json-c)
BuildRequires:  pkgconfig(libestr)
BuildRequires:  pkgconfig(libpcre)
BuildRequires:  pkgconfig(pkg-config) >= 0.9.0
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
%else
BuildRequires:  libestr-devel
BuildRequires:  libjson-c-devel
BuildRequires:  pcre-devel
BuildRequires:  pkg-config >= 0.9.0
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
%endif
%if %{with_html_docs}
BuildRequires:  python-sphinx
%endif

%description
Liblognorm is a fast-samples based normalization library. It is a library and
a tool to normalize log data.

Liblognorm shall help to make sense out of syslog data, or, actually, any event
data that is present in text form.

In short words, one will be able to throw arbitrary log message to liblognorm,
one at a time, and for each message it will output well-defined name-value
pairs and a set of tags describing the message.

So, for example, if you have traffic logs from three different firewalls,
liblognorm will be able to "normalize" the events into generic ones. Among
others, it will extract source and destination ip addresses and ports and make
them available via well-defined fields. As the end result, a common log
analysis application will be able to work on that common set and so this
backend will be independent from the actual firewalls feeding it. Even better,
once we have a well-understood interim format, it is also easy to convert that
into any other vendor specific format, so that you can use that vendor's
analysis tool.

%package -n     liblognorm%{sover}
Summary:        Library and tool to normalize log data
Group:          Development/Libraries/C and C++

%description  -n liblognorm%{sover}
Liblognorm is a library and a tool to normalize log data.

Liblognorm shall help to make sense out of syslog data, or, actually, any event
data that is present in text form.

In short words, one will be able to throw arbitrary log message to liblognorm,
one at a time, and for each message it will output well-defined name-value
pairs and a set of tags describing the message.

So, for example, if you have traffic logs from three different firewalls,
liblognorm will be able to "normalize" the events into generic ones. Among
others, it will extract source and destination ip addresses and ports and make
them available via well-defined fields. As the end result, a common log
analysis application will be able to work on that common set and so this
backend will be independent from the actual firewalls feeding it. Even better,
once we have a well-understood interim format, it is also easy to convert that
into any other vendor specific format, so that you can use that vendor's
analysis tool.

%package        devel
Summary:        Development files for %{name}
Group:          Development/Libraries/C and C++
Requires:       %{name}%{sover} = %{version}
Conflicts:      %{name}0-devel

%description    devel
Liblognorm is a library and a tool to normalize log data.

Liblognorm shall help to make sense out of syslog data, or, actually, any event
data that is present in text form.

In short words, one will be able to throw arbitrary log message to liblognorm,
one at a time, and for each message it will output well-defined name-value
pairs and a set of tags describing the message.

So, for example, if you have traffic logs from three different firewalls,
liblognorm will be able to "normalize" the events into generic ones. Among
others, it will extract source and destination ip addresses and ports and make
them available via well-defined fields. As the end result, a common log
analysis application will be able to work on that common set and so this
backend will be independent from the actual firewalls feeding it. Even better,
once we have a well-understood interim format, it is also easy to convert that
into any other vendor specific format, so that you can use that vendor's
analysis tool.

The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.

%prep
## // REV5 \\
%setup -n %{base_filename}
## \\ REV5 //

%build
libtoolize
autoreconf --install
%configure \
	--disable-static \
	--enable-regexp \
	--disable-testbench \
%if %{with_html_docs}
	--enable-docs \
	--docdir=%{_docdir}/%{name} \
%else
	--disable-docs \
%endif

make %{?_smp_mflags}

%install
make DESTDIR=%{buildroot} install %{?_smp_mflags}
find %{buildroot} -type f -name "*.la" -delete -print
%if %{with_html_docs}
rm %{buildroot}/%{_docdir}/%{name}/.buildinfo
%endif

%check
make check %{?_smp_mflags}

%post -n liblognorm%{sover} -p /sbin/ldconfig

%postun -n liblognorm%{sover} -p /sbin/ldconfig

%files -n liblognorm%{sover}
%defattr(-,root,root)
%doc COPYING
%{_libdir}/*.so.*
%{_bindir}/lognormalizer

%files devel
%defattr(-,root,root)
%doc COPYING NEWS README AUTHORS ChangeLog
%if %{with_html_docs}
%doc %{_docdir}/%{name}
%endif
%{_includedir}/*
%{_libdir}/*.so
%{_includedir}/*.h
%{_libdir}/pkgconfig/lognorm.pc

%changelog
