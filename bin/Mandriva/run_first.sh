#!/bin/bash 
# -*- coding: UTF-8 -*-

PLAT_NAME=`uname -i`
TOP_DIR=`pwd`
pushd /tmp
PKG_URL="http://dag.wieers.com/rpm/packages/rpmforge-release/"

DISTRO_VERSION=$(cat /etc/fedora-release | cut -d " " -f 3)

if [ $USER = "root" ]; then
case $(getconf LONG_BIT) in
	"32")
    PKG_URL="http://ftp.isu.edu.tw/pub/Linux/Mandriva/official/2009.0/i586/media/contrib/release/"
    for PKG_NAME in "libgksu2.0_0-2.0.7-1mdv2009.0.i586.rpm" "gksu-2.0.0-6mdv2009.0.i586.rpm" ; do
        if [ -f $PKG_NAME ];then
            rm -rf $PKG_NAME
        fi
	    wget ${PKG_URL}${PKG_NAME}
	    urpmi --auto ${PKG_NAME}
    done
	;;  
	"64")
    PKG_URL="http://ftp.isu.edu.tw/pub/Linux/Mandriva/official/2009.0/x86_64/media/contrib/release/"
    for PKG_NAME in "libgksu2.0_0-2.0.7-1mdv2009.0.x86_64.rpm" "gksu-2.0.0-6mdv2009.0.x86_64.rpm" ; do
        if [ -f $PKG_NAME ];then
            rm -rf $PKG_NAME
        fi
	    wget ${PKG_URL}${PKG_NAME}
	    urpmi --auto ${PKG_NAME}
    done
	;;  
esac
else
    echo "Please run as root."
fi


popd

