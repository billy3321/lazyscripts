#!/bin/bash
# -*- coding: UTF-8 -*-
# This is startup file for openSUSE

if [ -z "$LC_ALL" ] ; then
    export LC_ALL=${LANG}
    echo "export LC_ALL=\"$LANG\"" >> $ENV_EXPORT_SCRIPT
fi



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
	    '/usr/bin/startxfce4')
	    WIN_MGR='Xfce'
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
        WIN_MGR=$(zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE" False "LXDE" False "Xfce")
    elif which kdialog &> /dev/null ; then
		WIN_MGR=$(kdialog --list --title="Choice your window manager" --radiolist "Choice your window manager" Gnome Gnome off KDE KDE off LXDE LXDE off Xfce Xfce off)
	else
		read -p "Please input your window manager(Gnome/KDE/LXDE/Xfce)" WIN_MGR
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
    echo "export DISPLAY=\"$DISPLAY\"" >> $ENV_EXPORT_SCRIPT
    if ! kdialog --warningcontinuecancel "Lazyscripts will install some required packages. Press OK to continue and install, or Press Cancel to exit." ; then
        exit
    fi 
;;
*)
    echo  "Lazyscripts will install some required packages. "
;;
esac


echo "source bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT



