#
# spec file for package xen
#
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
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


%define with_kmp 1
%define with_kmp 1
%define with_kmp 1
#
# spec file for package xen
#
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

# needssslcertforbuild

Name:           xen
ExclusiveArch:  %ix86 x86_64 %arm aarch64
%define changeset 31594
%define xen_build_dir xen-4.6.1-testing
#
%define with_kmp 0
%define with_debug 0
%define with_stubdom 0
%define with_gdbsx 0
%define with_dom0_support 0
%define with_qemu_traditional 0
%define with_oxenstored 0
#
%ifarch x86_64
%define with_kmp 0
%define with_debug 1
%define with_stubdom 1
%define with_gdbsx 1
%define with_dom0_support 1
%define with_qemu_traditional 1
%endif
#
%ifarch %arm aarch64
%define with_dom0_support 1
%endif
#
%define max_cpus 4
%ifarch x86_64
%if %suse_version >= 1315
%define max_cpus 1024
%else
%define max_cpus 512
%endif
%endif
#
%define xen_install_suffix %{nil}
%ifarch x86_64
%define xen_install_suffix .gz
%endif
# EFI requires gcc 4.6 or newer
# gcc46 is available in 12.1 or sles11sp2
# gcc47 is available in sles11sp3
# gcc48 is available in sles11sp4
# 12.2+ have gcc 4.7 as default compiler
%define with_gcc47 0
%define with_gcc48 0
%if %suse_version == 1110
%define with_gcc48 1
%endif
%define _fwdefdir /etc/sysconfig/SuSEfirewall2.d/services
%define with_systemd 0
%if %suse_version > 1220
%define with_systemd 1
%define include_systemd_preset 0
%if %suse_version <= 1320
%define include_systemd_preset 1
%endif
%systemd_requires
BuildRequires:  systemd-devel
%define with_systemd_modules_load %{_prefix}/lib/modules-load.d
%else
PreReq:         %insserv_prereq
%endif
PreReq:         %fillup_prereq
%ifarch %arm aarch64
BuildRequires:  libfdt1-devel
%endif
%ifarch %ix86 x86_64
BuildRequires:  dev86
%endif
#!BuildIgnore:  gcc-PIE
BuildRequires:  bison
BuildRequires:  fdupes
BuildRequires:  figlet
BuildRequires:  flex
BuildRequires:  glib2-devel
BuildRequires:  libaio-devel
BuildRequires:  libbz2-devel
BuildRequires:  libpixman-1-0-devel
BuildRequires:  libuuid-devel
BuildRequires:  libxml2-devel
BuildRequires:  libyajl-devel
%ifarch x86_64
%if 0%{?suse_version} > 1230
BuildRequires:  libspice-server-devel
BuildRequires:  spice-protocol-devel
BuildRequires:  usbredir-devel
%endif
%endif
%if %{?with_qemu_traditional}0
BuildRequires:  SDL-devel
BuildRequires:  pciutils-devel
%endif
%if %{?with_stubdom}0
%if 0%{?suse_version} < 1230
BuildRequires:  texinfo
%else
BuildRequires:  makeinfo
%endif
%endif
BuildRequires:  ncurses-devel
%if %{?with_oxenstored}0
BuildRequires:  ocaml
BuildRequires:  ocaml-compiler-libs
BuildRequires:  ocaml-findlib
BuildRequires:  ocaml-ocamldoc
BuildRequires:  ocaml-runtime
%endif
BuildRequires:  openssl-devel
BuildRequires:  python-devel
%if %{?with_systemd}0
BuildRequires:  systemd
%endif
%if %suse_version >= 1120
BuildRequires:  xz-devel
%endif
%if %suse_version <= 1110
BuildRequires:  pmtools
%else
%ifarch %ix86 x86_64
BuildRequires:  acpica
%endif
%endif
%ifarch x86_64
%if %{?with_gcc47}0
BuildRequires:  gcc47
%endif
%if %{?with_gcc48}0
BuildRequires:  gcc48
%endif
BuildRequires:  glibc-32bit
BuildRequires:  glibc-devel-32bit
%endif
%if %{?with_kmp}0
BuildRequires:  kernel-source
BuildRequires:  kernel-syms
BuildRequires:  module-init-tools
%if %suse_version >= 1230
BuildRequires:  lndir
BuildRequires:  pesign-obs-integration
%else
BuildRequires:  xorg-x11-util-devel
%endif
%endif

Version:        4.6.1_01
Release:        0
Summary:        Xen Virtualization: Hypervisor (aka VMM aka Microkernel)
License:        GPL-2.0
Group:          System/Kernel
Source0:        xen-4.6.1-testing-src.tar.bz2
Source1:        stubdom.tar.bz2
Source2:        qemu-xen-traditional-dir-remote.tar.bz2
Source4:        seabios-dir-remote.tar.bz2
Source5:        ipxe.tar.bz2
Source6:        mini-os.tar.bz2
Source9:        xen.changes
Source10:       README.SUSE
Source11:       boot.xen
Source12:       boot.local.xenU
Source15:       logrotate.conf
Source21:       block-npiv-common.sh
Source22:       block-npiv
Source23:       block-npiv-vport
Source26:       init.xen_loop
%if %{?with_kmp}0
Source28:       kmp_filelist
%endif
Source29:       block-dmmd
# Xen API remote authentication sources
Source30:       etc_pam.d_xen-api
Source31:       xenapiusers
# Init script and sysconf file for pciback
Source34:       init.pciback
Source35:       sysconfig.pciback
Source36:       xnloader.py
Source37:       xen2libvirt.py
# Systemd service files
Source41:       xencommons.service
Source42:       xen-dom0-modules.service
Source57:       xen-utils-0.1.tar.bz2
# For xen-libs
Source99:       baselibs.conf
# Upstream patches
Patch1:         55f7f9d2-libxl-slightly-refine-pci-assignable-add-remove-handling.patch
Patch2:         5628fc67-libxl-No-emulated-disk-driver-for-xvdX-disk.patch
Patch3:         5644b756-x86-HVM-don-t-inject-DB-with-error-code.patch
Patch4:         5649bcbe-libxl-relax-readonly-check-introduced-by-XSA-142-fix.patch
Patch154:       xsa154.patch
Patch15501:     xsa155-xen-0001-xen-Add-RING_COPY_REQUEST.patch
Patch15502:     xsa155-xen-0002-blktap2-Use-RING_COPY_REQUEST.patch
Patch15503:     xsa155-xen-0003-libvchan-Read-prod-cons-only-once.patch
Patch164:       xsa164.patch
Patch170:       xsa170.patch
# Upstream qemu-traditional patches
Patch250:       VNC-Support-for-ExtendedKeyEvent-client-message.patch
Patch251:       0001-net-move-the-tap-buffer-into-TAPState.patch
Patch252:       0002-net-increase-tap-buffer-size.patch
Patch253:       0003-e1000-fix-access-4-bytes-beyond-buffer-end.patch
Patch254:       0004-e1000-secrc-support.patch
Patch255:       0005-e1000-multi-buffer-packet-support.patch
Patch256:       0006-e1000-clear-EOP-for-multi-buffer-descriptors.patch
Patch257:       0007-e1000-verify-we-have-buffers-upfront.patch
Patch258:       0008-e1000-check-buffer-availability.patch
Patch259:       CVE-2013-4533-qemut-pxa2xx-buffer-overrun-on-incoming-migration.patch
Patch260:       CVE-2013-4534-qemut-openpic-buffer-overrun-on-incoming-migration.patch
Patch261:       CVE-2013-4537-qemut-ssi-sd-fix-buffer-overrun-on-invalid-state-load.patch
Patch262:       CVE-2013-4538-qemut-ssd0323-fix-buffer-overun-on-invalid-state.patch
Patch263:       CVE-2013-4539-qemut-tsc210x-fix-buffer-overrun-on-invalid-state-load.patch
Patch264:       CVE-2014-0222-qemut-qcow1-validate-l2-table-size.patch
Patch265:       CVE-2014-3640-qemut-slirp-NULL-pointer-deref-in-sosendto.patch
Patch266:       CVE-2015-4037-qemut-smb-config-dir-name.patch
Patch267:       CVE-2015-5154-qemut-fix-START-STOP-UNIT-command-completion.patch
Patch268:       CVE-2015-5278-qemut-Infinite-loop-in-ne2000_receive-function.patch
Patch269:       CVE-2015-6815-qemut-e1000-fix-infinite-loop.patch
Patch270:       CVE-2015-7512-qemut-net-pcnet-buffer-overflow-in-non-loopback-mode.patch
Patch271:       CVE-2015-8345-qemut-eepro100-infinite-loop-fix.patch
Patch272:       CVE-2015-8504-qemut-vnc-avoid-floating-point-exception.patch
Patch273:       CVE-2016-1714-qemut-fw_cfg-add-check-to-validate-current-entry-value.patch
Patch274:       CVE-2016-1981-qemut-e1000-eliminate-infinite-loops-on-out-of-bounds-transfer.patch
Patch275:       CVE-2016-2391-qemut-usb-null-pointer-dereference-in-ohci-module.patch
Patch276:       CVE-2016-2841-qemut-ne2000-infinite-loop-in-ne2000_receive.patch
# qemu-traditional patches that are not upstream
Patch350:       blktap.patch
Patch351:       cdrom-removable.patch
Patch353:       xen-qemu-iscsi-fix.patch
Patch354:       qemu-security-etch1.patch
Patch355:       xen-disable-qemu-monitor.patch
Patch356:       xen-hvm-default-bridge.patch
Patch357:       qemu-ifup-set-mtu.patch
Patch358:       ioemu-vnc-resize.patch
Patch359:       capslock_enable.patch
Patch360:       altgr_2.patch
Patch361:       log-guest-console.patch
Patch370:       bdrv_open2_fix_flags.patch
Patch371:       bdrv_open2_flags_2.patch
Patch372:       ioemu-7615-qcow2-fix-alloc_cluster_link_l2.patch
Patch373:       qemu-dm-segfault.patch
Patch374:       bdrv_default_rwflag.patch
Patch375:       kernel-boot-hvm.patch
Patch376:       ioemu-watchdog-support.patch
Patch377:       ioemu-watchdog-linkage.patch
Patch378:       ioemu-watchdog-ib700-timer.patch
Patch379:       ioemu-hvm-pv-support.patch
Patch380:       pvdrv_emulation_control.patch
Patch381:       ioemu-disable-scsi.patch
Patch382:       ioemu-disable-emulated-ide-if-pv.patch
Patch383:       xenpaging.qemu.flush-cache.patch
# Our platform specific patches
Patch400:       xen-destdir.patch
Patch401:       vif-bridge-no-iptables.patch
Patch402:       vif-bridge-tap-fix.patch
Patch403:       xl-conf-default-bridge.patch
# Needs to go upstream
Patch420:       suspend_evtchn_lock.patch
Patch421:       xenpaging.doc.patch
Patch422:       xen-c99-fix.patch
Patch423:       stubdom-have-iovec.patch
Patch424:       hotplug-Linux-block-performance-fix.patch
# Other bug fixes or features
Patch451:       xenconsole-no-multiple-connections.patch
Patch452:       hibernate.patch
Patch453:       stdvga-cache.patch
Patch454:       ipxe-enable-nics.patch
Patch455:       pygrub-netware-xnloader.patch
Patch456:       pygrub-boot-legacy-sles.patch
Patch457:       set-mtu-from-bridge-for-tap-interface.patch
Patch458:       aarch64-rename-PSR_MODE_ELxx-to-match-linux-headers.patch
Patch459:       xendomains-libvirtd-conflict.patch
Patch460:       CVE-2014-0222-blktap-qcow1-validate-l2-table-size.patch
Patch461:       libxl.pvscsi.patch
#Patch462:       xen.libxl.dmmd.patch
Patch463:       libxl.add-option-to-disable-disk-cache-flushes-in-qdisk.patch
Patch464:       blktap2-no-uninit.patch
# Hypervisor and PV driver Patches
Patch501:       x86-ioapic-ack-default.patch
Patch502:       x86-cpufreq-report.patch
Patch520:       xen_pvonhvm.xen_emul_unplug.patch
Patch521:       supported_module.patch
Patch522:       magic_ioport_compat.patch
Patch601:       xen.build-compare.doc_html.patch
Patch602:       xen.build-compare.seabios.patch
Patch603:       xen.build-compare.man.patch
Patch604:       ipxe-no-error-logical-not-parentheses.patch
Patch605:       ipxe-use-rpm-opt-flags.patch
Patch606:       gcc6-warnings-as-errors.patch
# Build patches
Patch99996:     xen.stubdom.newlib.patch
Patch99998:     tmp_build.patch
Url:            http://www.cl.cam.ac.uk/Research/SRG/netos/xen/
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
%define pyver %(python -c "import sys; print sys.version[:3]")
%if %{?with_kmp}0
%suse_kernel_module_package -n xen um pv xen -f kmp_filelist
%endif

%description
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

This package contains the Xen Hypervisor. (tm)

Modern computers are sufficiently powerful to use virtualization to
present the illusion of many smaller virtual machines (VMs), each
running a separate operating system instance. Successful partitioning
of a machine to support the concurrent execution of multiple operating
systems poses several challenges. Firstly, virtual machines must be
isolated from one another: It is not acceptable for the execution of
one to adversely affect the performance of another. This is
particularly true when virtual machines are owned by mutually
untrusting users. Secondly, it is necessary to support a variety of
different operating systems to accommodate the heterogeneity of popular
applications. Thirdly, the performance overhead introduced by
virtualization should be small.

Xen uses a technique called paravirtualization: The guest OS is
modified, mainly to enhance performance.

The Xen hypervisor (microkernel) does not provide device drivers for
your hardware (except for CPU and memory). This job is left to the
kernel that's running in domain 0. Thus the domain 0 kernel is
privileged; it has full hardware access. It's started immediately after
Xen starts up. Other domains have no access to the hardware; instead
they use virtual interfaces that are provided by Xen (with the help of
the domain 0 kernel).

In addition to this package you need to install the kernel-xen, xen-libs
and xen-tools packages to use Xen. Xen version 3 and newer also supports
running unmodified guests using full virtualization, if appropriate hardware
is present.

[Hypervisor is a trademark of IBM]



Authors:
--------
    Ian Pratt <ian.pratt@cl.cam.ac.uk>
    Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
    Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
    Mark Williamson <mark.williamson@cl.cam.ac.uk>
    Ewan Mellor <ewan@xensource.com>
    ...

%package libs
Summary:        Xen Virtualization: Libraries
Group:          System/Kernel

%description libs
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

This package contains the libraries used to interact with the Xen
virtual machine monitor.

In addition to this package you need to install kernel-xen, xen and
xen-tools to use Xen.


Authors:
--------
    Ian Pratt <ian.pratt@cl.cam.ac.uk>


%if %{?with_dom0_support}0

%package tools
Summary:        Xen Virtualization: Control tools for domain 0
Group:          System/Kernel
Requires:       bridge-utils
%ifarch x86_64
%if %suse_version >= 1315
Requires:       grub2-x86_64-xen
%endif
Requires:       qemu-x86
%endif
%ifarch %arm aarch64
Requires:       qemu-arm
%endif
Requires:       multipath-tools
Requires:       python
Requires:       python-curses
Requires:       python-lxml
Requires:       python-openssl
Requires:       python-pam
Requires:       python-xml
Requires:       xen-libs = %{version}
# subpackage existed in 10.3
Provides:       xen-tools-ioemu = %{version}
Obsoletes:      xen-tools-ioemu < %{version}
Conflicts:      libvirt < 1.0.5

%description tools
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

This package contains the control tools that allow you to start, stop,
migrate, and manage virtual machines.

In addition to this package you need to install kernel-xen, xen and
xen-libs to use Xen.


Authors:
--------
    Ian Pratt <ian.pratt@cl.cam.ac.uk>


%endif

%package tools-domU
Summary:        Xen Virtualization: Control tools for domain U
Group:          System/Kernel
Conflicts:      xen-tools

%description tools-domU
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

This package contains tools that allow unprivileged domains to query
the virtualized environment.



Authors:
--------
    Ian Pratt <ian.pratt@cl.cam.ac.uk>

%package devel
Summary:        Xen Virtualization: Headers and libraries for development
Group:          System/Kernel
Requires:       libuuid-devel
Requires:       xen-libs = %{version}

%description devel
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

This package contains the libraries and header files needed to create
tools to control virtual machines.



Authors:
--------
    Ian Pratt <ian.pratt@cl.cam.ac.uk>

%if %{?with_kmp}0

%package KMP
Summary:        Xen para-virtual device drivers for fully virtualized guests
Group:          System/Kernel
Conflicts:      xen
%if %suse_version >= 1230
Requires:       pesign-obs-integration
%endif

%description KMP
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

This package contains the Xen para-virtual device drivers for fully
virtualized guests.

%endif

%if %{?with_dom0_support}0

%package doc-html
Summary:        Xen Virtualization: HTML documentation
Group:          Documentation/HTML

%description doc-html
Xen is a virtual machine monitor for x86 that supports execution of
multiple guest operating systems with unprecedented levels of
performance and resource isolation.

xen-doc-html contains the online documentation in HTML format. Point
your browser at file:/usr/share/doc/packages/xen/html/



Authors:
--------
    Ian Pratt <ian.pratt@cl.cam.ac.uk>
%endif

%prep
%setup -q -n %xen_build_dir -a 1 -a 2 -a 4 -a 5 -a 6 -a 57
# Upstream patches
%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch154 -p1
%patch15501 -p1
%patch15502 -p1
%patch15503 -p1
%patch164 -p1
%patch170 -p1
# Upstream qemu patches
%patch250 -p1
%patch251 -p1
%patch252 -p1
%patch253 -p1
%patch254 -p1
%patch255 -p1
%patch256 -p1
%patch257 -p1
%patch258 -p1
%patch259 -p1
%patch260 -p1
%patch261 -p1
%patch262 -p1
%patch263 -p1
%patch264 -p1
%patch265 -p1
%patch266 -p1
%patch267 -p1
%patch268 -p1
%patch269 -p1
%patch270 -p1
%patch271 -p1
%patch272 -p1
%patch273 -p1
%patch274 -p1
%patch275 -p1
%patch276 -p1
# Qemu traditional
%patch350 -p1
%patch351 -p1
%patch353 -p1
%patch354 -p1
%patch355 -p1
%patch356 -p1
%patch357 -p1
%patch358 -p1
%patch359 -p1
%patch360 -p1
%patch361 -p1
%patch370 -p1
%patch371 -p1
%patch372 -p1
%patch373 -p1
%patch374 -p1
%patch375 -p1
%patch376 -p1
%patch377 -p1
%patch378 -p1
%patch379 -p1
%patch380 -p1
%patch381 -p1
%patch382 -p1
%patch383 -p1
# Our platform specific patches
%patch400 -p1
%patch401 -p1
%patch402 -p1
%patch403 -p1
# Needs to go upstream
%patch420 -p1
%patch421 -p1
%patch422 -p1
%patch423 -p1
%patch424 -p1
# Other bug fixes or features
%patch451 -p1
%patch452 -p1
%patch453 -p1
%patch454 -p1
%patch455 -p1
%patch456 -p1
%patch457 -p1
%patch458 -p1
%patch459 -p1
%patch460 -p1
%patch461 -p1
#%patch462 -p1
%patch463 -p1
%patch464 -p1
# Hypervisor and PV driver Patches
%patch501 -p1
%patch502 -p1
%patch520 -p1
%patch521 -p1
%patch522 -p1
%patch601 -p1
%patch602 -p1
%patch603 -p1
%patch604 -p1
%patch605 -p1
%patch606 -p1
# Build patches
%patch99996 -p1
%patch99998 -p1

%build
# we control the version info of this package
# to gain control of filename of xen.gz
XEN_VERSION=%{version}
XEN_VERSION=${XEN_VERSION%%%%.*}
XEN_SUBVERSION=%{version}
XEN_SUBVERSION=${XEN_SUBVERSION#*.}
XEN_SUBVERSION=${XEN_SUBVERSION%%%%.*}
XEN_EXTRAVERSION="%version-%release"
XEN_EXTRAVERSION="${XEN_EXTRAVERSION#*.}"
XEN_EXTRAVERSION="${XEN_EXTRAVERSION#*.}"
# remove trailing B_CNT to reduce build-compare noise
XEN_EXTRAVERSION="${XEN_EXTRAVERSION%%.*}"
XEN_FULLVERSION="$XEN_VERSION.$XEN_SUBVERSION.$XEN_EXTRAVERSION"
XEN_BUILD_DATE="`date -u -d '1970-01-01'`"
XEN_BUILD_TIME="`date -u -d '1970-01-01' +%%T`"
SMBIOS_DATE="`date -u -d '1970-01-01' +%%m/%%d/%%Y`"
RELDATE="`date -u -d '1970-01-01' '+%%d %%b %%Y'`"
SEABIOS_DATE="`date -u -d '1970-01-01' '+?-%%Y%%m%%d_%%H%%M%%S-buildhost'`"
if test -r %{S:9}
then
	XEN_BUILD_DATE="` date -u -d \"$(sed -n '/@/{s/ - .*$//p;q}' %{S:9})\" `"
	XEN_BUILD_TIME="` date -u -d \"$(sed -n '/@/{s/ - .*$//p;q}' %{S:9})\" +%%T`"
	SMBIOS_DATE="` date -u -d \"$(sed -n '/@/{s/ - .*$//p;q}' %{S:9})\" +%%m/%%d/%%Y`"
	RELDATE="` date -u -d \"$(sed -n '/@/{s/ - .*$//p;q}' %{S:9})\" '+%%d %%b %%Y'`"
	SEABIOS_DATE="` date -u -d \"$(sed -n '/@/{s/ - .*$//p;q}' %{S:9})\" '+?-%%Y%%m%%d_%%H%%M%%S-buildhost'`"
fi
cat > .our_xenversion <<_EOV_
export WGET=$(type -P false)
export FTP=$(type -P false)
export GIT=$(type -P false)
export EXTRA_CFLAGS_XEN_TOOLS="$RPM_OPT_FLAGS"
export EXTRA_CFLAGS_QEMU_TRADITIONAL="$RPM_OPT_FLAGS"
export SMBIOS_DATE="$SMBIOS_DATE"
export RELDATE="$RELDATE"
export SEABIOS_DATE="$SEABIOS_DATE"
XEN_VERSION=$XEN_VERSION
XEN_SUBVERSION=$XEN_SUBVERSION
XEN_EXTRAVERSION=$XEN_EXTRAVERSION
XEN_FULLVERSION=$XEN_FULLVERSION
_EOV_
source ./.our_xenversion
echo "%{changeset}" > xen/.scmversion
sed -i~ "
s/XEN_VERSION[[:blank:]]*=.*/XEN_VERSION = $XEN_VERSION/
s/XEN_SUBVERSION[[:blank:]]*=.*/XEN_SUBVERSION = $XEN_SUBVERSION/
s/XEN_EXTRAVERSION[[:blank:]]*?=.*/XEN_EXTRAVERSION = .$XEN_EXTRAVERSION/
s/XEN_FULLVERSION[[:blank:]]*=.*/XEN_FULLVERSION = $XEN_FULLVERSION/
s/XEN_BUILD_DATE[[:blank:]]*?=.*/XEN_BUILD_DATE = $XEN_BUILD_DATE/
s/XEN_BUILD_TIME[[:blank:]]*?=.*/XEN_BUILD_TIME = $XEN_BUILD_TIME/
s/XEN_BUILD_HOST[[:blank:]]*?=.*/XEN_BUILD_HOST = buildhost/
s/XEN_DOMAIN[[:blank:]]*?=.*/XEN_DOMAIN = suse.de/
" xen/Makefile
if diff -u xen/Makefile~ xen/Makefile
then
	: no changes?
fi
configure_flags=
%if %{?with_stubdom}0
configure_flags=--enable-stubdom
%else
configure_flags=--disable-stubdom
%endif
%if %{?with_qemu_traditional}0
configure_flags="${configure_flags} --enable-qemu-traditional"
%else
configure_flags="${configure_flags} --disable-qemu-traditional"
%endif
./configure \
        --disable-xen \
        --enable-tools \
        --enable-docs \
        --prefix=/usr \
        --exec_prefix=/usr \
        --bindir=%{_bindir} \
        --sbindir=%{_sbindir} \
        --libdir=%{_libdir} \
        --libexecdir=%{_libexecdir} \
        --datadir=%{_datadir} \
        --with-xen-dumpdir=%{_sharedstatedir}/xen/dump \
        --mandir=%{_mandir} \
        --includedir=%{_includedir} \
        --docdir=%{_defaultdocdir}/xen \
	--with-initddir=%{_initddir} \
%if %{?with_oxenstored}0
	--with-xenstored=oxenstored \
%endif
%if %{?with_systemd}0
	--enable-systemd \
	--with-systemd=%{_unitdir} \
	--with-systemd-modules-load=%{with_systemd_modules_load} \
%else
	--disable-systemd \
%endif
	--with-system-qemu=%{_bindir}/qemu-system-%{_arch} \
        ${configure_flags}
make -C tools/include/xen-foreign %{?_smp_mflags}
make %{?_smp_mflags}
%if %{?with_dom0_support}0
make -C tools/xen-utils-0.1 XEN_INTREE_BUILD=yes XEN_ROOT=$PWD
%endif
#
%if %{?with_kmp}0
# PV driver modules
export XL=/usr/src/linux
export XEN=/usr/src/linux/include/xen
mkdir -p obj
for flavor in %flavors_to_build; do
    rm -rf obj/$flavor
    cp -r unmodified_drivers/linux-2.6 obj/$flavor
    cd obj/$flavor
    ./mkbuildtree
    make -C /usr/src/linux-obj/%_target_cpu/$flavor modules \
	%{?_smp_mflags} \
        M=$PWD
    cd ../..
done
%endif

%install
source ./.our_xenversion
# tools
make \
	DESTDIR=$RPM_BUILD_ROOT \
	SYSCONFIG_DIR=/var/adm/fillup-templates \
	%{?_smp_mflags} \
	install
find $RPM_BUILD_ROOT -ls
for i in $RPM_BUILD_ROOT/var/adm/fillup-templates/*
do
	mv -v $i ${i%/*}/sysconfig.${i##*/}
done
# EFI
%if %{?with_dom0_support}0
export BRP_PESIGN_FILES="*.ko *.efi /lib/firmware"
make -C xen install \
%if %{?with_gcc47}0
	CC=gcc-4.7 \
%endif
%if %{?with_gcc48}0
	CC=gcc-4.8 \
%endif
	max_phys_cpus=%{max_cpus} debug=n crash_debug=n DEBUG_DIR=/boot DESTDIR=$RPM_BUILD_ROOT %{?_smp_mflags}
make -C xen clean
install_xen()
{
    local ext=""
    find $RPM_BUILD_ROOT/boot -ls
    if [ -n "$1" ]; then
        ext="-$1"
        mv $RPM_BUILD_ROOT/boot/xen-${XEN_FULLVERSION}%{xen_install_suffix} \
           $RPM_BUILD_ROOT/boot/xen${ext}-${XEN_FULLVERSION}%{xen_install_suffix}
    fi
    rm $RPM_BUILD_ROOT/boot/xen-$XEN_VERSION.$XEN_SUBVERSION%{xen_install_suffix}
    rm $RPM_BUILD_ROOT/boot/xen-$XEN_VERSION%{xen_install_suffix}
    rm $RPM_BUILD_ROOT/boot/xen%{xen_install_suffix}
    # Do not link to links; grub cannot follow.
    ln -s xen${ext}-${XEN_FULLVERSION}%{xen_install_suffix} $RPM_BUILD_ROOT/boot/xen${ext}-$XEN_VERSION.$XEN_SUBVERSION%{xen_install_suffix}
    ln -s xen${ext}-${XEN_FULLVERSION}%{xen_install_suffix} $RPM_BUILD_ROOT/boot/xen${ext}-$XEN_VERSION%{xen_install_suffix}
    ln -s xen${ext}-${XEN_FULLVERSION}%{xen_install_suffix} $RPM_BUILD_ROOT/boot/xen${ext}%{xen_install_suffix}
    ln -sf xen-syms${ext}-${XEN_FULLVERSION} $RPM_BUILD_ROOT/boot/xen-syms${ext}
    find $RPM_BUILD_ROOT/boot -ls
}
%if %{?with_debug}0
make -C xen install max_phys_cpus=%{max_cpus} debug=y crash_debug=y DEBUG_DIR=/boot DESTDIR=$RPM_BUILD_ROOT %{?_smp_mflags}
install_xen dbg
make -C xen clean
%endif
make -C xen install max_phys_cpus=%{max_cpus} debug=n crash_debug=n DEBUG_DIR=/boot DESTDIR=$RPM_BUILD_ROOT %{?_smp_mflags}
install_xen
make -C xen clean
echo > xen.files.txt
# EFI depends on gcc47
if test -d $RPM_BUILD_ROOT%{_libdir}/efi
then
	echo %{_libdir}/efi >> xen.files.txt
fi
%endif

# PV driver modules
%if %{?with_kmp}0
export INSTALL_MOD_PATH=$RPM_BUILD_ROOT
export INSTALL_MOD_DIR=updates
for flavor in %flavors_to_build; do
    make -C /usr/src/linux-obj/%_target_cpu/$flavor modules_install \
        M=$PWD/obj/$flavor
done
%endif

# On x86_64, qemu-xen was installed as /usr/lib/xen/bin/qemu-system-i386
# and advertised as the <emulator> in libvirt capabilities. Tool such as
# virt-install include <emulator> in domXML they produce, so we need to
# preserve the path. For x86_64, create a simple wrapper that invokes
# /usr/bin/qemu-system-x86_64
%ifarch x86_64
cat > $RPM_BUILD_ROOT/usr/lib/xen/bin/qemu-system-i386 << 'EOF'
#!/bin/sh

exec %{_bindir}/qemu-system-x86_64 "$@"
EOF
chmod 0755 $RPM_BUILD_ROOT/usr/lib/xen/bin/qemu-system-i386
%endif

# Stubdom
%if %{?with_dom0_support}0
# Docs
mkdir -p $RPM_BUILD_ROOT/%{_defaultdocdir}/xen/misc
for name in COPYING %SOURCE10 %SOURCE11 %SOURCE12; do
    install -m 644 $name $RPM_BUILD_ROOT/%{_defaultdocdir}/xen/
done
for name in vtpm.txt crashdb.txt \
    xenpaging.txt xl-disk-configuration.txt pci-device-reservations.txt \
    xl-network-configuration.markdown xl-numa-placement.markdown \
    xen-command-line.markdown xenstore-paths.markdown; do
    install -m 644 docs/misc/$name $RPM_BUILD_ROOT/%{_defaultdocdir}/xen/misc/
done

mkdir -p $RPM_BUILD_ROOT/etc/modprobe.d
install -m644 %SOURCE26 $RPM_BUILD_ROOT/etc/modprobe.d/xen_loop.conf

# xen-utils
make -C tools/xen-utils-0.1 install DESTDIR=$RPM_BUILD_ROOT XEN_INTREE_BUILD=yes XEN_ROOT=$PWD
install -m755 %SOURCE37 $RPM_BUILD_ROOT/usr/sbin/xen2libvirt

# Example config
mkdir -p $RPM_BUILD_ROOT/etc/xen/{vm,examples,scripts}
mv $RPM_BUILD_ROOT/etc/xen/xlexample* $RPM_BUILD_ROOT/etc/xen/examples
rm -f $RPM_BUILD_ROOT/etc/xen/examples/*nbd
install -m644 tools/xentrace/formats $RPM_BUILD_ROOT/etc/xen/examples/xentrace_formats.txt

# Scripts
rm -f $RPM_BUILD_ROOT/etc/xen/scripts/block-*nbd
install -m755 %SOURCE21 %SOURCE22 %SOURCE23 %SOURCE29 $RPM_BUILD_ROOT/etc/xen/scripts/

# Xen API remote authentication files
install -d $RPM_BUILD_ROOT/etc/pam.d
install -m644 %SOURCE30 $RPM_BUILD_ROOT/etc/pam.d/xen-api
install -m644 %SOURCE31 $RPM_BUILD_ROOT/etc/xen/

# Logrotate
install -m644 -D %SOURCE15 $RPM_BUILD_ROOT/etc/logrotate.d/xen

# Directories
mkdir -p $RPM_BUILD_ROOT/var/lib/xenstored
mkdir -p $RPM_BUILD_ROOT/var/lib/xen/images
mkdir -p $RPM_BUILD_ROOT/var/lib/xen/jobs
mkdir -p $RPM_BUILD_ROOT/var/lib/xen/save
mkdir -p $RPM_BUILD_ROOT/var/lib/xen/dump
mkdir -p $RPM_BUILD_ROOT/var/log/xen
mkdir -p $RPM_BUILD_ROOT/var/log/xen/console
ln -s /var/lib/xen/images $RPM_BUILD_ROOT/etc/xen/images

# Bootloader
install -m755 %SOURCE36 $RPM_BUILD_ROOT/%{_libdir}/python%{pyver}/site-packages

# Systemd
%if %{?with_systemd}0
%if %{?include_systemd_preset}0
mkdir -vp $RPM_BUILD_ROOT%_presetdir
cat > $RPM_BUILD_ROOT%_presetdir/00-%{name}.preset <<EOF
enable xencommons.service
EOF
%endif
cp -bavL %{S:41} $RPM_BUILD_ROOT%{_unitdir}
bn=`basename %{S:42}`
cp -bavL %{S:42} $RPM_BUILD_ROOT%{_unitdir}/${bn}
mods="`
for conf in $(ls $RPM_BUILD_ROOT%{with_systemd_modules_load}/*.conf)
do
	grep -v ^# $conf
	echo -n > $conf
done
`"
for mod in $mods
do
	echo "ExecStart=-/usr/bin/env modprobe $mod" >> $RPM_BUILD_ROOT%{_unitdir}/${bn}
done
rm -rfv $RPM_BUILD_ROOT%{_initddir}
%else
# Init scripts
mkdir -p $RPM_BUILD_ROOT%{_initddir}
install %SOURCE34 $RPM_BUILD_ROOT%{_initddir}/pciback
ln -s %{_initddir}/pciback $RPM_BUILD_ROOT/usr/sbin/rcpciback
ln -s %{_initddir}/xendomains $RPM_BUILD_ROOT/usr/sbin/rcxendomains
%endif
install %SOURCE35 $RPM_BUILD_ROOT/var/adm/fillup-templates/sysconfig.pciback

# Clean up unpackaged files
find $RPM_BUILD_ROOT \( \
	-name .deps -o \
	-name README.blktap -o \
	-name README.xenmon -o \
	-name target-x86_64.conf -o \
	-name xen-mfndump -o \
	-name qcow-create -o \
	-name img2qcow -o \
	-name qcow2raw -o \
	-name qemu-bridge-helper -o \
	-name qemu-img-xen -o \
	-name qemu-nbd-xen -o \
	-name palcode-clipper -o \
	-name "*.dtb" -o \
	-name "openbios-*" -o \
	-name "petalogix*" -o \
	-name "ppc*" -o \
	-name "s390*" -o \
	-name "slof*" -o \
	-name "spapr*" -o \
	-name "*.egg-info" \) \
	-print -delete
# Wipe empty directories
if find $RPM_BUILD_ROOT/usr -type d -print0 | xargs -0n1 rmdir -p 2>/dev/null
then
	:
fi

# Create symlinks for keymaps
%fdupes -s $RPM_BUILD_ROOT/%{_datadir}

%else
# !with_dom0_support

# 32 bit hypervisor no longer supported.  Remove dom0 tools.
rm -rf $RPM_BUILD_ROOT/%{_datadir}/doc
rm -rf $RPM_BUILD_ROOT/%{_datadir}/man
rm -rf $RPM_BUILD_ROOT/%{_libdir}/xen
rm -rf $RPM_BUILD_ROOT/%{_libdir}/python*
rm -rf $RPM_BUILD_ROOT%{_unitdir}
rm -rf $RPM_BUILD_ROOT%{with_systemd_modules_load}
rm -rf $RPM_BUILD_ROOT/usr/sbin
rm -rf $RPM_BUILD_ROOT/etc/xen
rm -rf $RPM_BUILD_ROOT/var
rm -f  $RPM_BUILD_ROOT/%{_sysconfdir}/bash_completion.d/xl.sh
rm -f  $RPM_BUILD_ROOT/%{_sysconfdir}/init.d/xen*
rm -f  $RPM_BUILD_ROOT/%{_bindir}/*store*
rm -f  $RPM_BUILD_ROOT/%{_bindir}/*trace*
rm -f  $RPM_BUILD_ROOT/%{_bindir}/xenalyze*
rm -f  $RPM_BUILD_ROOT/%{_bindir}/xenco*
rm -f  $RPM_BUILD_ROOT/%{_bindir}/pygrub
rm -f  $RPM_BUILD_ROOT/%{_bindir}/remus
rm -f  $RPM_BUILD_ROOT/usr/etc/qemu/target-x86_64.conf
rm -f  $RPM_BUILD_ROOT/usr/libexec/qemu-bridge-helper
%endif

%if %{?with_dom0_support}0

%files -f xen.files.txt
%defattr(-,root,root)
/boot/*

%endif

%files libs
%defattr(-,root,root)
%{_libdir}/fs/
%{_libdir}/*.so.*

%if %{?with_dom0_support}0

%files tools
%defattr(-,root,root)
%ifarch %ix86 x86_64
/usr/bin/xenalyze
%endif
/usr/bin/xencons
/usr/bin/xenstore*
/usr/bin/pygrub
#%if %{?with_qemu_traditional}0
#/usr/bin/tapdisk-ioemu
#%endif
/usr/bin/xencov_split
/usr/bin/xentrace_format
/usr/sbin/tap*
/usr/sbin/xenbaked
/usr/sbin/xenconsoled
/usr/sbin/xencov
/usr/sbin/xenlockprof
/usr/sbin/xenmon.py
/usr/sbin/xenperf
/usr/sbin/xenpm
/usr/sbin/xenpmd
/usr/sbin/xen-ringwatch
/usr/sbin/xenstored
/usr/sbin/xen-tmem-list-parse
/usr/sbin/xentop
/usr/sbin/xentrace
/usr/sbin/xentrace_setsize
/usr/sbin/xentrace_setmask
/usr/sbin/xenwatchdogd
/usr/sbin/gtracestat
/usr/sbin/gtraceview
/usr/sbin/lock-util
/usr/sbin/td-util
/usr/sbin/vhd-update
/usr/sbin/vhd-util
%if %{?with_gdbsx}0
/usr/sbin/gdbsx
%endif
/usr/sbin/xl
/usr/sbin/xen2libvirt
%ifarch %ix86 x86_64
/usr/sbin/xen-hptool
/usr/sbin/xen-hvmcrash
/usr/sbin/xen-hvmctx
/usr/sbin/xen-lowmemd
/usr/sbin/kdd
%endif
/usr/sbin/xen-list
/usr/sbin/xen-destroy
/usr/sbin/xen-bugtool
%dir %attr(700,root,root) /etc/xen
%dir /etc/xen/scripts
%if %{?with_qemu_traditional}0
#/usr/sbin/blktapctrl
#/etc/xen/scripts/blktap
/etc/xen/scripts/qemu-ifup
%endif
/etc/xen/scripts/block*
/etc/xen/scripts/external-device-migrate
/etc/xen/scripts/hotplugpath.sh
/etc/xen/scripts/locking.sh
/etc/xen/scripts/logging.sh
/etc/xen/scripts/vif2
/etc/xen/scripts/vif-*
/etc/xen/scripts/vscsi
/etc/xen/scripts/xen-hotplug-*
/etc/xen/scripts/xen-network-common.sh
/etc/xen/scripts/xen-script-common.sh
%{_libexecdir}/xen
/var/adm/fillup-templates/sysconfig.pciback
/var/adm/fillup-templates/sysconfig.xencommons
/var/adm/fillup-templates/sysconfig.xendomains
%dir /var/lib/xen
%dir %attr(700,root,root) /var/lib/xen/images
%dir %attr(700,root,root) /var/lib/xen/save
%dir %attr(700,root,root) /var/lib/xen/dump
%ifarch %ix86 x86_64
%dir %attr(700,root,root) /var/lib/xen/xenpaging
%endif
%dir /var/lib/xenstored
%dir /var/log/xen
%dir /var/log/xen/console
%config /etc/logrotate.d/xen
/etc/xen/auto
%config /etc/xen/examples
/etc/xen/images
%config /etc/xen/cpupool
/etc/xen/README*
%config /etc/xen/vm
%config(noreplace) /etc/xen/xenapiusers
%config(noreplace) /etc/xen/xl.conf
%config /etc/pam.d/xen-api
%config /etc/modprobe.d/xen_loop.conf
%if %{?with_systemd}0
%config %{_unitdir}
%config %{with_systemd_modules_load}
%if %{?include_systemd_preset}0
%config %_presetdir
%endif
%else
/usr/sbin/rcpciback
/usr/sbin/rcxendomains
%config %{_initddir}/*
%endif
%dir /etc/modprobe.d
/etc/bash_completion.d/xl.sh
%if %{?with_qemu_traditional}0
%dir %{_datadir}/xen
%dir %{_datadir}/xen/qemu
%{_datadir}/xen/qemu/*
%endif
%dir %{_libdir}/python%{pyver}/site-packages/grub
%dir %{_libdir}/python%{pyver}/site-packages/xen
%dir %{_libdir}/python%{pyver}/site-packages/xen/lowlevel
%dir %{_libdir}/python%{pyver}/site-packages/xen/migration
%{_libdir}/python%{pyver}/site-packages/grub/*
%{_libdir}/python%{pyver}/site-packages/xen/__init__*
%{_libdir}/python%{pyver}/site-packages/xen/lowlevel/*
%{_libdir}/python%{pyver}/site-packages/xen/migration/*
%{_libdir}/python%{pyver}/site-packages/fsimage.so
%{_libdir}/python%{pyver}/site-packages/xnloader.py
%dir %{_defaultdocdir}/xen
%{_defaultdocdir}/xen/COPYING
%{_defaultdocdir}/xen/README.SUSE
%{_defaultdocdir}/xen/boot.local.xenU
%{_defaultdocdir}/xen/boot.xen
%{_defaultdocdir}/xen/misc
%{_mandir}/man1/xentop.1.gz
%{_mandir}/man1/xentrace_format.1.gz
%{_mandir}/man1/xl.1.gz
%{_mandir}/man1/xenstore-chmod.1.gz
%{_mandir}/man1/xenstore-ls.1.gz
%{_mandir}/man1/xenstore.1.gz
%{_mandir}/man5/xl.cfg.5.gz
%{_mandir}/man5/xl.conf.5.gz
%{_mandir}/man5/xlcpupool.cfg.5.gz
%{_mandir}/man8/*.8.gz
%{_mandir}/man1/xen-list.1.gz

# with_dom0_support
%endif

%files tools-domU
%defattr(-,root,root)
%ifarch %ix86 x86_64
/usr/bin/xen-detect
%endif
/bin/domu-xenstore
/bin/xenstore-*

%files devel
%defattr(-,root,root)
%{_libdir}/*.a
%{_libdir}/*.so
/usr/include/*
%{_datadir}/pkgconfig/xenlight.pc
%{_datadir}/pkgconfig/xlutil.pc

%if %{?with_dom0_support}0

%files doc-html
%defattr(-,root,root)
%dir %{_defaultdocdir}/xen
%{_defaultdocdir}/xen/html

%post
if [ -x /sbin/update-bootloader ]; then
    /sbin/update-bootloader --refresh; exit 0
fi

%pre tools
%if %{?with_systemd}0
%service_add_pre xencommons.service
%service_add_pre xendomains.service
%endif

%post tools
xen_tools_first_arg=$1
%if %{?with_systemd}0
%{fillup_only -n xencommons xencommons}
%{fillup_only -n xendomains xendomains}
%service_add_post xencommons.service
%service_add_post xendomains.service
%else
%{fillup_only -n pciback}
%{fillup_and_insserv -y -n xencommons xencommons}
%{fillup_and_insserv -i -y -n xendomains xendomains}
%endif

if [ -f /usr/bin/qemu-img ]; then
    if [ -f /usr/bin/qemu-img-xen ]; then
        rm /usr/bin/qemu-img-xen
    fi
    rm -f %{_libexecdir}/xen/bin/qemu-img-xen
    ln -s /usr/bin/qemu-img %{_libexecdir}/xen/bin/qemu-img-xen
fi
if [ -f /usr/bin/qemu-nbd ]; then
    if [ -f /usr/bin/qemu-nbd-xen ]; then
        rm /usr/bin/qemu-nbd-xen
    fi
    rm -f %{_libexecdir}/xen/bin/qemu-nbd-xen
    ln -s /usr/bin/qemu-nbd %{_libexecdir}/xen/bin/qemu-nbd-xen
fi
if [ -f /usr/bin/qemu-io ]; then
    rm -f %{_libexecdir}/xen/bin/qemu-io-xen
    ln -s /usr/bin/qemu-io %{_libexecdir}/xen/bin/qemu-io-xen
fi
if [ -f /etc/default/grub ] && ! (/usr/bin/grep GRUB_CMDLINE_XEN /etc/default/grub >/dev/null); then
    echo '# Xen boot parameters for all Xen boots' >> /etc/default/grub
    echo 'GRUB_CMDLINE_XEN=""' >> /etc/default/grub
    echo '# Xen boot parameters for non-recovery Xen boots (in addition to GRUB_CMDLINE_XEN)' >> /etc/default/grub
    echo 'GRUB_CMDLINE_XEN_DEFAULT=""' >> /etc/default/grub
fi

%preun tools
%if %{?with_systemd}0
%service_del_preun xencommons.service
%service_del_preun xendomains.service
%else
%{stop_on_removal xendomains xencommons}
%endif

%postun tools
export DISABLE_RESTART_ON_UPDATE=yes
%if %{?with_systemd}0
%service_del_postun xencommons.service
%service_del_postun xendomains.service
%else
%{insserv_cleanup}
%endif

%endif

%post libs -p /sbin/ldconfig

%postun libs -p /sbin/ldconfig

%changelog
