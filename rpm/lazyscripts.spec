%define name lazyscripts
%define version 0.2.3.9
%define release 1

Summary: The scripts manager in Linux.
Name: lazyscripts
Version: 0.2.3.9
Release: 1
Source: lazyscripts-0.2.3.9.tar.gz
Source1: lazyscripts.desktop
Patch0: desktop.diff
Patch1: desktop.in.diff
License: GPLv2
Group: System/Management
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: Hsin Yi Chen 陳信屹 (hychen) <ossug.hychen@gmail.com>
Url: http://www.lazyscripts.org
BuildRequires: rpm >= 4.0-1
BuildRequires: python-setuptools
BuildRequires: python-distutils-extra
BuildRequires: intltool
%if 0%{?suse_version}
BuildRequires: update-desktop-files
BuildRequires: -post-build-checks -rpmlint-Factory -brp-check-suse -rpmlint-mini
%endif
Requires: python, python-setuptools, vte, wget, zenity, git-core
%if 0%{?mandriva_version} >= 2009
Requires: pygtk2.0, python-vte, 
%endif  
  
%if 0%{?centos_version} >= 501
Requires: pygtk2 
BuildRequires: python-devel
%endif

%if 0%{?fedora_version} >= 11
Requires: pygtk2  
BuildRequires: python-devel
%endif
  
%if 0%{?suse_version} > 910  
Requires: python-gtk
BuildRequires: python-devel
%endif  

%if 0%{?suse_version} > 1130  
Requires: python-vte
%endif

%description

Lazyscripts is just a scripts distrubtion tool and quick-installer in linux, 
which aims to provide a easy way to setup your working enviroment for 
people who need to install a new distrubution such as Debian,Ubuntu, 
openSUSE, or who want to have much better experiences in linux.

The original idea is from LazyBuntu, made by PCman in Taiwan. we usually 
need the script to customize to get somthing better, but theses customization 
may very hard to end users who new to linux, even the experienced end users. 
So that is why the Lazyscripts project starts.


%prep
%setup -n %{name}-%{version}
%patch0
%patch1
%build
python setup.py build
%install
python setup.py install --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES --prefix=/usr
%__install -D -m0644 "%{SOURCE1}" "%{buildroot}%{_datadir}/applications/%{name}.desktop"

%if 0%{?suse_version}
%suse_update_desktop_file lazyscripts System SystemSetup
%endif

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf *.pyc

%files -f INSTALLED_FILES
%defattr(-,root,root)
%doc README ChangeLog COPYING docs

