#
# spec file for package duc
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
Summary:        Duc, a library and suite of tools for inspecting disk usage
License:        MIT
URL:            http://www.chiark.greenend.org.uk/~sgtatham/agedu
Group:          System/Management
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
BuildRequires:  pango-devel cairo-devel libtokyocabinet-devel ncurses-devel

%description
Duc is a small library and a collection of tools for inspecting and visualizing
disk usage.
Duc maintains a database of accumulated sizes of directories of your file system,
and allows you to query this database with some tools,
or create fancy graphs showing you where your bytes are.

%package          devel
Summary:          Development tools for %{name}
Group:            Development/Libraries
Requires:         %{name} = %{version}-%{release}

%description devel
Duc is a small library and a collection of tools for inspecting and visualizing
disk usage.
This is devel version.


%prep
## // REV5 \\
%setup -n %{_obs_path}
## \\ REV5 //

%build
libtoolize
autoreconf --install
%configure --disable-static --with-pic
make %{?_smp_mflags}

%install
%makeinstall

%post
/sbin/ldconfig

%clean
rm -rf $RPM_BUILD_ROOT

%files 
%defattr(-,root,root)
%{_bindir}/%{name}
%{_mandir}/man1/duc.1.gz

%changelog
* Mon Jan 18 2016 Eugene Istomin 
- Initial