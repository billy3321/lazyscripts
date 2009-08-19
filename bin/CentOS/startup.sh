#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Fedora

if [ -z "$DISTRO_VERSION" ];then
    DISTRO_VERSION=`zenity --list --title="Choice your linux distribution version" --radiolist --column "" --column "Linux Distribution Version" FALSE "Fedora 10"`
    case $DISTRO_VERSION in
        "Fedora 10")
        export DISTRO_VERSION="10"
        ;;
    esac
    echo "export DISTRO_VERSION=${DISTRO_VERSION}" >> $ENV_EXPORT_SCRIPT
fi
WIN_MGR=`zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE"`
export WIN_MGR=${WIN_MGR}
echo "export WIN_MGR=${WIN_MGR}" >> $ENV_EXPORT_SCRIPT

echo "distrib/${DISTRO_ID}/install_require_packages.sh" >> $ENV_EXPORT_SCRIPT
