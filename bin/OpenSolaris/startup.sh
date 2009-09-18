#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for OpenSolaris

if [ -n "$DESKTOP_SESSION" ];then
    case ${DESKTOP_SESSION} in
	    'gnome')
	    WIN_MGR='Gnome'
	    ;;  
	    'kde')
	    WIN_MGR='KDE'
	    ;;
	    'default'|*)
	    if [ -n "$GNOME_DESKTOP_SESSION_ID" ];then
            WIN_MGR='Gnome'
        elif [ -n "$KDE_FULL_SESSION" ] ; then
	        WIN_MGR='KDE'
        else
	        echo "Lazysciprs can't identified your window manager"
	        WIN_MGR=''
        fi
	    ;;    
	esac
else
	WIN_MGR=''
fi
if [ -z "$WIN_MGR" ];then
	if which zenity &> /dev/null ; then
        WIN_MGR=$(zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE")
    elif which kdialog &> /dev/null ; then
		WIN_MGR=$(kdialog --list --title="Choice your window manager" --radiolist "Choice your window manager" Gnome Gnome off KDE KDE off )
	else
		read -p "Please input your window manager(Gnome/KDE)" WIN_MGR
		case $WIN_MGR in
			'[Gg][Nn][Oo][Mm][Ee]')
			WIN_MGR='Gnome'
		    ;;
			'[Kk][Dd][Ee]')
			WIN_MGR='KDE'
		    ;;
			'[Ll][Xx][Dd][Ee]')
			WIN_MGR='LXDE'
			;;
			'[Xx][Ff][Cc][Ee]')
			WIN_MGR='Xfce'
			;;
			*)
			echo "can't distinguish your input. Lazyscripts will exit."
			exit
			;;
		esac
	fi
fi
export WIN_MGR
echo "export WIN_MGR=\"$WIN_MGR\"" >> $ENV_EXPORT_SCRIPT

if ! zenity --question --text="Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
    exit
fi

if [ -z "$DISTRO_VERSION" ];then
    DISTRO_VERSION=$(zenity --list --title="Choice your linux distribution version" --radiolist --column "" --column "Linux Distribution Version" FALSE "OpenSolaris 2008.11" FALSE "OpenSolaris 2009.06")
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

echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT
