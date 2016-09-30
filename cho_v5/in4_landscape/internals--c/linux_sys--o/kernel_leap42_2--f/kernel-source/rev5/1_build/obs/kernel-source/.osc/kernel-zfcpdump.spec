#
# spec file for package kernel-zfcpdump
#
# Copyright (c) 2016 SUSE LINUX Products GmbH, Nuernberg, Germany.
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


# This makes the OBS store the project cert as %_sourcedir/_projectcert.crt
# needssslcertforbuild

%define srcversion 4.4
%define patchversion 4.4.20
%define variant %{nil}
%define vanilla_only 0

%include %_sourcedir/kernel-spec-macros

%define build_flavor	zfcpdump
%define build_default	("%build_flavor" == "default")
%define build_vanilla	("%build_flavor" == "vanilla")

%if ! %build_vanilla
%define src_install_dir /usr/src/linux-%kernelrelease%variant
%else
%define src_install_dir /usr/src/linux-%kernelrelease-vanilla
%endif
%define obj_install_dir /usr/src/linux-%kernelrelease%variant-obj
%define rpm_install_dir %buildroot%obj_install_dir
%define kernel_build_dir %my_builddir/linux-%srcversion/linux-obj

%(chmod +x %_sourcedir/{guards,apply-patches,check-for-config-changes,group-source-files.pl,find-provides,find-requires,split-modules,modversions,kabi.pl,mkspec,compute-PATCHVERSION.sh,arch-symbols,log.sh,try-disable-staging-driver,compress-vmlinux.sh})

%global cpu_arch %(%_sourcedir/arch-symbols %_target_cpu)
%define cpu_arch_flavor %cpu_arch/%build_flavor

# Define some CONFIG variables as rpm macros as well. (rpm cannot handle
# defining them all at once.)
%define config_vars CONFIG_MODULES CONFIG_MODULE_SIG CONFIG_KMSG_IDS CONFIG_SPLIT_PACKAGE CONFIG_SUSE_KERNEL_SUPPORTED CONFIG_EFI_STUB
%{expand:%(eval "$(test -n "%cpu_arch_flavor" && tar -xjf %_sourcedir/config.tar.bz2 --to-stdout config/%cpu_arch_flavor)"; for config in %config_vars; do echo "%%global $config ${!config:-n}"; done)}
%define split_base (%CONFIG_SPLIT_PACKAGE == "y")
%define split_extra (%CONFIG_SPLIT_PACKAGE == "y" && %CONFIG_SUSE_KERNEL_SUPPORTED == "y")

%ifarch %ix86 x86_64
%define install_vdso 1
%else
%define install_vdso 0
%endif

Name:           kernel-zfcpdump
Summary:        The IBM System Z zfcpdump Kernel
License:        GPL-2.0
Group:          System/Kernel
Version:        4.4.20
%if 0%{?is_kotd}
Release:        <RELEASE>.g2e38f57
%else
Release:        0
%endif
Url:            http://www.kernel.org/
BuildRequires:  bc
BuildRequires:  coreutils
BuildRequires:  fdupes
%if 0%{?suse_version} > 1310
BuildRequires:  hmaccalc
%endif
BuildRequires:  libopenssl-devel
BuildRequires:  modutils
# Used to sign the kernel in the buildservice
BuildRequires:  openssl
BuildRequires:  pesign-obs-integration
# for objtool
BuildRequires:  libelf-devel
Provides:       %name = %version-%source_rel
# bnc#901925
Provides:       %name-%version-%source_rel
Provides:       %{name}_%_target_cpu = %version-%release
Provides:       multiversion(kernel)
%if %split_base
Provides:       kernel-base = %version-%source_rel
# In SLE11, kernel-$flavor complemented kernel-$flavor-base. With SLE12,
# kernel-$flavor itself contains all the needed files and kernel-$flavor-base
# is a subset that can replace kernel-$flavor in some scenarios. We need to
# obsolete the -base subpackage from SLE11, so that the base files are not
# owned by multiple packages now. The dependency is not correct wrt openSUSE
# 11.2 - 11.4, but we primarily care about the supported upgrade path.
Obsoletes:      %name-base < 3.1
%endif
# The following is copied to the -base subpackage as well
# BEGIN COMMON DEPS
Requires(pre):  coreutils awk
# For /usr/lib/module-init-tools/weak-modules2
Requires(post): suse-module-tools
# For depmod (modutils is a dependency provided by both module-init-tools and
# kmod-compat)
Requires(post): modutils
# This Requires is wrong, because the post/postun scripts have a
# test -x update-bootloader, having perl-Bootloader is not a hard requirement.
# But, there is no way to tell rpm or yast to schedule the installation
# of perl-Bootloader before kernel-binary.rpm if both are in the list of
# packages to install/update. Likewise, this is true for mkinitrd.
# Need a perl-Bootloader with /usr/lib/bootloader/bootloader_entry
Requires(post): perl-Bootloader >= 0.4.15
%if %build_vanilla
Requires(post): mkinitrd
%else
# Require a mkinitrd that can handle usbhid/hid-generic built-in (bnc#773559)
Requires(post): mkinitrd >= 2.7.1
%endif
# Install the package providing /etc/SuSE-release early enough, so that
# the grub entry has correct title (bnc#757565)
Requires(post): distribution-release
# END COMMON DEPS
# Do not install p-b and mkinitrd for the install check, the %post script is
# able to handle this
#!BuildIgnore: perl-Bootloader mkinitrd distribution-release
# Remove some packages that are installed automatically by the build system,
# but are not needed to build the kernel
#!BuildIgnore: autoconf automake gettext-runtime libtool cvs gettext-tools m4 udev insserv

%ifarch s390 s390x
%if %build_vanilla && 0%{?suse_version} < 1130
BuildRequires:  dwarfextract
%endif
%endif
%ifarch %arm
BuildRequires:  u-boot-tools
%endif

Obsoletes:      microcode_ctl

# Force bzip2 instead of lzma compression to
# 1) allow install on older dist versions, and
# 2) decrease build times (bsc#962356)
%define _binary_payload w9.bzdio
# dead network if installed on SLES10, otherwise it will work (mostly)
Conflicts:      sysfsutils < 2.0
Conflicts:      apparmor-profiles <= 2.1
Conflicts:      apparmor-parser < 2.3
# root-lvm only works with newer udevs
Conflicts:      udev < 118
Conflicts:      lvm2 < 2.02.33
# Interface to hv_kvp_daemon changed
Conflicts:      hyper-v < 4
%ifarch %ix86
Conflicts:      libc.so.6()(64bit)
%endif
Provides:       kernel = %version-%source_rel


%obsolete_rebuilds %name
Source0:        http://www.kernel.org/pub/linux/kernel/v4.x/linux-%srcversion.tar.xz
Source2:        source-post.sh
Source3:        kernel-source.rpmlintrc
Source8:        devel-pre.sh
Source9:        devel-post.sh
Source10:       preun.sh
Source11:       postun.sh
Source12:       pre.sh
Source13:       post.sh
Source14:       series.conf
Source16:       guards
Source17:       apply-patches
Source21:       config.conf
Source23:       supported.conf
Source33:       check-for-config-changes
Source35:       group-source-files.pl
Source36:       README.PATCH-POLICY.SUSE
Source37:       README.SUSE
Source38:       README.KSYMS
Source39:       config-options.changes.txt
Source40:       source-timestamp
Source44:       find-provides
Source45:       find-requires
Source46:       split-modules
Source47:       modversions
Source48:       macros.kernel-source
Source49:       kernel-module-subpackage
Source50:       kabi.pl
Source51:       mkspec
Source52:       kernel-source%variant.changes
Source53:       kernel-source.spec.in
Source54:       kernel-binary.spec.in
Source55:       kernel-syms.spec.in
Source56:       kernel-docs.spec.in
Source57:       kernel-cert-subpackage
Source58:       constraints.in
Source60:       config.sh
Source61:       compute-PATCHVERSION.sh
Source62:       old-flavors
Source63:       arch-symbols
Source64:       package-descriptions
Source65:       kernel-spec-macros
Source67:       log.sh
Source68:       host-memcpy-hack.h
Source69:       try-disable-staging-driver
Source70:       kernel-obs-build.spec.in
Source71:       kernel-obs-qa.spec.in
Source72:       compress-vmlinux.sh
Source90:       SLES-UEFI-SIGN-Certificate-2048.crt
Source100:      config.tar.bz2
Source101:      config.addon.tar.bz2
Source102:      patches.arch.tar.bz2
Source103:      patches.drivers.tar.bz2
Source104:      patches.fixes.tar.bz2
Source105:      patches.rpmify.tar.bz2
Source106:      patches.suse.tar.bz2
Source107:      patches.xen.tar.bz2
Source108:      patches.addon.tar.bz2
Source109:      patches.kernel.org.tar.bz2
Source110:      patches.apparmor.tar.bz2
Source111:      patches.rt.tar.bz2
Source112:      patches.trace.tar.bz2
Source113:      patches.kabi.tar.bz2
Source120:      kabi.tar.bz2
Source121:      sysctl.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
ExclusiveArch:  s390x
%define kmp_target_cpu %_target_cpu
%ifarch %ix86
# Only i386/default supports i586, mark other flavors' packages as i686
%if ! %build_default
BuildArch:      i686
# KMPs are always built as i586, because rpm does not allow to build
# subpackages for different architectures. Therefore, we change the
# /usr/src/linux-obj/<arch> symlink to i586.
%define kmp_target_cpu i586
%endif
%endif

# These files are found in the kernel-source package:
NoSource:       0
NoSource:       2
NoSource:       3
NoSource:       8
NoSource:       9
NoSource:       10
NoSource:       11
NoSource:       12
NoSource:       13
NoSource:       14
NoSource:       16
NoSource:       17
NoSource:       21
NoSource:       23
NoSource:       33
NoSource:       35
NoSource:       36
NoSource:       37
NoSource:       38
NoSource:       39
NoSource:       40
NoSource:       44
NoSource:       45
NoSource:       46
NoSource:       47
NoSource:       48
NoSource:       49
NoSource:       50
NoSource:       51
NoSource:       52
NoSource:       53
NoSource:       54
NoSource:       55
NoSource:       56
NoSource:       57
NoSource:       58
NoSource:       60
NoSource:       61
NoSource:       62
NoSource:       63
NoSource:       64
NoSource:       65
NoSource:       67
NoSource:       68
NoSource:       69
NoSource:       70
NoSource:       71
NoSource:       72
NoSource:       90
NoSource:       100
NoSource:       101
NoSource:       102
NoSource:       103
NoSource:       104
NoSource:       105
NoSource:       106
NoSource:       107
NoSource:       108
NoSource:       109
NoSource:       110
NoSource:       111
NoSource:       112
NoSource:       113
NoSource:       120
NoSource:       121

# The following KMPs have been integrated into the kernel package,
# grouped by the last product that contained them.
# Usage: obsolete_kmp <basename> <upper bound of shipped versions>
# Note that KMPs embed the version of the kernel built against, that's why
# the _3 suffix for 2.6.x-based KMPs
%define obsolete_kmp() Obsoletes: %1-kmp-%build_flavor <= %2 \
Provides: %1-kmp = %2 \
Provides: %1-kmp-%build_flavor = %2
# sles10 / 10.3
%obsolete_kmp iwlwifi 1.3.27_3
%obsolete_kmp ipw3945 1.2.2_3
# sled10 / 11.0
%obsolete_kmp uvcvideo r200_3
# sle11-ga
%obsolete_kmp enic 0.0.1_3
%obsolete_kmp fnic 1.0.0_3
%obsolete_kmp brocade-bfa 1.1.0.2_3
%obsolete_kmp kvm 78.2.6.30.1_3
%obsolete_kmp perfmon 2_3
%obsolete_kmp iwlagn-2-6-27 1.0_3
%obsolete_kmp msi-wmi 1.0_3
# 11.1
%obsolete_kmp quickcam 0.6.7
# sle11-sp1
%obsolete_kmp   wacom 0.8.1_3
%obsolete_kmp   btrfs 0_3
%obsolete_kmp   brocade-bna 2.1.0.0_3
%obsolete_kmp   hyper-v 0_3
%obsolete_kmp   intel-e1000e 2.2.14
%obsolete_kmp   drm 3.7_3.1
Obsoletes:      firewire <= 3.0
Provides:       firewire = 3.0
%obsolete_kmp   firewire 3.0
%obsolete_kmp   iwlagn 3.0
Obsoletes:      compat-ath9k <= 3.0
Provides:       compat-ath9k = 3.0
%obsolete_kmp   compat-ath9k 3.0
%obsolete_kmp   realtek-r8192ce_pci 2.6.0005_3
%obsolete_kmp   realtek-r8192se_pci 2.6.0019.1207.2010_3
%obsolete_kmp   rt3090 2.4.0.4_3
%obsolete_kmp   rt3592 2.4.1.1_3
%obsolete_kmp   rt5390 2.4.0.4_3
%obsolete_kmp   ath3k 1.0_3
Obsoletes:      ath3k-firmware <= 1.0
Provides:       ath3k-firmware = 1.0
%obsolete_kmp	compat-wireless 3.12
%obsolete_kmp	rts5229 1.08
%obsolete_kmp	rts_pstor 1.11
# sle12-sp1 / Leap 42.1
%obsolete_kmp	xen 4.6.1
%obsolete_kmp	compat-wireless 4.4

# Provide the exported symbols as "ksym(symbol) = hash"
%define _use_internal_dependency_generator 0
%define __find_provides %_sourcedir/find-provides %name

# Generate dependencies for KMPs defined in supported.conf
%define __find_requires %_sourcedir/find-requires %name %version-%release %my_builddir

# Will modules not listed in supported.conf abort the kernel build (0/1)?
%define supported_modules_check 0

%description
The Linux kernel for booting the zfcpdump process on IBM System Z.

This kernel should only be used by the s390-tools package. This kernel
should not be installed as a regular booting kernel.


%source_timestamp
%prep
if ! [ -e %{S:0} ]; then
    echo "The %name-%version.nosrc.rpm package does not contain the" \
	 "complete sources. Please install kernel-source-%version.src.rpm."
    exit 1
fi

SYMBOLS=
if test -e %_sourcedir/extra-symbols; then
	SYMBOLS=$(cat %_sourcedir/extra-symbols)
	echo "extra symbol(s):" $SYMBOLS
fi

# Unpack all sources and patches
%setup -q -c -T -a 0 -a 100 -a 101 -a 102 -a 103 -a 104 -a 105 -a 106 -a 107 -a 108 -a 109 -a 110 -a 111 -a 112 -a 113 -a 120 -a 121

mkdir -p %kernel_build_dir

# Generate a list of modules with their support status marking
%_sourcedir/guards --list --with-guards <%_sourcedir/supported.conf | \
awk '
	/\+external / {
		print $(NF) " external";
		next;
	}
	/^-/ {
		print $(NF) " no";
		next;
	}
	{
		print $(NF);
	}
' >%kernel_build_dir/Module.supported
for package in base ; do
	%_sourcedir/guards --default=0 "$package" \
		<%_sourcedir/supported.conf | sed 's,.*/,,; s,\.ko$,,' | \
		sort -u >%kernel_build_dir/Module."$package"
done

cd linux-%srcversion

%_sourcedir/apply-patches \
%if %{build_vanilla}
	--vanilla \
%endif
	%_sourcedir/series.conf .. $SYMBOLS

cd %kernel_build_dir

# Override the timestamp 'uname -v' reports with the source timestamp and
# the commit hash.
date=$(head -n 1 %_sourcedir/source-timestamp)
commit=$(sed -n 's/GIT Revision: //p' %_sourcedir/source-timestamp)
cat > .kernel-binary.spec.buildenv <<EOF
export KBUILD_BUILD_TIMESTAMP="$(LANG=C date -d "$date") (${commit:0:7})"
export KBUILD_VERBOSE=0
export KBUILD_SYMTYPES=1
export KBUILD_OVERRIDE=1
export KBUILD_BUILD_USER=geeko
export KBUILD_BUILD_HOST=buildhost
export HOST_EXTRACFLAGS="-include %_sourcedir/host-memcpy-hack.h"
EOF
source .kernel-binary.spec.buildenv

if [ -f %_sourcedir/localversion ] ; then
    cat %_sourcedir/localversion > localversion
fi

vanilla_base="default"
%ifarch %ix86
vanilla_base="pae"
%endif
if ! grep -q CONFIG_MMU= "%my_builddir/config/%cpu_arch_flavor"; then
cp "%my_builddir/config/%cpu_arch/$vanilla_base" .config
../scripts/kconfig/merge_config.sh -m .config \
                                   %my_builddir/config/%cpu_arch_flavor
else
cp %my_builddir/config/%cpu_arch_flavor .config
fi
if test -e %my_builddir/config.addon/%cpu_arch_flavor; then
	# FIXME: config.addon doesn't affect the %CONFIG_ macros defined at
	# the top of the specfile
	../scripts/kconfig/merge_config.sh -m .config %my_builddir/config.addon/%cpu_arch_flavor
fi
../scripts/config \
	--set-str CONFIG_LOCALVERSION -%source_rel-%build_flavor \
	--enable  CONFIG_SUSE_KERNEL \
%if 0%{?__debug_package:1}
	--enable  CONFIG_DEBUG_INFO \
	--disable  CONFIG_DEBUG_INFO_REDUCED
%else
	--disable CONFIG_DEBUG_INFO
%endif

MAKE_ARGS="$MAKE_ARGS %{?_smp_mflags} -C .. O=$PWD"
if test -e %_sourcedir/TOLERATE-UNKNOWN-NEW-CONFIG-OPTIONS; then
    yes '' | make oldconfig $MAKE_ARGS
else
    cp .config .config.orig
    make silentoldconfig $MAKE_ARGS < /dev/null
    %_sourcedir/check-for-config-changes .config.orig .config
    rm .config.orig
fi

make prepare $MAKE_ARGS
make scripts $MAKE_ARGS
krel=$(make -s kernelrelease $MAKE_ARGS)

if [ "$krel" != "%kernelrelease-%build_flavor" ]; then
    echo "Kernel release mismatch: $krel != %kernelrelease-%build_flavor" >&2
    exit 1
fi

make clean $MAKE_ARGS

rm -f source
find . ! -type d ! -name 'Module.base' ! -name 'Module.*-kmp' -printf '%%P\n' \
	> %my_builddir/obj-files

%build
cd %kernel_build_dir
source .kernel-binary.spec.buildenv

# create *.symref files in the tree
if test -e %my_builddir/kabi/%cpu_arch/symtypes-%build_flavor; then
    %_sourcedir/modversions --unpack . < $_
fi

# copy module signing certificate(s). We use the default path and trick
# certs/Makefile to not regenerate the certificate. It is done this way so
# that the kernel-source package can be rebuilt even without the certificate
mkdir -p certs
for f in %_sourcedir/*.crt; do
    if ! test -e "$f"; then
        continue
    fi
    touch certs/x509.genkey
    cat "$f" >>certs/signing_key.pem
done

MAKE_ARGS="$MAKE_ARGS %{?_smp_mflags}"

%if %CONFIG_KMSG_IDS == "y"
    chmod +x ../scripts/kmsg-doc
    MAKE_ARGS="$MAKE_ARGS D=2"
%endif

while true; do
    make all $MAKE_ARGS 2>&1 \
        | tee buildlog
    if test "${PIPESTATUS[0]}" -eq 0; then
        break
    fi
    # In the linux-next and vanilla branches, we try harder to build a
    # package.
    if test 0%vanilla_only -gt 0 &&
			%_sourcedir/try-disable-staging-driver buildlog; then
        echo "Retrying make"
    else
        exit 1
    fi
done

%install

# sign the modules, firmware and possibly the kernel in the buildservice
export BRP_PESIGN_FILES="*.ko"
%if %CONFIG_EFI_STUB == "y"
BRP_PESIGN_FILES="$BRP_PESIGN_FILES /boot/vmlinuz-%kernelrelease-%build_flavor"
%endif
%ifarch %ix86
# XXX: do not sign on x86, as the repackaging changes kernel-pae
# from i686 to i586
BRP_PESIGN_FILES=""
%endif

# get rid of /usr/lib/rpm/brp-strip-debug
# strip removes too much from the vmlinux ELF binary
export NO_BRP_STRIP_DEBUG=true
export STRIP_KEEP_SYMTAB='*/vmlinux-*'

# /lib/modules/%kernelrelease-%build_flavor/source points to the source
# directory installed by kernel-devel. The kernel-%build_flavor-devel package
# has a correct dependency on kernel-devel, but the brp check does not see
# kernel-devel during build.
export NO_BRP_STALE_LINK_ERROR=yes

cd %kernel_build_dir

mkdir -p %buildroot/boot
# (Could strip out non-public symbols.)
cp -p System.map %buildroot/boot/System.map-%kernelrelease-%build_flavor

add_vmlinux()
{
    local vmlinux=boot/vmlinux-%kernelrelease-%build_flavor

    cp vmlinux %buildroot/$vmlinux
    # make sure that find-debuginfo.sh picks it up. In the filelist, we
    # mark the file 0644 again
    chmod +x %buildroot/$vmlinux
    if test $1 == "--compressed"; then
        # avoid using the gzip -n option to make kdump happy (bnc#880848#c20)
        ts="$(head -n1 %_sourcedir/source-timestamp)"
        touch -d "$ts" %buildroot/$vmlinux
        touch %buildroot/$vmlinux.gz
%if 0%{?__debug_package:1}
        # compress the vmlinux image after find-debuginfo.sh has processed it
%global __debug_install_post %__debug_install_post \
%_sourcedir/compress-vmlinux.sh %buildroot/boot/vmlinux-%kernelrelease-%build_flavor
%else
        %_sourcedir/compress-vmlinux.sh %buildroot/$vmlinux
%endif
        ghost_vmlinux=true
    else
        ghost_vmlinux=false
    fi
}

# architecture specifics
%ifarch %ix86 x86_64
    add_vmlinux --compressed
    image=bzImage
    cp -p arch/x86/boot/$image %buildroot/boot/vmlinuz-%kernelrelease-%build_flavor
    image=vmlinuz
%endif
%ifarch ppc ppc64 ppc64le
    add_vmlinux
    image=vmlinux
%endif
%ifarch s390 s390x
    add_vmlinux --compressed
    cp -p arch/s390/boot/image %buildroot/boot/image-%kernelrelease-%build_flavor
    image=image
    if test -e arch/s390/boot/kerntypes.o; then
        cp -p arch/s390/boot/kerntypes.o %buildroot/boot/Kerntypes-%kernelrelease-%build_flavor
    elif test -x "$(which dwarfextract 2>/dev/null)"; then
	dwarfextract vmlinux %buildroot/boot/Kerntypes-%kernelrelease-%build_flavor || echo "dwarfextract failed ($?)"
    fi
%if %CONFIG_KMSG_IDS == "y"
    mkdir -p %buildroot/usr/share/man/man9
    find man -name '*.9' -exec install -m 644 -D '{}' %buildroot/usr/share/man/man9/ ';'
%endif
%endif
%ifarch %arm
    add_vmlinux --compressed
    image=zImage
    cp -p arch/arm/boot/$image %buildroot/boot/$image-%kernelrelease-%build_flavor
%endif
%ifarch aarch64
    add_vmlinux --compressed
    image=Image
    cp -p arch/arm64/boot/$image %buildroot/boot/$image-%kernelrelease-%build_flavor
%endif

if test -x /usr/lib/rpm/pesign/gen-hmac; then
	$_ -r %buildroot /boot/$image-%kernelrelease-%build_flavor
fi

# Package the compiled-in certificates as DER files in /etc/uefi/certs
# and have mokutil enroll them when the kernel is installed
certs=()
if test %CONFIG_MODULE_SIG = "y"; then
    for f in *.x509; do
            if ! test -s "$f"; then
                    continue
            fi
            h=$(openssl x509 -inform DER -fingerprint -noout -in "$f")
            test -n "$h"
            cert=/etc/uefi/certs/$(echo "$h" | \
                sed -rn 's/^SHA1 Fingerprint=//; T; s/://g; s/(.{8}).*/\1/p').crt
            if test -e %buildroot/"$cert"; then
                    continue
            fi
            mkdir -p %buildroot/etc/uefi/certs
            cp "$f" %buildroot/"$cert"
            certs=("${certs[@]}" "$cert")
    done
fi

for sub in '-base' '' '-extra'; do
    case "$sub" in
    '-base' | '') base_package=1 ;;
    *) base_package=0 ;;
    esac
    for script in preun postun pre post devel-pre devel-post; do
        if test %build_flavor = "zfcpdump"; then
            : >%my_builddir/$script$sub.sh
            continue
        fi
        sed -e "s:@KERNELRELEASE@:%kernelrelease:g" \
            -e "s:@IMAGE@:$image:g" \
            -e "s:@FLAVOR""@:%build_flavor:g" \
            -e "s:@SUBPACKAGE@:%name$sub:g" \
            -e "s:@BASE_PACKAGE@:$base_package:g" \
            -e "s:@RPM_VERSION_RELEASE@:%version-%release:g" \
            -e "s:@RPM_TARGET_CPU@:%_target_cpu:g" \
	    -e "s:@CPU_ARCH_FLAVOR@:%cpu_arch_flavor:g" \
            -e "s:@SRCVARIANT@:%variant:g" \
            %_sourcedir/$script.sh > %my_builddir/$script$sub.sh
        if test "$base_package" -eq 1 -a "${#certs[@]}" -gt 0; then
            case "$script" in
            preun | postun | post)
                # Copy the respective scriptlet from kernel-cert-subpackage
                sed "1,/^%%$script / d; /^%%[^%%]/,\$ d; s:@CERTS@:${certs[*]}:g" \
                    %_sourcedir/kernel-cert-subpackage \
                    >>"%my_builddir/$script$sub.sh"
            esac
        fi
	# Do an exit 0 at the end of each scriptlet. If the last real command
	# in the scriptlet (e.g. update-bootloader call, see bnc#809617)
	# returns an error, we do not want to amplify the damage by leaving
	# the system in an inconsistent state.
	echo "exit 0" >>"%my_builddir/$script$sub.sh"
    done
done

%if %build_vanilla
# keep this -suffix list in sync with post.sh and postun.sh
suffix=-%build_flavor
%endif
ln -s $image$suffix %buildroot/boot/$image$suffix
ln -s initrd$suffix %buildroot/boot/initrd$suffix

cp -p .config %buildroot/boot/config-%kernelrelease-%build_flavor
sysctl_file=%buildroot/boot/sysctl.conf-%kernelrelease-%build_flavor
for file in %my_builddir/sysctl/{defaults,%cpu_arch/arch-defaults,%cpu_arch_flavor}; do
	if [ -f "$file" ]; then
		cat "$file"
	fi
done | sed '1i # Generated file - do not edit.' >$sysctl_file
if [ ! -s $sysctl_file ]; then
	rm $sysctl_file
fi

%if %install_vdso
# Install the unstripped vdso's that are linked in the kernel image
make vdso_install $MAKE_ARGS INSTALL_MOD_PATH=%buildroot
rm -rf %buildroot/lib/modules/%kernelrelease-%build_flavor/vdso/.build-id
%endif

# Create a dummy initrd with roughly the size the real one will have.
# That way, YaST will know that this package requires some additional
# space in /boot.
dd if=/dev/zero of=%buildroot/boot/initrd-%kernelrelease-%build_flavor \
	bs=1024 seek=2047 count=1
# Also reserve some space for the kdump initrd
cp %buildroot/boot/initrd-%kernelrelease-%build_flavor{,-kdump}

if [ %CONFIG_MODULES = y ]; then
    mkdir -p %rpm_install_dir/%cpu_arch_flavor
    mkdir -p %buildroot/usr/src/linux-obj/%cpu_arch
    ln -s %build_flavor %buildroot/usr/src/linux-obj/%cpu_arch_flavor

    gzip -n -c9 < Module.symvers > %buildroot/boot/symvers-%kernelrelease-%build_flavor.gz

    make modules_install $MAKE_ARGS INSTALL_MOD_PATH=%buildroot

%ifarch s390 s390x
    if test -e arch/s390/boot/kerntypes.o; then
        :
    elif test -x "$(which dwarfextract 2>/dev/null)" -a \
	-f %buildroot/boot/Kerntypes-%kernelrelease-%build_flavor; then
	find %buildroot -name "*.ko" > kofiles.list
	dwarfextract %buildroot/boot/Kerntypes-%kernelrelease-%build_flavor -C kofiles.list || echo "dwarfextract failed ($?)"
    fi
%endif

    # Also put the resulting file in %rpm_install_dir/%cpu_arch/%build_flavor
    # so that kernel-devel + kernel-%build_flavor is sufficient for building
    # modules that have modversions as well.
    mkdir -p %rpm_install_dir/%cpu_arch/%build_flavor
    cp Module.symvers %rpm_install_dir/%cpu_arch/%build_flavor

    # Table of types used in exported symbols (for modversion debugging).
    %_sourcedir/modversions --pack . > %buildroot/boot/symtypes-%kernelrelease-%build_flavor
    if [ -s %buildroot/boot/symtypes-%kernelrelease-%build_flavor ]; then
	gzip -n -9 %buildroot/boot/symtypes-%kernelrelease-%build_flavor
    else
	rm -f %buildroot/boot/symtypes-%kernelrelease-%build_flavor
    fi

    # Some architecture's $(uname -m) output is different from the ARCH
    # parameter that needs to be passed to kbuild. Create symlinks from
    # $(uname -m) to the ARCH directory.
    if [ ! -e %rpm_install_dir/%kmp_target_cpu ]; then
        ln -sf %cpu_arch %rpm_install_dir/%kmp_target_cpu
        ln -sf %cpu_arch %buildroot/usr/src/linux-obj/%kmp_target_cpu
    fi

    # We were building in %my_builddir/linux-%srcversion, but the sources will
    # later be installed in /usr/src/linux-%srcversion-%source_rel. Fix up the
    # build symlink.
    rm -f %buildroot/lib/modules/%kernelrelease-%build_flavor/{source,build}
    ln -s %src_install_dir \
	%buildroot/lib/modules/%kernelrelease-%build_flavor/source
    ln -s %obj_install_dir/%cpu_arch/%build_flavor \
	%buildroot/lib/modules/%kernelrelease-%build_flavor/build

    # Abort if there are any undefined symbols
    msg="$(/sbin/depmod -F %buildroot/boot/System.map-%kernelrelease-%build_flavor \
			-b %buildroot -ae %kernelrelease-%build_flavor 2>&1)"
    if [ $? -ne 0 ] || echo "$msg" | grep  'needs unknown symbol'; then
	exit 1
    fi

%if %split_base
    %_sourcedir/split-modules -d %buildroot \
	-o %my_builddir \
	-b %kernel_build_dir \
%if %CONFIG_SUSE_KERNEL_SUPPORTED == "y"
	-e \
%endif
%if ! %supported_modules_check
	-i
%endif
%if ! %split_extra
    cat %my_builddir/unsupported-modules >>%my_builddir/main-modules
%endif

%else
    (   cd %buildroot
	find lib/modules/%kernelrelease-%build_flavor -type f -name '*.ko' -printf '/%%p\n'
    ) > %my_builddir/base-modules
%endif

    # The modules.dep file is sorted randomly which produces strange file
    # checksums. As the file is not included in the resulting RPM, it's
    # pointless to rely on its contents. Replacing by zeros to make the
    # checksums always the same for several builds of the same package.
    dd if=/dev/zero of=%buildroot/lib/modules/%kernelrelease-%build_flavor/modules.dep ibs=`stat -c%s %buildroot/lib/modules/%kernelrelease-%build_flavor/modules.dep` count=1

    res=0
    if test -e %my_builddir/kabi/%cpu_arch/symvers-%build_flavor; then
        # check for kabi changes
        %_sourcedir/kabi.pl --rules %my_builddir/kabi/severities \
            %my_builddir/kabi/%cpu_arch/symvers-%build_flavor \
            Module.symvers || res=$?
    fi
    if [ $res -ne 0 ]; then
	# %ignore_kabi_badness is defined in the Kernel:* projects in the
	# OBS to be able to build the KOTD in spite of kabi errors
	if [ 0%{?ignore_kabi_badness} -eq 0 -a \
	     ! -e %my_builddir/kabi/%cpu_arch/ignore-%build_flavor -a \
	     ! -e %_sourcedir/IGNORE-KABI-BADNESS ]; then
	    echo "Create a file IGNORE-KABI-BADNESS in the kernel-source" \
		 "directory to build this kernel even though its badness is" \
		 "higher than allowed for an official kernel."
	   exit 1
	fi
    fi

    # arch/powerpc/lib/crtsavres.o is required for building external
    # modules on powerpc
    if [ -f %kernel_build_dir/arch/powerpc/lib/crtsavres.o ]; then
	echo arch/powerpc/lib/crtsavres.o >> %my_builddir/obj-files
    fi

    tar -cf - -T %my_builddir/obj-files | \
	tar -xf - -C %rpm_install_dir/%cpu_arch_flavor
    # bnc#507084
    find %rpm_install_dir/%cpu_arch_flavor/scripts -type f -perm -111 | \
        while read f; do
            case "$(file -b "$f")" in
            ELF\ *\ executable*)
                strip "$f"
            esac
        done
    # Recreate the generated Makefile with correct path
    sh ../scripts/mkmakefile ../../../%{basename:%src_install_dir} \
        %rpm_install_dir/%cpu_arch_flavor \
        $(echo %srcversion | sed -r 's/^([0-9]+)\.([0-9]+).*/\1 \2/')
fi

add_dirs_to_filelist() {
    sed -rn '
        # print file name
        p
        # remove filelist macros
        s:%%[a-z]+(\([^)]+\))? ?::g
        # add %%dir prefix
        s:^:%%dir :
        # print all parents
        :a
            # skip directories owned by other packages
            s:^%%dir (/boot|/etc|/lib/(modules|firmware)|/usr/src)/[^/]+$::
            s:/[^/]+$::p
        ta
    ' "$@" | sort -u
}

# Collect the file lists.
shopt -s nullglob dotglob
> %my_builddir/kernel-devel.files
for file in %buildroot/boot/symtypes* %buildroot/lib/modules/*/{build,source}; do
	f=${file##%buildroot}
	echo "$f"
done | add_dirs_to_filelist >%my_builddir/kernel-devel.files

{   cd %buildroot
    for f in boot/*; do
        if test -L "$f"; then
            echo "%%ghost /$f"
            continue
        elif test ! -f "$f"; then
            continue
        fi
        case "$f" in
        boot/initrd-*)
            echo "%%ghost /$f"
            continue
            ;;
        boot/vmlinux-*.gz)
            ;;
        boot/vmlinux-*)
            if $ghost_vmlinux; then
                echo "%%ghost /$f"
                continue
            fi
            ;;
        boot/symtypes*)
            continue
            ;;
        esac
        echo "%%attr(0644, root, root) /$f"
    done

    if [ %CONFIG_MODULES = y ]; then
	find lib/modules/%kernelrelease-%build_flavor \
	    -type d -o \
	    \( -path '*/modules.*' ! -path '*/modules.order' \
	     ! -path '*/modules.builtin' \) -printf '%%%%ghost /%%p\n' \
	       -o -name '*.ko' -prune -o -type f -printf '/%%p\n'
	cat %my_builddir/base-modules
    fi
    if test %CONFIG_MODULE_SIG = "y" -a -d etc/uefi/certs; then
        find etc/uefi/certs -type f -printf '/%%p\n'
    fi
    if test -d lib/firmware/%kernelrelease-%build_flavor; then
%if %split_base
        echo "%%dir /lib/firmware/%kernelrelease-%build_flavor"
        cat %my_builddir/base-firmware
%else
        echo "/lib/firmware/%kernelrelease-%build_flavor"
%endif
    fi
    if [ -e .%_docdir/%name ]; then
	echo "%%doc %_docdir/%name"
    fi
} | sort -u | add_dirs_to_filelist >%my_builddir/kernel-base.files

%if %split_base
{
    add_dirs_to_filelist %my_builddir/{kernel-base.files,main-modules}
    if test -d %buildroot/lib/firmware/%kernelrelease-%build_flavor; then
	echo "/lib/firmware/%kernelrelease-%build_flavor"
    fi
} > %my_builddir/kernel-main.files
%endif
%if %split_extra
    add_dirs_to_filelist %my_builddir/unsupported-modules > %my_builddir/kernel-extra.files
%endif
for f in %my_builddir/*-kmp-modules; do
	f2=${f%%-modules}.files
	add_dirs_to_filelist "$f" >"$f2"
done


# Hardlink duplicate files automatically (from package fdupes): It doesn't save
# much, but it keeps rpmlint from breaking the package build. Note that we skip
# /usr/src/linux-obj intentionally, to not accidentally break timestamps there
%fdupes $RPM_BUILD_ROOT/lib

%preun -f preun.sh

%postun -f postun.sh

%pre -f pre.sh

%post -f post.sh

%if %split_base

%files -f kernel-main.files
%defattr(-, root, root)
%else

%files -f kernel-base.files
%defattr(-, root, root)
%endif

%package base
Summary:        The IBM System Z zfcpdump Kernel - base modules
Group:          System/Kernel
Url:            http://www.kernel.org/
Provides:       kernel-base = %version-%source_rel
Provides:       multiversion(kernel)
Conflicts:      %name = %version-%release
Requires(pre):  coreutils awk
# For /usr/lib/module-init-tools/weak-modules2
Requires(post): suse-module-tools
# For depmod (modutils is a dependency provided by both module-init-tools and
# kmod-compat)
Requires(post): modutils
# This Requires is wrong, because the post/postun scripts have a
# test -x update-bootloader, having perl-Bootloader is not a hard requirement.
# But, there is no way to tell rpm or yast to schedule the installation
# of perl-Bootloader before kernel-binary.rpm if both are in the list of
# packages to install/update. Likewise, this is true for mkinitrd.
# Need a perl-Bootloader with /usr/lib/bootloader/bootloader_entry
Requires(post): perl-Bootloader >= 0.4.15
%if %build_vanilla
Requires(post): mkinitrd
%else
# Require a mkinitrd that can handle usbhid/hid-generic built-in (bnc#773559)
Requires(post): mkinitrd >= 2.7.1
%endif
# Install the package providing /etc/SuSE-release early enough, so that
# the grub entry has correct title (bnc#757565)
Requires(post): distribution-release


%obsolete_rebuilds %name-base
%ifarch %ix86
Conflicts:      libc.so.6()(64bit)
%endif

%description base
The Linux kernel for booting the zfcpdump process on IBM System Z.

This kernel should only be used by the s390-tools package. This kernel
should not be installed as a regular booting kernel.

This package contains only the base modules, required in all installs.


%source_timestamp
%preun base -f preun-base.sh

%postun base -f postun-base.sh

%pre base -f pre-base.sh

%post base -f post-base.sh

%if %split_base

%files base -f kernel-base.files
%defattr(-, root, root)
%endif

%package extra
Summary:        The IBM System Z zfcpdump Kernel - Unsupported kernel modules
Group:          System/Kernel
Url:            http://www.kernel.org/
Provides:       %name-extra_%_target_cpu = %version-%release
Provides:       kernel-extra = %version-%source_rel
Provides:       multiversion(kernel)
Requires:       %{name}_%_target_cpu = %version-%release
Requires(pre):  coreutils awk
Requires(post): modutils
Requires(post): perl-Bootloader
Requires(post): mkinitrd

%obsolete_rebuilds %name-extra
Supplements:    packageand(product(SUSE_SLED):%{name}_%_target_cpu)
%ifarch %ix86
Conflicts:      libc.so.6()(64bit)
%endif

%description extra
The Linux kernel for booting the zfcpdump process on IBM System Z.

This kernel should only be used by the s390-tools package. This kernel
should not be installed as a regular booting kernel.

This package contains additional modules not supported by Novell.


%source_timestamp
%preun extra -f preun-extra.sh

%postun extra -f postun-extra.sh

%pre extra -f pre-extra.sh

%post extra -f post-extra.sh

%if %split_extra

%files extra -f kernel-extra.files
%defattr(-, root, root)
%endif

%if %CONFIG_KMSG_IDS == "y"

%package man
Summary:        The collection of man pages generated by the kmsg script
Group:          System/Kernel

%description man
This package includes the man pages that have been generated from the
kmsg message documentation comments.


%source_timestamp
%files man
%defattr(-,root,root)
/usr/share/man/man9/*
%endif

%package devel
Summary:        Development files necessary for building kernel modules
Group:          Development/Sources
Provides:       %name-devel = %version-%source_rel
Provides:       multiversion(kernel)
%if ! %build_vanilla
Requires:       kernel-devel%variant = %version-%source_rel
Recommends:	make
Recommends:	gcc
Recommends:	perl
Supplements:    packageand(%name:kernel-devel%variant)
%else
Requires:       kernel-source-vanilla = %version-%source_rel
Supplements:    packageand(%name:kernel-source-vanilla)
%endif

%obsolete_rebuilds %name-devel
PreReq:         coreutils

%description devel
This package contains files necessary for building kernel modules (and
kernel module packages) against the %build_flavor flavor of the kernel.


%source_timestamp
%if %CONFIG_MODULES == "y"

%pre devel -f devel-pre.sh

%post devel -f devel-post.sh

%files devel -f kernel-devel.files
%defattr(-,root,root)
%dir %obj_install_dir
%dir %obj_install_dir/%cpu_arch
%dir /usr/src/linux-obj
%dir /usr/src/linux-obj/%cpu_arch
%ghost /usr/src/linux-obj/%cpu_arch_flavor
%obj_install_dir/%cpu_arch_flavor
%if %kmp_target_cpu != %cpu_arch
%obj_install_dir/%kmp_target_cpu
/usr/src/linux-obj/%kmp_target_cpu
%endif
%endif

%if %CONFIG_MODULES == "y" && %CONFIG_SUSE_KERNEL_SUPPORTED == "y"
%package kgraft
Summary:        Metapackage to pull in matching kgraft-patch package
Group:          System/Kernel
Requires:       kgraft-patch-%(echo %version-%source_rel | sed 'y/\./_/')-%build_flavor
Provides:       multiversion(kernel)

%description kgraft
This is a metapackage that pulls in the matching kgraft-patch package for a
given kernel version. The advantage of the metapackage is that its name is
static, unlike the kgraft-patch-<kernel-version>-flavor package names.

%files kgraft
# rpmlint complains about empty packages, so lets own something
%defattr(-, root, root)
%dir /lib/modules/%kernelrelease-%build_flavor
%endif

%if %split_base

%endif

%changelog
