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


Summary:        DRBD driver for Linux
License:        GPL-2.0
Group:          System/Kernel
Url:            http://drbd.linbit.com/

BuildRequires:  kernel-source
BuildRequires:  kernel-syms
BuildRequires:  module-init-tools
Requires:       drbd-utils >= 8.9.8

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source1:      drbd_git_revision

%kernel_module_package

%description
Drbd is a distributed replicated block device. It mirrors a block
device over the network to another machine. Think of it as networked
raid 1. It is a building block for setting up clusters.

%package KMP
Summary:        Kernel driver for DRBD
Group:          Productivity/Clustering/HA

%description KMP
This module is the kernel-dependent driver for DRBD.  This is split out so
that multiple kernel driver versions can be installed, one for each
installed kernel.

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

mkdir source
cp -a drbd/. source/. || :
cp $RPM_SOURCE_DIR/drbd_git_revision source/.drbd_git_revision
# cp source/Makefile-2.6 source/Makefile
# WIP cp -a %_sourcedir/Module.supported source/
mkdir obj


%build
export CONFIG_BLK_DEV_DRBD=m
export EXTRA_CFLAGS='-DVERSION=\"%{version}\"'

for flavor in %flavors_to_build; do
	rm -rf $flavor
	cp -r source $flavor
	export DRBDSRC="$PWD/obj/$flavor"
	make -C %{kernel_source $flavor} modules M=$PWD/$flavor
done


%install
export INSTALL_MOD_PATH=%{buildroot}
export INSTALL_MOD_DIR=updates
for flavor in %{flavors_to_build}; do
    make -C %{kernel_source $flavor} modules_install \
	 M=$PWD/$flavor
done

mkdir -p %{buildroot}/%{_sbindir}
%{__ln_s} -f %{_sbindir}/service %{buildroot}/%{_sbindir}/rc%{name}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%doc COPYING
%doc ChangeLog
%{_sbindir}/rc%{name}

%changelog
