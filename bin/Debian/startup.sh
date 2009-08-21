#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Debian

echo "source /etc/profile" >> $ENV_EXPORT_SCRIPT

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

echo "source bin/${DISTRO_ID}/install_require_packages.sh " >> $ENV_EXPORT_SCRIPT
