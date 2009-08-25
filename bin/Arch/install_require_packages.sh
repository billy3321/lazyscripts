#!/bin/bash
# -*- coding: UTF-8 -*-
#

if pacman -Qs pygtk wget python-nose setuptools vte git-core lsb-release &> /dev/null ; then
    echo "Require packages installed."
else
    echo "Require packages not installed."

    pacman -Syy
    pacman --noconfirm -S pygtk wget git-core python-nose setuptools vte lsb-release

fi

if python -c "import imp;imp.find_module('git')" &> /dev/null ; then
    echo "Require module found."
else
    echo "Require module not found."
    easy_install GitPython
fi

echo "執行完畢！即將啟動Lazyscripts..."


