#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Debian


case $DESKTOP_SESSION in
    'default')
    export WIN_MGR='Gnome'
    echo "export WIN_MGR=\"Gnome\"" >> $ENV_EXPORT_SCRIPT
    ;;  
    'kde')
    export WIN_MGR='KDE'
    echo "export WIN_MGR=\"KDE\"" >> $ENV_EXPORT_SCRIPT
    ;;    
    *)  
    echo "Lazysciprs can't identified your window manager"
    export WIN_MGR=''
    echo "export WIN_MGR=\"\"" >> $ENV_EXPORT_SCRIPT
    ;;  
esac

if which zenity &> /dev/null ; then
    if ! zenity --question "Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi
elif which kdialog &> /dev/null ; then
    if ! kdialog --warningcontinuecancel "Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi 
else
    echo  "Lazyscripts will install some required packages."
fi

echo "source bin/${DISTRO_ID}/install_require_packages.sh " >> $ENV_EXPORT_SCRIPT

