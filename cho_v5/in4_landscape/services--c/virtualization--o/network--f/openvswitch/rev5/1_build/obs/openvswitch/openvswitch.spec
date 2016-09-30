#
# spec file for package openvswitch
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

# needssslcertforbuild

# IpSec build disabled temporarily (need to upgrade ipsec-tools):
%bcond_with ipsec
# Disable GUI building by default (heavy Qt4 dependencies):
%bcond_with gui

Summary:        An open source, production quality, multilayer virtual switch
License:        Apache-2.0
Group:          Productivity/Networking/System
Url:            http://openswitch.org/

Source1:        preamble
Source2:        openvswitch-switch.init
Source3:        openvswitch-switch.template
Source4:        openvswitch-switch.logrotate
Source5:        openvswitch-vtep.init
Source6:        openvswitch-ipsec.init
Source7:        openvswitch.service
Source10:       Module.supported
Source11:       Module.supported.updates
Source99:       README.packager

Patch2:         no_windows_compile.patch
Patch3:         make_travis.patch

BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  clang
BuildRequires:  fdupes
BuildRequires:  gcc
BuildRequires:  glibc-devel
BuildRequires:  graphviz
BuildRequires:  libopenssl-devel
BuildRequires:  libtool
BuildRequires:  make
BuildRequires:  openssl
BuildRequires:  perl
BuildRequires:  pkg-config
BuildRequires:  python-devel
BuildRequires:  python-xml
%ifnarch aarch64
BuildRequires:  valgrind-devel
%endif
Requires:       logrotate
Requires:       openssl
Requires:       python
Provides:       openvswitch-common = %{version}
Obsoletes:      openvswitch-common < %{version}
Provides:       openvswitch-testcontroller = %{version}
Obsoletes:      openvswitch-testcontroller < %{version}
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
%py_requires

%description
Open vSwitch is a production quality, multilayer virtual switch licensed under
the open source Apache 2.0 license. It is designed to enable massive network automation
through programmatic extension, while still supporting standard management interfaces
and protocols (e.g. NetFlow, sFlow, RSPAN, ERSPAN, CLI, LACP, 802.1ag). In addition,
it is designed to support distribution across multiple physical servers similar to
VMware’s vNetwork distributed vswitch or Cisco’s Nexus 1000V.

%if %{with kmp}

%package kmp
Summary:        Open vSwitch kernel modules
License:        GPL-2.0+
Group:          System/Kernel
BuildRequires:  %kernel_module_package_buildreqs
%if %{with kernel_kmp}
BuildRequires:  kernel-source
%endif
%suse_kernel_module_package -p %_sourcedir/preamble ec2 xenpae vmi um

%description -n %{name}-kmp
Kernel modules supporting the openvswitch datapath.
%endif

%package devel
Summary:        Open vSwitch Devel Libraries
License:        Apache-2.0
Group:          Productivity/Networking/System
Requires:       %{name} = %{version}

%description devel 
Devel files for Open vSwitch.

%if %{with ipsec}

%package ipsec
Summary:        Open vSwitch GRE-over-IPsec support
License:        Apache-2.0
Group:          Productivity/Networking/System
Requires:       %{name} = %{version}
Requires:       %{name}-switch = %{version}
Requires:       ipsec-tools >= 0.8
Requires:       python
Requires:       python-argparse
Requires:       python-openvswitch = %{version}
Requires:       racoon >= 0.8

%description ipsec
The ovs-monitor-ipsec script provides support for encrypting GRE
tunnels with IPsec.

Open vSwitch is a full-featured software-based Ethernet switch.
%endif

%package switch
Summary:        Open vSwitch switch implementations
License:        Apache-2.0
Group:          Productivity/Networking/System
Requires(pre):  %fillup_prereq
Requires(pre):  %insserv_prereq
Requires:       modutils
Requires:       openvswitch = %{version}
Requires:       procps
Requires:       python
# ovs-ctl / ovs-pki use /usr/bin/uuidgen:
Requires:       util-linux
Suggests:       openvswitch-kmp
Suggests:       logrotate
%if 0%{?suse_version} > 1230
%{?systemd_requires}
%endif

%description switch
openvswitch-switch provides the userspace components and utilities for
the Open vSwitch kernel-based switch.

Open vSwitch is a full-featured software-based Ethernet switch.

%package pki
Summary:        Open vSwitch public key infrastructure dependency package
License:        Apache-2.0
Group:          Productivity/Networking/System
Requires:       openvswitch = %{version}

%description pki
openvswitch-pki provides PKI (public key infrastructure) support for
Open vSwitch switches and controllers, reducing the risk of
man-in-the-middle attacks on the Open vSwitch network infrastructure.

Open vSwitch is a full-featured software-based Ethernet switch.

%package vtep
Summary:        Open vSwitch VTEP emulator
License:        Apache-2.0
Group:          Productivity/Networking/System
Requires:       openvswitch = %{version}
# Since openvswitch/scripts/ovs-vtep requires various ovs python modules.
Requires:       python-openvswitch = %{version}

%description vtep
A VTEP emulator that uses Open vSwitch for forwarding.
Open vSwitch is a full-featured software-based Ethernet switch.

%package ovn
Summary: Open vSwitch - Open Virtual Network support
License: ASL 2.0
Group:          Productivity/Networking/System
Requires: openvswitch

%description ovn
OVN, the Open Virtual Network, is a system to support virtual network
abstraction.  OVN complements the existing capabilities of OVS to add
native support for virtual network abstractions, such as virtual L2 and L3
overlays and security groups.

%package -n python-openvswitch
Summary:        Python bindings for Open vSwitch
License:        Python-2.0
Group:          Productivity/Networking/System
Requires:       python

%description -n python-openvswitch
This package contains the full Python bindings for Open vSwitch database.

%package -n python-openvswitch-test
Summary:        Python bindings for Open vSwitch
License:        Python-2.0
Group:          Productivity/Networking/System
Requires:       python

%description -n python-openvswitch-test
This package contains the full Python bindings for Open vSwitch database.

%if %{with gui}

%package ovsdbmonitor
Summary:        Open vSwitch graphical monitoring tool
License:        Apache-2.0
Group:          Productivity/Networking/System
BuildRequires:  python-pyside
BuildRequires:  python-qt4-devel
BuildRequires:  python-twisted
BuildRequires:  python-zopeinterface
Requires:       python-openvswitch
Requires:       python-pyasn1
Requires:       python-pyside
Requires:       python-qt4
Requires:       python-twisted
Requires:       python-zopeinterface

%description ovsdbmonitor
This package is a GUI tool for monitoring and troubleshooting local
or remote Open vSwitch installations.  It presents GUI tables that
graphically represent an Open vSwitch kernel flow table (similar to
"ovs-dpctl dump-flows") and Open vSwitch database contents (similar
to "ovs-vsctl list <table>").

Open vSwitch is a full-featured software-based Ethernet switch.
%endif

%package test
Summary:        Open vSwitch test package
License:        Apache-2.0
Group:          Productivity/Networking/System
Requires:       python
Requires:       python-argparse
Requires:       python-openvswitch-test = %{version}
Requires:       python-twisted

%description test
This package contains utilities that are useful to diagnose
performance and connectivity issues in Open vSwitch setup.

Open vSwitch is a full-featured software-based Ethernet switch.

%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%patch2 -p0
%patch3 -p0

set -- *
mkdir source
mv "$@" source/
mkdir obj
rm -rf source/windows

%build
libtoolize
autoreconf --install ./source
pushd source
# only call boot.sh for distros with autoconf >= 2.64
%if 0%{?suse_version} > 1110
    bash -x boot.sh
%endif
popd
%if %{with kmp}
%if %{with kernel_kmp}
for flavor in %flavors_to_build; do
    mkdir -p $flavor
    cp -a %{SOURCE10} $flavor/
    krel=$(make -s -C /usr/src/linux-obj/%_target_cpu/$flavor kernelrelease)
    kernel_source_dir=$(readlink /lib/modules/$krel/source)
    cp -a $kernel_source_dir/net/openvswitch/* $flavor/
    make %{?_smp_mflags} -C %{kernel_source $flavor} modules M=$PWD/$flavor
done
%else
export EXTRA_CFLAGS='-DVERSION=\"%{version}\"'
for flavor in %flavors_to_build; do
    rm -rf obj/$flavor
    cp -r source obj/$flavor
    cp -a %{SOURCE11} obj/$flavor/datapath/linux/Module.supported
    pushd obj/$flavor
    %configure \
    --enable-shared \
	--with-logdir=/var/log/openvswitch \
	--with-linux=/usr/src/linux-obj/%_target_cpu/$flavor \
	--with-linux-source=/usr/src/linux
    cd datapath/linux
    make %{?_smp_mflags}
    popd
done
%endif
%endif
ls source
pushd source
%configure \
        --disable-static \
        --enable-shared \
	--with-logdir=/var/log/openvswitch
make %{?_smp_mflags}
popd

%install
%if %{with kmp}
export NO_BRP_STALE_LINK_ERROR=yes
export INSTALL_MOD_PATH=%{buildroot}
export INSTALL_MOD_DIR=updates
export BRP_PESIGN_FILES="*.ko /lib/firmware"
for flavor in %flavors_to_build; do
%if %{with kernel_kmp}
    make -C %{kernel_source $flavor} modules_install M=$PWD/$flavor
%else
    pushd obj/$flavor/datapath/linux
    make -C /usr/src/linux-obj/%_target_cpu/$flavor modules_install M=$PWD
    popd
%endif
done
%endif
pushd source

%makeinstall
install -d -m 755 %{buildroot}/%{_sysconfdir}/init.d
install -d -m 755 %{buildroot}%{_localstatedir}/adm/fillup-templates

install -m 644 %{SOURCE3}  \
         %{buildroot}%{_localstatedir}/adm/fillup-templates/sysconfig.%{name}-switch
install -m 755 %{SOURCE2} \
         %{buildroot}/%{_sysconfdir}/init.d/%{name}-switch
install -m 755 %{SOURCE5} \
         %{buildroot}/%{_sysconfdir}/init.d/%{name}-vtep

%if 0%{?suse_version} > 1230
ln -sf %_sbindir/service %{buildroot}%{_sbindir}/rc%{name}-switch
ln -sf %_sbindir/service %{buildroot}%{_sbindir}/rc%{name}-vtep
install -D -m 644 %{SOURCE7} \
        %{buildroot}%{_unitdir}/openvswitch.service
%else
ln -sf %{_sysconfdir}/init.d/%{name}-switch %{buildroot}%{_sbindir}/rc%{name}-switch
ln -sf %{_sysconfdir}/init.d/%{name}-vtep %{buildroot}%{_sbindir}/rc%{name}-vtep
%endif

install -d -m 755 %{buildroot}/%{_sysconfdir}/sysconfig
install -d -m 755 %{buildroot}/%{_sysconfdir}/logrotate.d
install -d -m 755 %{buildroot}/var/log/openvswitch

install -m 644 %{SOURCE4} \
         %{buildroot}/%{_sysconfdir}/logrotate.d/%{name}-switch
install -d -m 755 %{buildroot}/%{_sysconfdir}/profile.d

install -d -m 755 %{buildroot}/%{_datadir}/%{name}/scripts
install -m 644 vswitchd/vswitch.ovsschema \
         %{buildroot}/%{_datadir}/%{name}/vswitch.ovsschema

%if %{with ipsec}
install -m 755 debian/ovs-monitor-ipsec \
	%{buildroot}/%{_datadir}/%{name}/ovs-monitor-ipsec
install -m 755 %{SOURCE6} \
         %{buildroot}/%{_sysconfdir}/init.d/%{name}-ipsec
         ln -s %{_sysconfdir}/init.d/%{name}-ipsec %{buildroot}%{_sbindir}/rc%{name}-ipsec
%endif

popd

mkdir -p %{buildroot}%{py_sitedir}
mv %{buildroot}%{_datadir}/%{name}/python/* %{buildroot}%{py_sitedir}
rmdir %{buildroot}%{_datadir}/%{name}/python

%fdupes %{buildroot}%{py_sitedir}

%pre switch
%if 0%{?suse_version} > 1230
%service_add_pre openvswitch.service
%endif

%post 
/sbin/ldconfig

%postun
/sbin/ldconfig

%post switch
/sbin/ldconfig
%{fillup_only -n openvswitch-switch}
%if 0%{?suse_version} > 1230
%service_add_post openvswitch.service
%endif

%preun switch
/sbin/ldconfig
%stop_on_removal openvswitch-switch
%if 0%{?suse_version} > 1230
%service_del_preun openvswitch.service
%endif

%postun switch
%restart_on_update openvswitch-switch
%if 0%{?suse_version} > 1230
%service_del_postun openvswitch.service
%endif
%insserv_cleanup

%post vtep
/sbin/ldconfig

%preun vtep
/sbin/ldconfig
%stop_on_removal openvswitch-vtep

%postun vtep
/sbin/ldconfig
%restart_on_update openvswitch-vtep

%files
%defattr(-,root,root)
%dir %{_datadir}/openvswitch
%doc source/AUTHORS source/DESIGN.md source/INSTALL.* source/NOTICE
%doc source/REPORTING-BUGS.md source/PORTING.md
%doc source/CodingStyle.md source/README.md
%doc source/WHY-OVS.md source/COPYING
%{_bindir}/ovs-appctl
%{_sysconfdir}/bash_completion.d/ovs-appctl-bashcomp.bash
%{_bindir}/ovs-benchmark
%{_bindir}/ovs-ofctl
%{_bindir}/ovs-docker
%{_bindir}/ovs-testcontroller
%{_bindir}/ovsdb-client
%{_bindir}/ovs-parse-backtrace
%{_bindir}/ovs-dpctl-top
%{_sbindir}/ovs-bugtool
%{_sbindir}/ovs-vlan-bug-workaround
%dir %{_datadir}/openvswitch/scripts
%{_datadir}/openvswitch/bugtool-plugins
%{_datadir}/openvswitch/scripts/ovs-bugtool-cfm-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-conntrack-dump
%{_datadir}/openvswitch/scripts/ovs-bugtool-lacp-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-tc-class-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-ovsdb-dump
%{_datadir}/openvswitch/scripts/ovs-bugtool-bond-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-coverage-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-daemons-ver
%{_datadir}/openvswitch/scripts/ovs-bugtool-vsctl-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-memory-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-ovs-ofctl-dump-flows
%{_datadir}/openvswitch/scripts/ovs-bugtool-ovs-appctl-dpif
%{_datadir}/openvswitch/scripts/ovs-bugtool-ovs-ofctl-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-bfd-show
%{_datadir}/openvswitch/scripts/ovs-bugtool-list-dbs
%{_datadir}/openvswitch/scripts/ovs-bugtool-fdb-show
%{_libdir}/libofproto.so.*
%{_libdir}/libopenvswitch.so.*
%{_libdir}/libovsdb.so.*
%{_libdir}/libsflow.so.*
%{_mandir}/man1/ovs-benchmark.1.gz
%{_mandir}/man1/ovsdb-client.1.gz
%{_mandir}/man8/ovs-appctl.8.gz
%{_mandir}/man8/ovs-bugtool.8.gz
%{_mandir}/man8/ovs-ofctl.8.gz
%{_mandir}/man8/ovs-testcontroller.8.gz
%{_mandir}/man8/ovs-vlan-bug-workaround.8.gz
%{_mandir}/man8/ovs-parse-backtrace.8.gz
%{_mandir}/man8/ovs-dpctl-top.8.gz

%files pki
%defattr(-,root,root)
%{_mandir}/man8/ovs-pki.8.gz
%{_bindir}/ovs-pki

%files vtep
%defattr(-,root,root)
%{_bindir}/vtep-ctl
%{_sysconfdir}/init.d/openvswitch-vtep
%{_sbindir}/rc%{name}-vtep
%{_libdir}/libvtep.so.*
%{_mandir}/man5/vtep.5.gz
%{_mandir}/man8/vtep-ctl.8.gz
%{_datadir}/openvswitch/scripts/ovs-vtep
%{_datadir}/openvswitch/vtep.ovsschema

%files ovn
%{_bindir}/ovn-controller
%{_bindir}/ovn-controller-vtep
%{_bindir}/ovn-docker-overlay-driver
%{_bindir}/ovn-docker-underlay-driver
%{_bindir}/ovn-nbctl
%{_bindir}/ovn-northd
%{_bindir}/ovn-sbctl
%{_datadir}/openvswitch/scripts/ovn-ctl
%{_mandir}/man5/ovn-nb.5*
%{_mandir}/man5/ovn-sb.5*
%{_mandir}/man7/ovn-architecture.7*
%{_mandir}/man8/ovn-controller.8*
%{_mandir}/man8/ovn-controller-vtep.8*
%{_mandir}/man8/ovn-ctl.8*
%{_mandir}/man8/ovn-nbctl.8*
%{_mandir}/man8/ovn-northd.8*
%{_mandir}/man8/ovn-sbctl.8*
%config %{_datadir}/openvswitch/ovn-nb.ovsschema
%config %{_datadir}/openvswitch/ovn-sb.ovsschema

%files -n python-openvswitch
%defattr(-,root,root)
%{py_sitedir}/ovs/

%files -n python-openvswitch-test
%defattr(-,root,root)
%{py_sitedir}/ovstest/

%if %{with ipsec}

%files ipsec
%defattr(-,root,root)
%{_datadir}/openvswitch/ovs-monitor-ipsec
%{_sysconfdir}/init.d/openvswitch-ipsec
%{_sbindir}/rc%{name}-ipsec
%endif

%files switch
%defattr(-,root,root)
%{_bindir}/ovs-dpctl
%{_bindir}/ovs-tcpundump
%{_bindir}/ovs-pcap
%{_bindir}/ovs-vsctl
%{_sysconfdir}/bash_completion.d/ovs-vsctl-bashcomp.bash
%{_bindir}/ovsdb-tool
%{_sbindir}/ovs-vswitchd
%{_sbindir}/ovsdb-server
%{_datadir}/openvswitch/scripts/ovs-check-dead-ifs
%{_datadir}/openvswitch/scripts/ovs-ctl
%{_datadir}/openvswitch/scripts/ovs-lib
%{_datadir}/openvswitch/scripts/ovs-save
%{_datadir}/openvswitch/vswitch.ovsschema
%{_localstatedir}/adm/fillup-templates/sysconfig.openvswitch-switch
%{_sysconfdir}/init.d/openvswitch-switch
%{_sbindir}/rc%{name}-switch
%config(noreplace) %{_sysconfdir}/logrotate.d/openvswitch-switch
%{_mandir}/man8/ovs-dpctl.8.gz
%{_mandir}/man1/ovs-tcpundump.1.gz
%{_mandir}/man1/ovs-pcap.1.gz
%{_mandir}/man8/ovs-vsctl.8.gz
%{_mandir}/man1/ovsdb-tool.1.gz
%{_mandir}/man8/ovs-vswitchd.8.gz
%{_mandir}/man1/ovsdb-server.1.gz
%{_mandir}/man5/ovs-vswitchd.conf.db.5.gz
%{_mandir}/man8/ovs-ctl.8.gz
%if 0%{?suse_version} > 1230
%{_unitdir}/openvswitch.service
%endif
%dir /var/log/openvswitch

%files test
%defattr(-,root,root)
%{_bindir}/ovs-test
%{_bindir}/ovs-l3ping
%{_bindir}/ovs-vlan-test
%{_mandir}/man8/ovs-test.8.gz
%{_mandir}/man8/ovs-l3ping.8.gz
%{_mandir}/man8/ovs-vlan-test.8.gz

%files devel
%defattr(-,root,root)
%{_libdir}/libofproto.so
%{_libdir}/libofproto.la
%{_libdir}/libopenvswitch.so
%{_libdir}/libopenvswitch.la
%{_libdir}/libovsdb.so
%{_libdir}/libovsdb.la
%{_libdir}/libsflow.so
%{_libdir}/libsflow.la
%{_libdir}/libvtep.so
%{_libdir}/libvtep.la
%{_libdir}/libovn.la
%{_libdir}/libovn.so
%{_libdir}/libovn.so.1
%{_libdir}/libovn.so.1.0.0
%{_libdir}/pkgconfig/*
%{_includedir}/openflow
%{_includedir}/openflow/*
%{_includedir}/openvswitch
%{_includedir}/openvswitch/*

%if %{with gui}

%files ovsdbmonitor
%defattr(-,root,root)
%{_bindir}/ovsdbmonitor
%dir %{_datadir}/ovsdbmonitor
%{_datadir}/applications/ovsdbmonitor.desktop
%{_datadir}/ovsdbmonitor/*
%{_mandir}/man1/ovsdbmonitor.1.gz
%endif

%changelog
