#!/bin/bash
# -*- coding: UTF-8 -*-
#

if rpm -q python-vte zenity python-setuptools git-core &> /dev/null ; then
    echo "Require packages installed."
else
    echo "Require packages not installed."

    urpmi.update --update
    urpmi --auto python-vte zenity git-core python-setuptools

fi

if python -c "import imp;imp.find_module('git')" &> /dev/null ; then
    echo "Require module found."
else
    echo "Require module not found."
    easy_install GitPython
fi

echo "執行完畢！即將啟動Lazyscripts..."


