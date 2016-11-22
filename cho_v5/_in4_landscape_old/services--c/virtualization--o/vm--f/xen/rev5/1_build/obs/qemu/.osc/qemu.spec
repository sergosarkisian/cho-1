#
# spec file for package qemu
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


%define build_x86_fw_from_source 0
%define build_slof_from_source 0
%ifarch %ix86 x86_64
# choice of building all from source or using provided binary x86 blobs
%if 0%{?suse_version} >= 1310
%define build_x86_fw_from_source 1
%endif
%endif
%ifarch ppc64
%define build_slof_from_source 1
%endif
%ifarch ppc64le
# Needs a compatible gcc (bsc#949000)
# TODO: include 1315 for SLE12 once possible
%if 0%{?suse_version} > 1320
%define build_slof_from_source 1
%endif
%endif
%ifarch %ix86 x86_64 ppc ppc64 ppc64le s390x armv7hl aarch64
%define kvm_available 1
%else
%define kvm_available 0
%endif
%ifarch %ix86 x86_64 s390x
%define legacy_qemu_kvm 1
%else
%define legacy_qemu_kvm 0
%endif
%define noarch_supported 1110

Name:           qemu
Url:            http://www.qemu.org/
Summary:        Universal CPU emulator
License:        BSD-3-Clause and GPL-2.0 and GPL-2.0+ and LGPL-2.1+ and MIT
Group:          System/Emulators/PC
Version:        2.5.1.1
Release:        0
Source:         http://wiki.qemu.org/download/qemu-2.5.1.1.tar.bz2
Source99:       http://wiki.qemu.org/download/qemu-2.5.1.1.tar.bz2.sig
Source1:        80-kvm.rules
Source2:        qemu-ifup
Source3:        kvm_stat
Source4:        qemu-kvm.1.gz
Source5:        60-kvm.rules
Source6:        ksm.service
Source7:        60-kvm.x86.rules
Source8:        80-qemu-ga.rules
Source9:        qemu-ga.service
# Upstream First -- http://wiki.qemu-project.org/Contribute/SubmitAPatch
# This patch queue is auto-generated from https://github.com/openSUSE/qemu
Patch0001:      0001-XXX-dont-dump-core-on-sigabort.patch
Patch0002:      0002-XXX-work-around-SA_RESTART-race-wit.patch
Patch0003:      0003-qemu-0.9.0.cvs-binfmt.patch
Patch0004:      0004-qemu-cvs-alsa_bitfield.patch
Patch0005:      0005-qemu-cvs-alsa_ioctl.patch
Patch0006:      0006-qemu-cvs-alsa_mmap.patch
Patch0007:      0007-qemu-cvs-gettimeofday.patch
Patch0008:      0008-qemu-cvs-ioctl_debug.patch
Patch0009:      0009-qemu-cvs-ioctl_nodirection.patch
Patch0010:      0010-block-vmdk-Support-creation-of-SCSI.patch
Patch0011:      0011-linux-user-add-binfmt-wrapper-for-a.patch
Patch0012:      0012-PPC-KVM-Disable-mmu-notifier-check.patch
Patch0013:      0013-linux-user-fix-segfault-deadlock.patch
Patch0014:      0014-linux-user-binfmt-support-host-bina.patch
Patch0015:      0015-linux-user-Ignore-broken-loop-ioctl.patch
Patch0016:      0016-linux-user-lock-tcg.patch
Patch0017:      0017-linux-user-Run-multi-threaded-code-.patch
Patch0018:      0018-linux-user-lock-tb-flushing-too.patch
Patch0019:      0019-linux-user-Fake-proc-cpuinfo.patch
Patch0020:      0020-linux-user-implement-FS_IOC_GETFLAG.patch
Patch0021:      0021-linux-user-implement-FS_IOC_SETFLAG.patch
Patch0022:      0022-linux-user-XXX-disable-fiemap.patch
Patch0023:      0023-slirp-nooutgoing.patch
Patch0024:      0024-vnc-password-file-and-incoming-conn.patch
Patch0025:      0025-linux-user-add-more-blk-ioctls.patch
Patch0026:      0026-linux-user-use-target_ulong.patch
Patch0027:      0027-block-Add-support-for-DictZip-enabl.patch
Patch0028:      0028-block-Add-tar-container-format.patch
Patch0029:      0029-Legacy-Patch-kvm-qemu-preXX-dictzip.patch
Patch0030:      0030-console-add-question-mark-escape-op.patch
Patch0031:      0031-Make-char-muxer-more-robust-wrt-sma.patch
Patch0032:      0032-linux-user-lseek-explicitly-cast-no.patch
Patch0033:      0033-virtfs-proxy-helper-Provide-__u64-f.patch
Patch0034:      0034-configure-Enable-PIE-for-ppc-and-pp.patch
Patch0035:      0035-qtest-Increase-socket-timeout.patch
Patch0036:      0036-AIO-Reduce-number-of-threads-for-32.patch
Patch0037:      0037-configure-Enable-libseccomp-for-ppc.patch
Patch0038:      0038-dictzip-Fix-on-big-endian-systems.patch
# Please do not add QEMU patches manually here.
# Run update_git.sh to regenerate this queue.

# SeaBIOS
%if %{build_x86_fw_from_source}
# PATCH-FIX-OPENSUSE seabios_128kb.patch brogers@suse.com -- make it fit
Patch1000:      seabios_128kb.patch
# PATCH-FIX-UPSTREAM seabios_checkrom_typo.patch afaerber@suse.de -- tidy error message
Patch1001:      seabios_checkrom_typo.patch
Patch1002:      seabios_avoid_smbios_signature_string.patch
%endif

# this is to make lint happy
Source300:      qemu-rpmlintrc
Source302:      bridge.conf
Source400:      update_git.sh
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  SDL-devel
BuildRequires:  alsa-devel
BuildRequires:  bluez-devel
%if 0%{?suse_version} >= 1130
BuildRequires:  brlapi-devel
%endif
BuildRequires:  curl-devel
BuildRequires:  cyrus-sasl-devel
%if %{build_x86_fw_from_source}
BuildRequires:  iasl
%endif
BuildRequires:  e2fsprogs-devel
BuildRequires:  fdupes
BuildRequires:  gcc-c++
BuildRequires:  glib2-devel
%if 0%{?suse_version} >= 1310 && 0%{?suse_version} != 1315
BuildRequires:  glusterfs-devel
%endif
%if 0%{?suse_version} >= 1220
BuildRequires:  gtk3-devel
%else
BuildRequires:  gtk2-devel
%endif
BuildRequires:  libaio
BuildRequires:  libaio-devel
BuildRequires:  libattr-devel
BuildRequires:  libbz2-devel
BuildRequires:  libcacard-devel
BuildRequires:  libcap-devel
BuildRequires:  libcap-ng-devel
%if 0%{?suse_version} >= 1310
# 12.3 and earlier don't ship a compatible libfdt; use the bundled one there
BuildRequires:  libfdt1-devel
%endif
BuildRequires:  libgcrypt-devel
BuildRequires:  libgnutls-devel
%if 0%{?suse_version} >= 1315
BuildRequires:  libibverbs-devel
%endif
BuildRequires:  libjpeg-devel
%if 0%{?suse_version} >= 1310
BuildRequires:  libnettle-devel
%endif
%ifarch %ix86 aarch64
%if 0%{?suse_version} > 1320
BuildRequires:  libnuma-devel
%endif
%else
%ifnarch %arm s390x
BuildRequires:  libnuma-devel
%endif
%endif
BuildRequires:  libpcap-devel
BuildRequires:  libpixman-1-0-devel
BuildRequires:  libpng-devel
BuildRequires:  libpulse-devel
%if 0%{?suse_version} >= 1315
BuildRequires:  librdmacm-devel
%endif
%ifnarch ppc64le
%if 0%{?suse_version} > 1320
BuildRequires:  libseccomp-devel
%endif
%endif
%if 0%{?suse_version} > 1140
BuildRequires:  libssh2-devel
%endif
BuildRequires:  libtool
%if 0%{?suse_version} > 1310
BuildRequires:  libusb-1_0-devel
%endif
BuildRequires:  libvdeplug3-devel
BuildRequires:  lzo-devel
%if 0%{?suse_version} > 1220
BuildRequires:  makeinfo
%endif
BuildRequires:  mozilla-nss-devel
BuildRequires:  ncurses-devel
BuildRequires:  pkgconfig
BuildRequires:  pwdutils
BuildRequires:  python
%if 0%{?suse_version} >= 1310
BuildRequires:  snappy-devel
%endif
%if 0%{?suse_version} >= 1210
BuildRequires:  systemd
%{?systemd_requires}
%define with_systemd 1
%endif
%if %{kvm_available}
BuildRequires:  udev
%if 0%( pkg-config --exists 'udev > 190' && echo '1' ) == 01
%define _udevrulesdir /usr/lib/udev/rules.d
%else
%define _udevrulesdir /lib/udev/rules.d
%endif
%endif
%if 0%{?sles_version} != 11
BuildRequires:  usbredir-devel
%endif
%if 0%{?suse_version} >= 1210
%if 0%{?suse_version} >= 1220
BuildRequires:  vte-devel
%else
BuildRequires:  vte2-devel
%endif
%endif
%ifarch x86_64
BuildRequires:  xen-devel
%endif
%if %{build_x86_fw_from_source}
BuildRequires:  xz-devel
%endif
BuildRequires:  zlib-devel
%if 0%{?suse_version} >= 1140
%ifarch %ix86 x86_64
BuildRequires:  libspice-server-devel
BuildRequires:  spice-protocol-devel
%endif
%endif
%if "%{name}" == "qemu-testsuite"
BuildRequires:  bc
BuildRequires:  qemu-arm   = %version
BuildRequires:  qemu-extra = %version
BuildRequires:  qemu-guest-agent = %version
BuildRequires:  qemu-ppc   = %version
BuildRequires:  qemu-s390  = %version
BuildRequires:  qemu-tools = %version
BuildRequires:  qemu-x86   = %version
%endif
Requires:       /usr/sbin/groupadd
Requires:       pwdutils
Requires:       timezone
Recommends:     qemu-block-curl
Recommends:     qemu-tools
Recommends:     qemu-x86
%ifarch ppc ppc64 ppc64le
Recommends:     qemu-ppc
%else
Suggests:       qemu-ppc
%endif
%ifarch s390x
Recommends:     qemu-s390
%else
Suggests:       qemu-s390
%endif
%ifarch %arm aarch64
Recommends:     qemu-arm
%else
Suggests:       qemu-arm
%endif
Suggests:       qemu-block-dmg
Suggests:       qemu-extra
Suggests:       qemu-lang
%if 0%{?with_systemd}
Recommends:     qemu-ksm = %{version}
%endif

%define built_firmware_files {acpi-dsdt.aml bios.bin bios-256k.bin \
q35-acpi-dsdt.aml sgabios.bin vgabios.bin vgabios-cirrus.bin \
vgabios-stdvga.bin vgabios-virtio.bin vgabios-vmware.bin vgabios-qxl.bin \
optionrom/linuxboot.bin optionrom/multiboot.bin optionrom/kvmvapic.bin \
pxe-e1000.rom pxe-pcnet.rom pxe-ne2k_pci.rom pxe-rtl8139.rom pxe-eepro100.rom pxe-virtio.rom}

%description
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

%if "%{name}" != "qemu-testsuite"

%package x86
Summary:        Universal CPU emulator -- x86
Group:          System/Emulators/PC
Requires:       qemu = %version
Requires:       qemu-ipxe
Requires:       qemu-seabios
Requires:       qemu-sgabios
Requires:       qemu-vgabios

%description x86
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package provides i386 and x86_64 emulation.

%package ppc
Summary:        Universal CPU emulator -- Power Architecture
Group:          System/Emulators/PC
Requires:       qemu = %version

%description ppc
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package provides ppc and ppc64 emulation.

%package s390
Summary:        Universal CPU emulator -- S/390
Group:          System/Emulators/PC
Requires:       qemu = %version

%description s390
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package provides s390x emulation.

%package arm
Summary:        Universal CPU emulator -- ARM
Group:          System/Emulators/PC
Requires:       qemu = %version

%description arm
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package provides arm emulation.

%package extra
Summary:        Universal CPU emulator -- extra architectures
Group:          System/Emulators/PC
Requires:       qemu = %version

%description extra
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package provides some lesser used emulations, such as moxie and xtensa.

%if %{legacy_qemu_kvm}
%package kvm
Url:            http://www.linux-kvm.org
Summary:        Kernel-based Virtual Machine
Group:          System/Emulators/PC
%ifarch %ix86 x86_64
Requires:       qemu-x86 = %version
%endif
%ifarch s390x
Requires:       qemu-s390 = %version
%endif
Provides:       kvm = %version
Obsoletes:      kvm < %version
Recommends:     python-curses

%description kvm
KVM (Kernel-based Virtual Machine) is virtualization software for Linux.
It is designed to leverage the hardware virtualization features included
with various architectures. QEMU uses KVM for CPU virtualization, while
still providing emulation of other system components. This package is
not required for KVM usage, but rather facilitates its usage with tools
derived from the legacy kvm package.
%endif

%package lang
Summary:        Universal CPU emulator -- Translations
Group:          System/Emulators/PC

%description lang
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains translations.

# Modules need to match {qemu-system-*,qemu-img} version.
# We cannot have qemu and qemu-tools require them in the right version,
# as that would drag in the dependencies the modules are supposed to avoid.
# Nor can we have modules require the right version of qemu and qemu-tools
# as Xen reuses our qemu-tools but does not want our qemu and qemu-x86.
%define qemu_module_conflicts \
Conflicts:      qemu < %version \
Conflicts:      qemu > %version \
Conflicts:      qemu-tools < %version \
Conflicts:      qemu-tools > %version

%package block-curl
Summary:        Universal CPU emulator -- cURL block support
Group:          System/Emulators/PC
Provides:       qemu:%_libdir/%name/block-curl.so
%{qemu_module_conflicts}

%description block-curl
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains a module for accessing network-based image files
over a network connection from qemu-img tool and QEMU system emulation.

%package block-dmg
Summary:        Universal CPU emulator -- DMG block support
Group:          System/Emulators/PC
%{qemu_module_conflicts}

%description block-dmg
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains a module for accessing Mac OS X image files
from qemu-img tool and QEMU system emulation.

%if 0%{?suse_version} >= 1310 && 0%{?suse_version} != 1315
%package block-gluster
Summary:        Universal CPU emulator -- GlusterFS block support
Group:          System/Emulators/PC
%{qemu_module_conflicts}

%description block-gluster
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains a module for accessing network-based image files
over a GlusterFS network connection from qemu-img tool and QEMU system emulation.
%endif

%if 0%{?suse_version} > 1140
%package block-ssh
Summary:        Universal CPU emulator -- SSH block support
Group:          System/Emulators/PC
%{qemu_module_conflicts}

%description block-ssh
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains a module for accessing network-based image files
over an SSH network connection from qemu-img tool and QEMU system emulation.
%endif

%package tools
Summary:        Universal CPU emulator -- Tools
Group:          System/Emulators/PC
Provides:       qemu:%_libexecdir/qemu-bridge-helper
PreReq:         permissions
Recommends:     qemu-block-curl

%description tools
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains various tools, including a bridge helper.

%package guest-agent
Summary:        Universal CPU emulator -- Guest agent
Group:          System/Emulators/PC
Provides:       qemu:%_bindir/qemu-ga
%if 0%{?with_systemd}
%{?systemd_requires}
%endif

%description guest-agent
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains the guest agent.

%ifarch %ix86 x86_64
%package seabios
Summary:        X86 BIOS for QEMU
Group:          System/Emulators/PC
Version:        1.8.2
Release:        0
%if 0%{?suse_version} > %{noarch_supported}
BuildArch:      noarch
%endif
Conflicts:      qemu < 1.6.0

%description seabios
SeaBIOS is an open source implementation of a 16bit x86 BIOS. SeaBIOS
is the default BIOS for QEMU.

%package vgabios
Summary:        VGA BIOSes for QEMU
Group:          System/Emulators/PC
Version:        1.8.2
Release:        0
%if 0%{?suse_version} > %{noarch_supported}
BuildArch:      noarch
%endif
Conflicts:      qemu < 1.6.0

%description vgabios
VGABIOS provides the video ROM BIOSes for the following variants of VGA
emulated devices: Std VGA, QXL, Cirrus CLGD 5446 and VMware emulated
video card.

%package sgabios
Summary:        Serial Graphics Adapter BIOS for QEMU
Group:          System/Emulators/PC
Version:        8
Release:        0
%if 0%{?suse_version} > %{noarch_supported}
BuildArch:      noarch
%endif
Conflicts:      qemu < 1.6.0

%description sgabios
The Google Serial Graphics Adapter BIOS or SGABIOS provides a means for legacy
x86 software to communicate with an attached serial console as if a video card
were attached.

%package ipxe
Summary:        PXE ROMs for QEMU NICs
Group:          System/Emulators/PC
Version:        1.0.0
Release:        0
%if 0%{?suse_version} > %{noarch_supported}
BuildArch:      noarch
%endif
Conflicts:      qemu < 1.6.0

%description ipxe
Preboot Execution Environment (PXE) ROM support for various emulated network
adapters available with QEMU.
%endif

%if 0%{?with_systemd}
%package ksm
Summary:        Kernel Samepage Merging services
Group:          System/Emulators/PC

%description ksm
Kernel Samepage Merging (KSM) is a memory-saving de-duplication feature,
that merges anonymous (private) pages (not pagecache ones).

This package provides a service file for starting and stopping KSM.
%endif

%endif # !qemu-testsuite

%prep
%setup -q -n qemu-2.5.1.1
%patch0001 -p1
%patch0002 -p1
%patch0003 -p1
%patch0004 -p1
%patch0005 -p1
%patch0006 -p1
%patch0007 -p1
%patch0008 -p1
%patch0009 -p1
%patch0010 -p1
%patch0011 -p1
%patch0012 -p1
%patch0013 -p1
%patch0014 -p1
%patch0015 -p1
%patch0016 -p1
%patch0017 -p1
%patch0018 -p1
%patch0019 -p1
%patch0020 -p1
%patch0021 -p1
%patch0022 -p1
%patch0023 -p1
%patch0024 -p1
%patch0025 -p1
%patch0026 -p1
%patch0027 -p1
%patch0028 -p1
%patch0029 -p1
%patch0030 -p1
%patch0031 -p1
%patch0032 -p1
%patch0033 -p1
%patch0034 -p1
%patch0035 -p1
%patch0036 -p1
%patch0037 -p1
%patch0038 -p1

%if %{build_x86_fw_from_source}
pushd roms/seabios
%patch1000 -p1
%patch1001 -p1
%patch1002 -p1
popd

# as a safeguard, delete the firmware files that we intend to build
for i in %built_firmware_files
do
  rm -f pc-bios/$i
done
%endif

%if %{build_slof_from_source}
rm -f pc-bios/slof.bin
%endif

%build
./configure --prefix=%_prefix --sysconfdir=%_sysconfdir \
	--libdir=%_libdir \
	--libexecdir=%_libexecdir \
	--localstatedir=%_localstatedir \
	--extra-cflags="%{optflags}" \
	--disable-strip \
	--enable-system --disable-linux-user \
	--enable-tools --enable-guest-agent \
	--enable-modules \
	--enable-pie \
	--enable-docs \
	--audio-drv-list="pa alsa sdl oss" \
	--disable-archipelago \
	--enable-attr \
	--enable-bluez \
%if 0%{?suse_version} >= 1130
	--enable-brlapi \
%else
	--disable-brlapi \
%endif
	--enable-bzip2 \
	--enable-cap-ng \
	--enable-coroutine-pool \
	--enable-curl \
	--enable-curses \
	--enable-fdt \
%if 0
# Let it auto-detect these based on gnutls - uses libnettle in Tumbleweed but unavailable in SLE11
	--enable-gcrypt \
	--disable-nettle \
%endif
%if 0%{?suse_version} >= 1310 && 0%{?suse_version} != 1315
	--enable-glusterfs \
%else
	--disable-glusterfs \
%endif
	--enable-gnutls \
	--enable-gtk \
%if 0%{?suse_version} >= 1220
	--with-gtkabi=3.0 \
%else
	--with-gtkabi=2.0 \
%endif
%if %{kvm_available}
	--enable-kvm \
%else
	--disable-kvm \
%endif
	--disable-libiscsi \
	--disable-libnfs \
%if 0%{?suse_version} > 1140
	--enable-libssh2 \
%else
	--disable-libssh2 \
%endif
%if 0%{?suse_version} > 1310
	--enable-libusb \
%else
	--disable-libusb \
%endif
	--enable-linux-aio \
	--enable-lzo \
	--disable-netmap \
%ifarch %ix86 aarch64
%if 0%{?suse_version} > 1320
	--enable-numa \
%else
	--disable-numa \
%endif
%else
%ifarch %arm s390x
	--disable-numa \
%else
	--enable-numa \
%endif
%endif
	--disable-rbd \
%if 0%{?suse_version} >= 1315
	--enable-rdma \
%else
	--disable-rdma \
%endif
	--enable-sdl \
	--with-sdlabi=1.2 \
%ifnarch ppc64le
%if 0%{?suse_version} > 1320
	--enable-seccomp \
%else
	--disable-seccomp \
%endif
%else
	--disable-seccomp \
%endif
	--enable-smartcard \
%if 0%{?suse_version} >= 1310
	--enable-snappy \
%else
	--disable-snappy \
%endif
%if 0%{?suse_version} >= 1140
%ifarch %ix86 x86_64
	--enable-spice \
%else
	--disable-spice \
%endif
%else
	--disable-spice \
%endif
	--enable-tpm \
	--enable-trace-backends=nop \
%if 0%{?sles_version} != 11
	--enable-usb-redir \
%else
	--disable-usb-redir \
%endif
	--enable-uuid \
	--enable-vde \
	--enable-vhdx \
	--enable-vhost-net \
	--enable-virtfs \
	--enable-vnc \
	--enable-vnc-jpeg \
	--enable-vnc-png \
	--enable-vnc-sasl \
%if 0%{?suse_version} == 1310 || (0%{?suse_version} == 1315 && 0%{?is_opensuse} == 0)
	--enable-vte \
%endif
%ifarch x86_64
	--enable-xen \
	--enable-xen-pci-passthrough \
%else
	--disable-xen \
%endif

%if "%{name}" != "qemu-testsuite"

make %{?_smp_mflags} V=1

# Firmware
%if %{build_x86_fw_from_source}
make -C roms bios
make -C roms seavgabios
make -C roms pxerom
make -C roms sgabios
%endif
%if %{build_slof_from_source}
make -C roms slof
%endif
%ifarch s390x
cp pc-bios/s390-ccw/s390-ccw.img pc-bios/s390-ccw.img
%endif

%else # qemu-testsuite

ln -s %{_bindir}/qemu-img qemu-img
ln -s %{_bindir}/qemu-ga qemu-ga

%if %{build_x86_fw_from_source}
for i in %built_firmware_files
do
  ln -s %{_datadir}/qemu/$i pc-bios/$i
done
%endif

for conf in default-configs/*-softmmu.mak; do
  arch=`echo "$conf" | sed -e 's|default-configs/\(.*\)-softmmu.mak|\1|g'`
  ln -s %{_bindir}/qemu-system-$arch $arch-softmmu/qemu-system-$arch
done

# Compile the QOM test binary first, so that ...
make tests/qom-test %{?_smp_mflags} V=1 
# ... make comes in fresh and has lots of address space (needed for 32bit, bsc#957379)
%if 0%{?suse_version} >= 1310
make check-report.html V=1
install -D -m 644 check-report.html %{buildroot}%{_datadir}/qemu/check-report.html
%else
make check-report.xml V=1
%endif

%endif

%check
%if "%{name}" == "qemu-testsuite"

%ifnarch %ix86 x64_64
export QEMU_PROG=%{_bindir}/qemu-system-x86_64
%endif
export QEMU_IMG_PROG=%{_bindir}/qemu-img
export QEMU_IO_PROG=%{_bindir}/qemu-io
export QEMU_NBD_PROG=%{_bindir}/qemu-nbd
# make check-block would rebuild qemu-img and qemu-io
make tests/qemu-iotests/socket_scm_helper V=1
pushd tests/qemu-iotests
# -qcow 001 seems to hang?
# TODO investigate hangs and failures
#for fmt in -raw -bochs -cloop -parallels -qcow2 -qed -vdi -vpc -vhdx -vmdk; do
#  ./check -v -T $fmt -file -g quick || true
#done
popd

# Create minimal gzip format file
echo "Test" > test.txt
cat test.txt | gzip - > test.gz
# Check qemu-img info output (bsc#945778)
format=`qemu-img info test.gz | grep "file format:" | cut -d ':' -f 2 | tr -d '[:space:]'`
[ "$format" == "raw" ] || false

# Create minimal tar format file
tar cf test.tar test.txt
# Check qemu-img info output (bsc#945778)
format=`qemu-img info test.tar | grep "file format:" | cut -d ':' -f 2 | tr -d '[:space:]'`
[ "$format" == "raw" ] || false

%endif # qemu-testsuite

%install
%if "%{name}" != "qemu-testsuite"

make install DESTDIR=$RPM_BUILD_ROOT
rm -fr $RPM_BUILD_ROOT/%_datadir/doc
%if ! %{build_x86_fw_from_source}
for f in acpi-dsdt.aml q35-acpi-dsdt.aml bios-256k.bin bios.bin efi-*.rom pxe-*.rom sgabios.bin \
         vgabios-cirrus.bin vgabios-qxl.bin vgabios-stdvga.bin vgabios-virtio.bin vgabios-vmware.bin \
         vgabios.bin; do
  rm $RPM_BUILD_ROOT/%_datadir/%name/$f
done
%endif
# rm -f %{buildroot}%{_datadir}/%{name}/u-boot.e500
install -D -m 644 %{SOURCE302} $RPM_BUILD_ROOT/%{_sysconfdir}/qemu/bridge.conf
%find_lang %name
%if %{legacy_qemu_kvm}
cat > %{buildroot}%{_bindir}/qemu-kvm << 'EOF'
#!/bin/sh

%ifarch s390x
exec %{_bindir}/qemu-system-s390x -machine accel=kvm "$@"
%else
exec %{_bindir}/qemu-system-x86_64 -machine accel=kvm "$@"
%endif
EOF
chmod 755 %{buildroot}%{_bindir}/qemu-kvm
install -D -m 755 %{SOURCE2} %{buildroot}/usr/share/qemu/qemu-ifup
install -D -m 755 %{SOURCE3} %{buildroot}%{_bindir}/kvm_stat
install -D -m 644 %{SOURCE4} %{buildroot}%{_mandir}/man1/qemu-kvm.1.gz
%endif
%if %{kvm_available}
%if 0%{?suse_version} >= 1230
install -D -m 644 %{SOURCE1} %{buildroot}%{_udevrulesdir}/80-kvm.rules
%else
%ifarch %ix86 x86_64
install -D -m 644 %{SOURCE7} %{buildroot}%{_udevrulesdir}/60-kvm.rules
%else
install -D -m 644 %{SOURCE5} %{buildroot}%{_udevrulesdir}/60-kvm.rules
%endif
%endif
%endif
install -D -p -m 0644 %{SOURCE8} %{buildroot}%{_udevrulesdir}/80-qemu-ga.rules
%if 0%{?with_systemd}
install -D -p -m 0644 %{SOURCE6} %{buildroot}%{_unitdir}/ksm.service
install -D -p -m 0644 %{SOURCE9} %{buildroot}%{_unitdir}/qemu-ga.service
%endif
%fdupes -s $RPM_BUILD_ROOT

%else # qemu-testsuite

%if 0%{?suse_version} >= 1310
install -D -m 644 check-report.html %{buildroot}%{_datadir}/qemu/check-report.html
%endif
install -D -m 644 check-report.xml %{buildroot}%{_datadir}/qemu/check-report.xml

%endif

%if "%{name}" != "qemu-testsuite"

%pre
%{_bindir}/getent group kvm >/dev/null || %{_sbindir}/groupadd -r kvm 2>/dev/null
%{_bindir}/getent group qemu >/dev/null || %{_sbindir}/groupadd -r qemu 2>/dev/null
%{_bindir}/getent passwd qemu >/dev/null || \
  %{_sbindir}/useradd -r -g qemu -G kvm -d / -s /sbin/nologin \
  -c "qemu user" qemu

%if %{kvm_available}
%post
%if 0%{?with_systemd}
%udev_rules_update
%else
if [ "$(readlink -f /proc/1/root)" = "/" ]; then
  /sbin/udevadm control --reload-rules  || :
  /sbin/udevadm trigger || :
fi
%endif
%endif

%if 0%{?suse_version} >= 1130
%post tools
%set_permissions %_libexecdir/qemu-bridge-helper

%verifyscript tools
%verify_permissions %_libexecdir/qemu-bridge-helper
%endif

%pre guest-agent
%{_bindir}/getent group kvm >/dev/null || %{_sbindir}/groupadd -r kvm 2>/dev/null
%if 0%{?with_systemd}
%service_add_pre qemu-ga.service

%preun guest-agent
%service_del_preun qemu-ga.service

%post guest-agent
if [ "$(readlink -f /proc/1/root)" = "/" ]; then
  /sbin/udevadm control --reload-rules  || :
  /sbin/udevadm trigger || :
fi
%service_add_post qemu-ga.service

%postun guest-agent
%service_del_postun qemu-ga.service

%pre ksm
%service_add_pre ksm.service

%post ksm
%service_add_post ksm.service

%preun ksm
%service_del_preun ksm.service

%postun ksm
%service_del_postun ksm.service
%endif

%endif # !qemu-testsuite

%files
%defattr(-, root, root)
%if "%{name}" != "qemu-testsuite"
%doc COPYING COPYING.LIB Changelog README VERSION qemu-doc.html qemu-tech.html
%doc %_mandir/man1/qemu.1.gz
%dir %_datadir/%name
%_datadir/%name/keymaps
%_datadir/%name/trace-events
%_datadir/%name/qemu-icon.bmp
%_datadir/%name/qemu_logo_no_text.svg
%dir %_sysconfdir/%name
%dir %_libdir/%name
%if %{kvm_available}
%if 0%{?suse_version} >= 1230
%{_udevrulesdir}/80-kvm.rules
%else
%{_udevrulesdir}/60-kvm.rules
%endif
%endif

%files x86
%defattr(-, root, root)
%_bindir/qemu-system-i386
%_bindir/qemu-system-x86_64
%_datadir/%name/kvmvapic.bin
%_datadir/%name/linuxboot.bin
%_datadir/%name/multiboot.bin

%files ppc
%defattr(-, root, root)
%_bindir/qemu-system-ppc
%_bindir/qemu-system-ppc64
%_bindir/qemu-system-ppcemb
%_datadir/%name/ppc_rom.bin
%_datadir/%name/openbios-ppc
%_datadir/%name/slof.bin
%_datadir/%name/spapr-rtas.bin
%_datadir/%name/u-boot.e500
%_datadir/%name/bamboo.dtb
%_datadir/%name/petalogix-ml605.dtb

%files s390
%defattr(-, root, root)
%_bindir/qemu-system-s390x
%_datadir/%name/s390-zipl.rom
%_datadir/%name/s390-ccw.img

%files arm
%defattr(-, root, root)
%_bindir/qemu-system-arm
%_bindir/qemu-system-aarch64

%files extra
%defattr(-, root, root)
%_bindir/qemu-system-alpha
%_bindir/qemu-system-cris
%_bindir/qemu-system-lm32
%_bindir/qemu-system-m68k
%_bindir/qemu-system-microblaze
%_bindir/qemu-system-microblazeel
%_bindir/qemu-system-mips
%_bindir/qemu-system-mipsel
%_bindir/qemu-system-mips64
%_bindir/qemu-system-mips64el
%_bindir/qemu-system-moxie
%_bindir/qemu-system-or32
%_bindir/qemu-system-sh4
%_bindir/qemu-system-sh4eb
%_bindir/qemu-system-sparc
%_bindir/qemu-system-sparc64
%_bindir/qemu-system-tricore
%_bindir/qemu-system-unicore32
%_bindir/qemu-system-xtensa
%_bindir/qemu-system-xtensaeb
%_datadir/%name/palcode-clipper
%_datadir/%name/openbios-sparc32
%_datadir/%name/openbios-sparc64
%_datadir/%name/petalogix-s3adsp1800.dtb
%_datadir/%name/QEMU,cgthree.bin
%_datadir/%name/QEMU,tcx.bin

%if %{legacy_qemu_kvm}
%files kvm
%defattr(-,root,root)
%_bindir/qemu-kvm
%_bindir/kvm_stat
%_datadir/qemu/qemu-ifup
%_mandir/man1/qemu-kvm.1.gz
%endif

%files block-curl
%defattr(-, root, root)
%_libdir/%name/block-curl.so

%files block-dmg
%defattr(-, root, root)
%_libdir/%name/block-dmg.so

%if 0%{?suse_version} >= 1310 && 0%{?suse_version} != 1315
%files block-gluster
%defattr(-, root, root)
%_libdir/%name/block-gluster.so
%endif

%if 0%{?suse_version} > 1140
%files block-ssh
%defattr(-, root, root)
%_libdir/%name/block-ssh.so
%endif

%files lang -f %name.lang
%defattr(-, root, root)

%if %{build_x86_fw_from_source}
%files seabios
%defattr(-, root, root)
%_datadir/%name/bios.bin
%_datadir/%name/bios-256k.bin
%_datadir/%name/acpi-dsdt.aml
%_datadir/%name/q35-acpi-dsdt.aml

%files vgabios
%defattr(-, root, root)
%_datadir/%name/vgabios.bin
%_datadir/%name/vgabios-cirrus.bin
%_datadir/%name/vgabios-qxl.bin
%_datadir/%name/vgabios-stdvga.bin
%_datadir/%name/vgabios-virtio.bin
%_datadir/%name/vgabios-vmware.bin

%files sgabios
%defattr(-, root, root)
%_datadir/%name/sgabios.bin

%files ipxe
%defattr(-, root, root)
%_datadir/%name/pxe-e1000.rom
%_datadir/%name/pxe-eepro100.rom
%_datadir/%name/pxe-pcnet.rom
%_datadir/%name/pxe-ne2k_pci.rom
%_datadir/%name/pxe-rtl8139.rom
%_datadir/%name/pxe-virtio.rom
%_datadir/%name/efi-e1000.rom
%_datadir/%name/efi-eepro100.rom
%_datadir/%name/efi-pcnet.rom
%_datadir/%name/efi-ne2k_pci.rom
%_datadir/%name/efi-rtl8139.rom
%_datadir/%name/efi-virtio.rom
%endif

%files tools
%defattr(-, root, root)
%doc %_mandir/man1/qemu-img.1.gz
%doc %_mandir/man1/virtfs-proxy-helper.1.gz
%doc %_mandir/man8/qemu-nbd.8.gz
%_bindir/ivshmem-client
%_bindir/ivshmem-server
%_bindir/qemu-io
%_bindir/qemu-img
%_bindir/qemu-nbd
%_bindir/virtfs-proxy-helper
#%_bindir/vscclient
%verify(not mode) %_libexecdir/qemu-bridge-helper
%dir %_sysconfdir/%name
%config %_sysconfdir/%name/bridge.conf
%dir %_libdir/%name

%files guest-agent
%defattr(-, root, root)
%doc %_mandir/man8/qemu-ga.8.gz
%attr(755,root,kvm) %_bindir/qemu-ga
%if 0%{?with_systemd}
%{_unitdir}/qemu-ga.service
%endif
%{_udevrulesdir}/80-qemu-ga.rules

%if 0%{?with_systemd}
%files ksm
%defattr(-, root, root)
%{_unitdir}/ksm.service
%endif

%else # qemu-testsuite
%doc %_datadir/qemu/check-report.xml
%if 0%{?suse_version} >= 1310
%doc %_datadir/qemu/check-report.html
%endif
%endif

%changelog
