#
# spec file for package qemu-linux-user
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


Name:           qemu-linux-user
Url:            http://www.qemu.org/
Summary:        Universal CPU emulator
License:        BSD-3-Clause and GPL-2.0 and GPL-2.0+ and LGPL-2.1+ and MIT
Group:          System/Emulators/PC
Version:        2.5.0
Release:        0
Source:         http://wiki.qemu.org/download/qemu-2.5.0.tar.bz2
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
# Please do not add patches manually here, run update_git.sh.
# this is to make lint happy
Source300:      qemu-rpmlintrc
Source400:      update_git.sh
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  e2fsprogs-devel
BuildRequires:  fdupes
BuildRequires:  gcc-c++
%if 0%{?suse_version} >= 1140
BuildRequires:  glib2-devel-static
%else
BuildRequires:  glib2-devel
%endif
%if 0%{?suse_version} >= 1210
BuildRequires:  glibc-devel-static
%endif
%if 0%{?suse_version} >= 1210
BuildRequires:  libattr-devel-static
%else
BuildRequires:  libattr-devel
%endif
%if 0%{?suse_version} > 1220
BuildRequires:  makeinfo
%endif
BuildRequires:  ncurses-devel
%if 0%{?suse_version} >= 1220
BuildRequires:  pcre-devel-static
%endif
BuildRequires:  python
%if 0%{?suse_version} >= 1120
BuildRequires:  zlib-devel-static
%else
BuildRequires:  zlib-devel
%endif
# we must not install the qemu-linux-user package when under QEMU build
%if 0%{?qemu_user_space_build:1}
#!BuildIgnore:  post-build-checks
%endif
Provides:       qemu:%_bindir/qemu-arm

%description
QEMU is an extremely well-performing CPU emulator that allows you to
choose between simulating an entire system and running userspace
binaries for different architectures under your native operating
system. It currently emulates x86, ARM, PowerPC and SPARC CPUs as well
as PC and PowerMac systems.

This sub-package contains statically linked binaries for running linux-user
emulations. This can be used together with the OBS build script to
run cross-architecture builds.

%prep
%setup -q -n qemu-2.5.0
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

%build
./configure --prefix=%_prefix --sysconfdir=%_sysconfdir \
	--libexecdir=%_libexecdir \
	--enable-linux-user \
	--disable-system \
	--disable-tools \
	--disable-guest-agent \
	--static --disable-linux-aio \
	--disable-fdt \
	--without-pixman \
	--disable-blobs \
	--disable-strip \
	--extra-cflags="$QEMU_OPT_FLAGS"
%if 0%{?suse_version} == 1140
# -lrt needs to come after -lglib-2.0 to avoid undefined clock_gettime
sed -i "s/-lglib-2.0/-lglib-2.0 -lrt/" config-host.mak
%endif
make %{?_smp_mflags} V=1

%ifarch %ix86
%define qemu_arch i386
%endif
%ifarch x86_64
%define qemu_arch x86_64
%endif
%ifarch %arm
%define qemu_arch arm
%endif
%ifarch aarch64
%define qemu_arch aarch64
%endif
%ifarch ppc
%define qemu_arch ppc
%endif
%ifarch ppc64
%define qemu_arch ppc64
%endif
%ifarch ppc64le
%define qemu_arch ppc64le
%endif
%ifarch s390x
%define qemu_arch s390x
%endif

%ifarch %ix86 x86_64 %arm aarch64 ppc ppc64 ppc64le s390x
%if 0%{?suse_version} >= 1310
%check
%{qemu_arch}-linux-user/qemu-%{qemu_arch} %_bindir/ls > /dev/null
%endif
%endif

%install
make install DESTDIR=$RPM_BUILD_ROOT
rm -fr $RPM_BUILD_ROOT/%_datadir/doc
rm -rf $RPM_BUILD_ROOT/%_mandir/man1/qemu.1
rm -rf $RPM_BUILD_ROOT/%_mandir/man1/qemu-img.1
rm -rf $RPM_BUILD_ROOT/%_mandir/man8/qemu-nbd.8
rm -rf $RPM_BUILD_ROOT/%_datadir/qemu/keymaps
rm -rf $RPM_BUILD_ROOT/%_datadir/qemu/trace-events
rm -rf $RPM_BUILD_ROOT/%_sysconfdir/qemu/target-x86_64.conf
rm -rf $RPM_BUILD_ROOT/%_libexecdir/qemu-bridge-helper
install -d -m 755 $RPM_BUILD_ROOT/%_sbindir
install -m 755 scripts/qemu-binfmt-conf.sh $RPM_BUILD_ROOT/%_sbindir
%ifnarch %ix86 x86_64
ln -sf ../../../emul/ia32-linux $RPM_BUILD_ROOT/usr/share/qemu/qemu-i386
%endif
%ifnarch ia64
mkdir -p $RPM_BUILD_ROOT/emul/ia32-linux
%endif
%fdupes -s $RPM_BUILD_ROOT

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
%defattr(-, root, root)
%_bindir/qemu-aarch64
%_bindir/qemu-alpha
%_bindir/qemu-arm
%_bindir/qemu-armeb
%_bindir/qemu-cris
%_bindir/qemu-i386
%_bindir/qemu-m68k
%_bindir/qemu-microblaze
%_bindir/qemu-microblazeel
%_bindir/qemu-mips
%_bindir/qemu-mipsel
%_bindir/qemu-mipsn32
%_bindir/qemu-mipsn32el
%_bindir/qemu-mips64
%_bindir/qemu-mips64el
%_bindir/qemu-or32
%_bindir/qemu-ppc64abi32
%_bindir/qemu-ppc64
%_bindir/qemu-ppc64le
%_bindir/qemu-ppc
%_bindir/qemu-s390x
%_bindir/qemu-sh4
%_bindir/qemu-sh4eb
%_bindir/qemu-sparc32plus
%_bindir/qemu-sparc64
%_bindir/qemu-sparc
%_bindir/qemu-tilegx
%_bindir/qemu-unicore32
%_bindir/qemu-x86_64
%_bindir/qemu-*-binfmt
%_sbindir/qemu-binfmt-conf.sh
%ifnarch %ix86 x86_64 ia64
%dir /emul/ia32-linux
%endif
%ifnarch %ix86 x86_64
%dir /usr/share/qemu
/usr/share/qemu/qemu-i386
%endif

%changelog
