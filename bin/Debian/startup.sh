#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Debian

echo "source /etc/profile" >> $ENV_EXPORT_SCRIPT

if [ -n "$DESKTOP_SESSION" ];then
    case ${DESKTOP_SESSION} in
	    'gnome')
	    WIN_MGR='Gnome'
	    ;;  
	    'kde')
	    WIN_MGR='KDE'
	    ;;
        'LXDE')
        WIN_MGR='LXDE'
        ;;
	    'default')
	    if [ -n "$GNOME_DESKTOP_SESSION_ID" ];then
            WIN_MGR='Gnome'
        elif [ -n "$KDE_FULL_SESSION" ] ; then
	        WIN_MGR='KDE'
        elif [ -n "$_LXSESSION_PID" ] ; then
            WIN_MGR='LXDE'
        elif pstree | grep -q xfwm4 ; then
            # Maybe it's Xfce, dirty way
            WIN_MGR='Xfce'
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
        WIN_MGR=$(zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE" FALSE "LXDE" FALSE "Xfce")
    elif which kdialog &> /dev/null ; then
		WIN_MGR=$(kdialog --list --title="Choice your window manager" --radiolist "Choice your window manager" Gnome Gnome off KDE KDE off LXDE LXDE off Xfce Xfce off)
	else
		read -p "Please input your window manager(Gnome/KDE/LXDE/Xfce)" WIN_MGR
		case $WIN_MGR in
			'Gnome'|'gnome'|'GNOME')
			WIN_MGR='Gnome'
		    ;;
			'KDE'|'kde')
			WIN_MGR='KDE'
		    ;;
			'LXDE'|'Lxde'|'lxde')
			WIN_MGR='LXDE'
			;;
			'XFCE'|'Xfce'|'xfce')
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
    else 
        echo "export DISPLAY=\"$DISPLAY\"" >> $ENV_EXPORT_SCRIPT
    fi 
;;
*)
    echo  "Lazyscripts will install some required packages. "
;;
esac


echo "source bin/${DISTRO_ID}/install_require_packages.sh " >> $ENV_EXPORT_SCRIPT
