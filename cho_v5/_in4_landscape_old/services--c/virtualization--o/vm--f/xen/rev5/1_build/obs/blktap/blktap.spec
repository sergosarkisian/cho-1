
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

Summary: Blktap user space utilities
License: GPLv2 or BSD
Group: System/Hypervisor

Patch0: blktap-gntcpy.patch
Patch1: %{name}-udev-ignore-tapdevs.patch
Patch2: thin_log_define.patch

BuildRoot: %{_tmppath}/%{name}-%{release}-buildroot
Obsoletes: xen-blktap
BuildRequires: e2fsprogs-devel
BuildRequires: libaio-devel
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires: libtool
BuildRequires: kernel-xen-devel kernel-xen xen-devel

%description
Blktap creates kernel block devices which realize I/O requests to
processes implementing virtual hard disk images entirely in user
space.

Typical disk images may be implemented as files, in memory, or
stored on other hosts across the network. The image drivers included
with tapdisk can map disk I/O to sparse file images accessed through
Linux DIO/AIO and VHD images with snapshot functionality.

This packages includes the control utilities needed to create
destroy and manipulate devices ('tap-ctl'), the 'tapdisk' driver
program to perform tap devices I/O, and a number of image drivers.

%package devel
Summary: BlkTap Development Headers and Libraries
Requires: blktap = %{version}
Group: Development/Libraries
Obsoletes: xen-blktap

%description devel
Blktap and VHD development files.

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%patch0 -p1
%patch1 -p1
%patch2 -p1

%build
libtoolize
autoreconf --install
%configure --disable-gcopy
make

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
rm %{buildroot}/etc/rc.d/init.d/*

%files
%defattr(-,root,root,-)
%doc
%{_libdir}/*.so
%{_libdir}/*.so.*
%{_bindir}/vhd-util
%{_bindir}/vhd-update
%{_bindir}/vhd-index
%{_bindir}/tapback
%{_sbindir}/lvm-util
%{_sbindir}/tap-ctl
%{_sbindir}/td-util
%{_sbindir}/td-rated
%{_sbindir}/part-util
%{_sbindir}/vhdpartx
%{_sbindir}/thin-cli
%{_sbindir}/thinprovd
%{_sbindir}/xlvhd-refresh
%{_sbindir}/xlvhd-resize
%{_libexecdir}/tapdisk
%dir %{_sysconfdir}/udev
%dir %{_sysconfdir}/udev/rules.d
%{_sysconfdir}/udev/rules.d/blktap.rules
%{_sysconfdir}/logrotate.d/blktap
%dir %{_sysconfdir}/xensource
%dir %{_sysconfdir}/xensource/bugtool
%{_sysconfdir}/xensource/bugtool/tapdisk-logs.xml
%{_sysconfdir}/xensource/bugtool/tapdisk-logs/
%{_sysconfdir}/xensource/bugtool/tapdisk-logs/description.xml

%files devel
%defattr(-,root,root,-)
%doc
%{_libdir}/*.a
%{_libdir}/*.la
%dir %{_includedir}/vhd/
%{_includedir}/vhd/*
%dir %{_includedir}/blktap
%{_includedir}/blktap/*
# %dir /usr/lib/debug/usr
# %dir /usr/lib/debug/usr/sbin
# /usr/lib/debug/usr/sbin/*
# /usr/lib/debug/.build-id/

%post
ldconfig

%postun
ldconfig

%changelog
* Tue Dec 09 2014 Citrix Systems, Inc. <www.citrix.com> [3.0.0.xs992 xs6.5.0]
- Build blktap.
