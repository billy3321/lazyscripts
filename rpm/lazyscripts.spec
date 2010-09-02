%define name lazyscripts
%define version 0.2.3.6
%define release 1

Summary: The scripts manager in Linux.
Name: lazyscripts
Version: 0.2.3.6
Release: 1
Source: lazyscripts-0.2.3.6.tar.gz
License: GPLv2
Group: System
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: Hsin Yi Chen 陳信屹 (hychen) <ossug.hychen@gmail.com>
Url: http://www.lazyscripts.org
BuildRequires: python-devel
BuildRequires: python-setuptools
BuildRequires: python-distutils-extra
BuildRequires: intltool
Requires: python-setuptools, python-gtk, vte, wget, zenity, intltool, git-core

%description

Lazyscripts is just a scripts distrubtion tool and quick-installer in linux, which aims to provide a easy way to setup your working enviroment for people who need to install a new distrubution such as Debian,Ubuntu, or who want to have much better experiences in linux.

The original idea is from LazyBuntu, made by PCman in Taiwan. we usually need the script to customize to get somthing better, but theses customization may very hard to end users who new to linux, even the experienced end users. so that is why the lazyscript project starts.


%prep
%setup -q -n %{name}-%{version}

%build
python setup.py build

%install
python setup.py install --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES

%clean
rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)

