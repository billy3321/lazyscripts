#!/bin/bash
#
# YUMBACK_PID=`pgrep -fl PackageKit | cut -d " " -f 1`
# if [ -z $YUMBACK_PID ]; then
#     echo "Kill yumBackend to unlock yum"
#     kill $YUMBACK_PID
# fi

if [ -f "/var/run/yum.pid" ]; then
    echo "Remove the lock file"
    kill `cat /var/run/yum.pid`
    rm -f /var/run/yum.pid
fi  

if rpm -q wget python-nose python-setuptools-devel git-core redhat-lsb &> /dev/null ; then
    echo "Require packages installed."
else
    echo "Require packages not installed."

    yum check-update
    yum -y install wget git-core python-nose python-setuptools-devel redhat-lsb

fi

if python -c "import imp;imp.find_module('git')" &> /dev/null ; then
    echo "Require module found."
else
    echo "Require module not found."
    easy_install GitPython
fi

echo "執行完畢！即將啟動Lazyscripts..."


