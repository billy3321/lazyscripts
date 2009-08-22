#!/bin/bash
# -*- coding: UTF-8 -*-
# This is startup file for openSUSE

if [ -z "$LC_ALL" ] ; then
    export LC_ALL=${LANG}
    echo "export LC_ALL=\"$LANG\"" >> $ENV_EXPORT_SCRIPT
fi

echo "export DISPLAY=\"$DISPLAY\"" >> $ENV_EXPORT_SCRIPT


if [ -z "$WINDOWMANAGER" ];then
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
    case $WINDOWMANAGER in
	    '/usr/bin/gnome')
	    export WIN_MGR='Gnome'
	    echo "export WIN_MGR=\"Gnome\"" >> $ENV_EXPORT_SCRIPT
	    ;;
	    '/usr/bin/startkde')
	    export WIN_MGR='KDE'
	    echo "export WIN_MGR=\"KDE\"" >> $ENV_EXPORT_SCRIPT
	    ;;
	    '/usr/bin/startlxde')
	    export WIN_MGR='LXDE'
	    echo "export WIN_MGR=\"LXDE\"" >> $ENV_EXPORT_SCRIPT
	    ;;
	    *)
	    echo "Lazysciprs can't identified your window manager"
	    export WIN_MGR=''
	    echo "export WIN_MGR=\"\"" >> $ENV_EXPORT_SCRIPT
	    ;;
	esac
fi


if which zenity &> /dev/null ; then
    if ! zenity --question --text="Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi
elif which kdialog &> /dev/null ; then
    if ! kdialog --warningcontinuecancel "Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi 
else
    echo  "Lazyscripts will install some required packages."
fi

echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT



