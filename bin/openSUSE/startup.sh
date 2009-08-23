#!/bin/bash
# -*- coding: UTF-8 -*-
# This is startup file for openSUSE

if [ -z "$LC_ALL" ] ; then
    export LC_ALL=${LANG}
    echo "export LC_ALL=\"$LANG\"" >> $ENV_EXPORT_SCRIPT
fi

echo "export DISPLAY=\"$DISPLAY\"" >> $ENV_EXPORT_SCRIPT


if [ -n "$WINDOWMANAGER" ];then
	case $WINDOWMANAGER in
	    '/usr/bin/gnome')
	    WIN_MGR='Gnome'
	    ;;
	    '/usr/bin/startkde')
	    WIN_MGR='KDE'
	    ;;
	    '/usr/bin/startlxde')
	    WIN_MGR='LXDE'
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
			'Gnome'|'gnome'|'GNOME')
			WIN_MGR='Gnome'
		    ;;
			'KDE'|'kde')
			WIN_MGR='KDE'
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


echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT



