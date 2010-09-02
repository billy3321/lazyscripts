%define name lazyscripts
%define version 0.2.3.6
%define release 1

Summary: The scripts manager in Linux.
Name: lazyscripts
Version: 0.2.3.6
Release: 1
Source: lazyscripts-0.2.3.6.tar.gz
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
Requires: python, python-setuptools, vte, wget, zenity, git-core
%if 0%{?mandriva_version} >= 2009
Requires: pygtk2.0, python-vte, 
%endif  
  
%if 0%{?centos_version} >= 501   
BuildRequires: python-devel
%endif

%if 0%{?fedora_version} >= 11  
BuildRequires: python-devel
%endif
  
%if 0%{?suse_version} > 910  
Requires: python-gtk
BuildRequires: python-devel
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

%build
python setup.py build

%install
python setup.py install --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES

%if 0%{?suse_version}
# %suse_update_desktop_file lazyscripts System SystemSetup
%endif

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf *.pyc

%files -f INSTALLED_FILES
%defattr(-,root,root)


