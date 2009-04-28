#!/bin/bash
# -*- coding: UTF-8 -*-
# This is startup file for openSUSE

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

echo "bin/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT



