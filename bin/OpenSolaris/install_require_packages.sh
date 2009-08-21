#!/bin/bash
#

UNINST_PKG=""
for EACH_PKG in SUNWwget SUNWgit SUNWpython-setuptools
do
    if ! pkg search -l ${EACH_PKG} &> /dev/null ; then
        UNINST_PKG="${UNINST_PKG} ${EACH_PKG}"
    fi
done


if  [ -z $UNINST_PKG ] ; then
    echo "Require packages installed."
else
    echo "Require packages not installed."

    pkg refresh
    pkg install ${UNINST_PKG}

fi

if python -c "import imp;imp.find_module('git')" &> /dev/null ; then
    echo "Require module found."
else
    echo "Require module not found."
    easy_install GitPython
fi

echo "執行完畢！即將啟動Lazyscripts..."


