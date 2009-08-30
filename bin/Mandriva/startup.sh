#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Mandriva

echo "source ~/.bashrc" >> $ENV_EXPORT_SCRIPT

if [ -n "$DESKTOP_SESSION" ];then
    case ${DESKTOP_SESSION} in
	    '02GNOME')
	    WIN_MGR='Gnome'
	    ;;  
	    '01KDE4')
	    WIN_MGR='KDE'
	    ;;
	    'default')
	    if [ -n "$GNOME_DESKTOP_SESSION_ID" ];then
            WIN_MGR='Gnome'
        elif [ -n "$KDE_FULL_SESSION" ] ; then
	        WIN_MGR='KDE'
        else
	        echo "Lazysciprs can't identified your window manager"
	        WIN_MGR=''
        fi
	    ;;    
	    *)  
	    echo "Lazysciprs can't identified your window manager"
	    WIN_MGR=''
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

case $WIN_MGR in
'Gnome')
    if ! zenity --question  --text="Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi
;;
'KDE')
    if ! kdialog --warningcontinuecancel "Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi 
;;
*)
    echo  "Lazyscripts will install some required packages. "
;;
esac

if [ -z "$DISTRO_VERSION" ];then
	case $WIN_MGR in
		'Gnome')
            DISTRO_VERSION=$(zenity --list --title="Choice your linux distribution version" --radiolist --column "" --column "Linux Distribution Version" FALSE "Mandriva 2009.1" )
            case $DISTRO_VERSION in
		        "Mandriva 2009.1")
		        export DISTRO_VERSION="2009.1"
		        ;;
		    esac
         ;;
         'KDE')
            DISTRO_VERSION=$(kdialog --title="Choice your linux distribution version" --radiolist "Choice your linux distribution version" 2009.1 "Mandriva 2009.1" off )
            export DISTRO_VERSION
         ;;
    esac

    echo "export DISTRO_VERSION=${DISTRO_VERSION}" >> $ENV_EXPORT_SCRIPT
fi

echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT
