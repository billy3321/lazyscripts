#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Fedora

if [ -z "$DISTRO_VERSION" ];then
    DISTRO_VERSION=`zenity --list --title="Choice your linux distribution version" --radiolist --column "" --column "Linux Distribution Version" FALSE "CentOS 5.3"`
    case $DISTRO_VERSION in
        "CentOS 5.3")
        export DISTRO_VERSION="5.3"
        ;;
    esac
    echo "export DISTRO_VERSION=${DISTRO_VERSION}" >> $ENV_EXPORT_SCRIPT
fi

if [ -z "$DESKTOP_SESSION" ];then
    WIN_MGR=`zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE"`
else
    case ${DESKTOP_SESSION} in
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
fi

echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT
