#!/bin/bash 

PLAT_NAME=`uname -i`
TOP_DIR=`pwd`
pushd /tmp

#if rpm -q wget &> /dev/null ; then
#    echo "wget has been installed"
#else
#    yum check-update
#    yum -y install wget
#fi

#case $PLAT_NAME in
#    "x86_64"|"i386")
#    wget http://lazyscripts.googlecode.com/files/libgksu-lastest.${PLAT_NAME}.rpm
#    wget http://lazyscripts.googlecode.com/files/gksu-lastest.${PLAT_NAME}.rpm
#    yum -y --nogpgcheck localinstall libgksu-lastest.${PLAT_NAME}.rpm gksu-lastest.${PLAT_NAME}.rpm
#    rpm -Uvh --force libgksu-lastest.${PLAT_NAME}.rpm 
#    rpm -Uvh --force gksu-lastest.${PLAT_NAME}.rpm
#    if $PLAT_NAME == "x86_64" ; then
#        if [ ! -f /usr/lib/libgksu/gksu-run-helper ]; then
#            mkdir /usr/lib/libgksu/
#            ln -s /usr/lib64/libgksu/gksu-run-helpr /usr/lib/libgksu/gksu-run-helper
#        fi
#    fi
#    ;;
#    *)
#    echo "Lazyscripts not support $PLAT_NAME"
#    ;;
#esac

popd

