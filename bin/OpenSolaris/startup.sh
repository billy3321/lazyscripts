#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for OpenSolaris

if [ -z "$DISTRO_VERSION" ];then
    DISTRO_VERSION=`zenity --list --title="Choice your linux distribution version" --radiolist --column "" --column "Linux Distribution Version" FALSE "OpenSolaris 2008.11" FALSE "OpenSolaris 2009.06"`
    case $DISTRO_VERSION in
        "OpenSolaris 2008.11")
        export DISTRO_VERSION="2008.11"
        ;;
        "OpenSolaris 2009.06")
        export DISTRO_VERSION="2009.11"
        ;;
    esac
    echo "export DISTRO_VERSION=${DISTRO_VERSION}" >> $ENV_EXPORT_SCRIPT
fi

if [ -z "$DESKTOP_SESSION" ];then
	if which zenity &> /dev/null ; then
        WIN_MGR=$(zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE")
		export WIN_MGR
		echo "export WIN_MGR=\"$WIN_MGR\""
    elif which kdialog &> /dev/null ; then
		WIN_MGR=$(kdialog --list --title="Choice your window manager" --radiolist "Choice your window manager" Gnome Gnome off KDE KDE off )
		export WIN_MGR
		echo "export WIN_MGR=\"$WIN_MGR\""
	else
		read -p "Please input your window manager(Gnome/KDE)" WIN_MGR
		case $WIN_MGR in
			'Gnome'|'gnome'|'GNOME')
			export WIN_MGR='Gnome'
			echo "export WIN_MGR=\"Gnome\"" >> $ENV_EXPORT_SCRIPT
		    ;;
			'KDE'|'kde')
			export WIN_MGR='KDE'
		    echo "export WIN_MGR=\"KDE\"" >> $ENV_EXPORT_SCRIPT
		    ;;
			*)
			echo "can't distinguish your input.Lazyscripts will exit"
			exit
			;;
		esac
	fi
else
    case ${DESKTOP_SESSION} in
	    'gnome')
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

if ! zenity --question --text="Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
    exit
fi

echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT
