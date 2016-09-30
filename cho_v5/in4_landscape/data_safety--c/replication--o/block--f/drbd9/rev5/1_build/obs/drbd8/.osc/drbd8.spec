#
# spec file for package DRBD8
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

BuildRequires:  git
BuildRequires:  kernel-source
BuildRequires:  kernel-syms
BuildRequires:  module-init-tools
Requires:       drbd-utils >= 8.9.6
Obsoletes:      drbd-kmp < %{version}

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source1:      drbd_git_revision
Source2:       Module.supported

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
cp $RPM_SOURCE_DIR/drbd_git_revision drbd/.drbd_git_revision
mkdir obj


%build
rm -rf obj
mkdir obj
ln -s ../scripts obj/

for flavor in %{flavors_to_build}; do
    cp -r drbd obj/$flavor
    cp %_sourcedir/Module.supported obj/$flavor
    #make -C %{kernel_source $flavor} modules M=$PWD/obj/$flavor
    make -C obj/$flavor %{_smp_mflags} all KDIR=%{kernel_source $flavor}
done

%install
export INSTALL_MOD_PATH=%{buildroot}
export INSTALL_MOD_DIR=updates

for flavor in %{flavors_to_build} ; do
    make -C %{kernel_source $flavor} modules_install M=$PWD/obj/$flavor
    #From upstream file: drbd-kernel.spec
    #kernelrelease=$(cat %{kernel_source $flavor}/include/config/kernel.release || make -s -C %{kernel_source $flavor} kernelrelease)
    #mv obj/$flavor/.kernel.config.gz obj/k-config-$kernelrelease.gz
done

mkdir -p %{buildroot}/%{_sbindir}
%{__ln_s} -f %{_sbindir}/service %{buildroot}/%{_sbindir}/rc%{name}
rm -f drbd.conf

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%doc COPYING
%doc ChangeLog
%{_sbindir}/rc%{name}

%changelog

