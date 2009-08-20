#!/bin/bash 

PLAT_NAME=`uname -i`
TOP_DIR=`pwd`
pushd /tmp
PKG_URL="http://dag.wieers.com/rpm/packages/rpmforge-release/"

case $(getconf LONG_BIT) in
     "32")
     ;;  
     "64")
     ;;  
 esac

DISTRO_VERSION=$(cat /etc/fedora-release | cut -d " " -f 3)

case $(getconf LONG_BIT) in
	"32")
	sudo yum -y install wget
	wget ${PKG_URL}rpmforge-release-0.3.6-1.el5.rf.i386.rpm
	yum -y install rpmforge-release-0.3.6-1.el5.rf.i386.rpm
	yum -y install git gksu
	;;  
	"64")
	sudo yum -y install wget
	wget ${PKG_URL}rpmforge-release-0.3.6-1.el5.rf.x86_64.rpm
	yum -y install rpmforge-release-0.3.6-1.el5.rf.x86_64.rpm
	yum -y install git gksu
	;;  
esac


popd

