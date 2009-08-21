#!/bin/bash
# -*- coding: UTF-8 -*-
#

if rpm -q pygtk2.0 python-vte zenity python-setuptools git &> /dev/null ; then
    echo "Require packages installed."
else
    echo "Require packages not installed."

    urpmi.update --update
    urpmi --auto pygtk2.0 python-vte zenity git python-setuptools

fi

if python -c "import imp;imp.find_module('git')" &> /dev/null ; then
    echo "Require module found."
else
    echo "Require module not found."
    easy_install GitPython
fi

echo "執行完畢！即將啟動Lazyscripts..."


