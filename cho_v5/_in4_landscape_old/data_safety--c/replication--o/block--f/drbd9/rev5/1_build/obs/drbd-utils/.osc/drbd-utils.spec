#
# spec file for package DRBD9
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


Summary:        Distributed Replicated Block Device
License:        GPL-2.0+
Group:          Productivity/Clustering/HA
Url:            http://www.drbd.org/

Patch1:         fix-libdir-in-Makefile.patch
Patch2:         zeroout-discard-devices.patch

BuildRequires:  git
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  bison
BuildRequires:  docbook-xsl-stylesheets
BuildRequires:  flex
BuildRequires:  gcc
BuildRequires:  glibc-devel
BuildRequires:  libxslt
BuildRequires:  make
BuildRequires:  systemd
BuildRequires:  udev
Provides:       drbd-control
Provides:       drbdsetup
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Requires(post): %insserv_prereq %fillup_prereq
Requires(preun): %insserv_prereq %fillup_prereq
Requires(postun): %insserv_prereq fileutils


%description
Drbd is a distributed replicated block device. It mirrors a block
device over the network to another machine. Think of it as networked
raid 1. It is a building block for setting up clusters.

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%patch1 -p1
%patch2 -p1

mkdir source
cp -a drbd/. source/. || :
cp $RPM_SOURCE_DIR/drbd_git_revision source/.drbd_git_revision
# cp source/Makefile-2.6 source/Makefile
# WIP cp -a %_sourcedir/Module.supported source/
mkdir obj

%build
./autogen.sh
PATH=/sbin:$PATH ./configure \
    --with-udev \
    --with-distro=suse \
    --without-heartbeat \
    --with-pacemaker \
    --with-bashcompletion \
    --with-initscripttype=systemd \
    --with-systemdunitdir=/usr/lib/systemd/system \
    --prefix=/ \
    --sbindir=/sbin \
    --libdir=/usr/lib \
    --mandir=%{_mandir} \
    --sysconfdir=%{_sysconfdir} \
    --datarootdir=/usr/share \
    --datadir=/usr/share \
    --libdir=/usr/lib \
    --exec_prefix=/usr/lib \
    --with-tmpfilesdir=%{_tmpfilesdir}

make OPTFLAGS="%{optflags}" %{?_smp_mflags}

%install
%make_install

mkdir -p %{buildroot}%{_localstatedir}/lib/drbd
mkdir -p %{buildroot}/usr/lib/udev/rules.d

%files
%defattr(-, root, root)
%config(noreplace) %{_sysconfdir}/drbd.conf
%config %{_sysconfdir}/bash_completion.d/drbdadm.sh
%config(noreplace) %{_sysconfdir}/drbd.d/global_common.conf
%{_tmpfilesdir}/drbd.conf
%doc %{_mandir}/man5/drbd.*
%doc %{_mandir}/man8/drbd*
%doc COPYING
%doc README
%doc ChangeLog
%doc scripts/drbd.conf.example
%dir %{_sysconfdir}/drbd.d
/sbin/drbdadm
/sbin/drbdsetup
/sbin/drbdmeta
/sbin/drbd-overview
%dir %attr(700,root,root) %{_sysconfdir}/xen
%dir %{_sysconfdir}/xen/scripts
%{_sysconfdir}/xen/scripts/block-drbd
%{_prefix}/lib/ocf/resource.d/linbit/drbd
%dir /usr/lib/udev
%dir /usr/lib/udev/rules.d
 /usr/lib/udev/rules.d/65-drbd.rules
%{_unitdir}/drbd.service
/usr/lib/systemd/system/drbd.service
%defattr(-, root, root)
%{_localstatedir}/lib/drbd
/usr/lib/drbd
/lib/drbd
/lib/drbd/drbdadm*
/lib/drbd/drbdsetup*
%dir %{_prefix}/lib/ocf
%dir %{_prefix}/lib/ocf/resource.d
%dir %{_prefix}/lib/ocf/resource.d/linbit

%changelog
