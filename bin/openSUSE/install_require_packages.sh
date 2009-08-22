#!/bin/bash
# -*- coding: utf-8 -*-
# Copyright (C) 2008 林哲瑋 Zhe-Wei Lin (billy3321,雨蒼) <bill3321 -AT- gmail.com>
# Last Midified : 1 Apr 2009
# This is a simple bash shell script use to install the packages 
# which need by lazyscripts. This script is use for opensuse with
# i586 architecture.
# Please run as root.

echo "正在下載並安裝lazyscripts執行所需的套件...."

if pgrep packagekitd ; then 
    killall packagekitd 
fi

if rpm -q zenity vte python-setuptools git-core &> /dev/null ; then 
    echo "Require packages installed."
else
    echo "Require packages not installed."
	zypper ref
	zypper -n install zenity vte git-core python-setuptools 
fi
# if rpm -q python-nose &> /dev/null ; then 
#	if zypper se python-nose | grep "python-nose" &> /dev/null ; then
#	    zypper -n install python-nose
#	else
#	    case $PLAT_NAME in
#	        "i386")
#	            zypper -n install http://lazyscripts.googlecode.com/files/python-nose-lastest.i586.rpm
#	        ;;
#	        "x86_64")
#	            zypper -n install http://lazyscripts.googlecode.com/files/python-nose-lastest.x86_64.rpm
#	        ;;
#	        *)
#	            echo "抱歉，Lazyscripts並不支援 ${PLAT_NAME} 作業系統平台。"
#	        ;;
#	    esac
#	fi
#
# fi

if python -c "import imp;imp.find_module('git')" &> /dev/null ; then
    echo "Require module found."
else
    echo "Require module not found."
    case $PLAT_NAME in
        "i386")
        easy_install -d /usr/lib/python2.6/site-packages GitPython
        ;;
        "x86_64")
        easy_install -d /usr/lib64/python2.6/site-packages GitPython
        ;;
        *)
        echo "sorry, not support $PLAT_NAME"
    esac
fi

echo "執行完畢！即將啟動Lazyscripts..."

#END
