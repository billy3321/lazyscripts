#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Lazyscripts

# the function use to get distribution name and version or codename.
function get_distro_info () {
if which lsb_release &> /dev/null ; then
    DISTRO_ID=$(lsb_release -is)
    DISTRO_CODENAME=$(lsb_release -cs)
    DISTRO_VERSION=$(lsb_release -rs)
    if [ "$DISTRO_ID" == "SUSE LINUX" ] ; then
        case "$DISTRO_VERSION" in
            "11.2"|"11.1"|"11.0")
                DISTRO_ID="openSUSE"
            ;;
        esac
    elif [ "$DISTRO_ID" == "MandrivaLinux" ] ; then
        DISTRO_ID="Mandriva"
    fi


elif [ -f /etc/debian_version ] ; then
    if $(grep -q ubuntu /etc/apt/sources.list) ;then
        DISTRO_ID="Ubuntu"
    else
        DISTRO_ID="Debian"
        DISTRO_VERSION=$(cat /etc/debian_version)
        case $DISTRO_VERSION in
            4.*)
                DISTRO_CODENAME='etch'
                ;;
            5.*)
                DISTRO_CODENAME='lenny'
                ;;
            6.*)
                DISTRO_CODENAME='squeeze'
                ;;
            *)
                DISTRO_CODENAME=''
                ;;
        esac
    fi    
 
elif [ -f /etc/fedora-release ] ; then
    DISTRO_ID="Fedora"
    DISTRO_CODENAME=""
    DISTRO_VERSION=$(cat /etc/fedora-release | cut -d " " -f 3)
elif test -f /etc/redhat-release && grep -q "CentOS" /etc/redhat-release ; then
    DISTRO_ID="CentOS"
    DISTRO_CODENAME=""
    DISTRO_VERSION=$(cat /etc/redhat-release | cut -d " " -f 3)
elif test -f /etc/redhat-release && grep -q "Red Hat" /etc/redhat-release ; then
    DISTRO_ID="RedHat"
    DISTRO_CODENAME=""
    DISTRO_VERSION=$(cat /etc/redhat-release | cut -d " " -f 3)
elif [ -f /etc/mandrake-release ] ; then
    DISTRO_ID="Mandriva"
    DISTRO_CODENAME=""
    DISTRO_VERSION=$(cat /etc/mandriva-release | grep release | cut -d " " -f 4)
elif [ -f /etc/arch-release ] ; then
    DISTRO_ID="Arch"
    DISTRO_CODENAME=""
    DISTRO_VERSION=$(cat /etc/mandriva-release | grep release | cut -d " " -f 4)
elif [ -f /usr/bin/pkg ] && grep -q "OpenSolaris" /etc/release ; then
    DISTRO_ID="OpenSolaris"
    DISTRO_CODENAME=""
    DISTRO_VERSION=$(cat /etc/release | grep "OpenSolaris" | cut -d " " -f 27)
else
# Let user choice by them self.
    echo "Sorry, Lazyscripts can't distinguish your Linux distribution."
    echo "Please choice your distribution in the list."
    zenity --info --text "Sorry, Lazyscripts can't distinguish your Linux distribution. Please choice your distribution in the list by your self.\n      \nNote: If you can't find your Linux distribution in the list, It means Lazyscripts not support your distribution. Please contact develpers. http://code.google.com/p/lazyscripts/"
    DISTRO_ID=`zenity --list --title="Choice your linux distribution" --radiolist --column "" --column "Linux Distribution" FALSE Fedora FALSE others`
    DISTRO_ID=${DISTRO_ID}
fi
export DISTRO_ID DISTRO_VERSION DISTRO_CODENAME
echo "export DISTRO_CODENAME=${DISTRO_CODENAME}" >> "$ENV_EXPORT_SCRIPT"
echo "export DISTRO_VERSION=${DISTRO_VERSION}" >> "$ENV_EXPORT_SCRIPT"
echo "export DISTRO_ID=${DISTRO_ID}" >> "$ENV_EXPORT_SCRIPT"
}

function get_platname() {
	case $(getconf LONG_BIT) in
	    "32")
	    export PLAT_NAME="i386"
	    echo "export PLAT_NAME=\"i386\"" >> $ENV_EXPORT_SCRIPT
	    ;;
	    "64")
	    export PLAT_NAME="x86_64"
	    echo "export PLAT_NAME=\"x86_64\"" >> $ENV_EXPORT_SCRIPT
	    ;;
	esac
}

function init_export_script () {
    mkdir -p tmp
    export ENV_EXPORT_SCRIPT="tmp/env-export.sh"
    if [ -f ${ENV_EXPORT_SCRIPT} ];then
        rm $ENV_EXPORT_SCRIPT
    fi

    touch "$ENV_EXPORT_SCRIPT"
    chmod a+x "$ENV_EXPORT_SCRIPT"
    echo "#!/bin/bash" > "$ENV_EXPORT_SCRIPT"
    echo "set -o xtrace" >> "$ENV_EXPORT_SCRIPT"
}

# the function is use to show a repository list if has more then one repository.
# store in $REPO_URL as array and $REPO_NUM as number.

# some workaround
# DIR=`dirname $0`
# cd "$DIR"

init_export_script

get_distro_info

get_platname

case "$DISTRO_ID" in
    "Ubuntu"|"Debian"|"openSUSE"|"Fedora"|"CentOS"|"OpenSolaris"|"Mandriva"|"Arch")
    source bin/${DISTRO_ID}/startup.sh
    ;;
    *)
    #else
    zenity --info --text "Sorry, Lazyscripts not support your Distribution. The program will exit"
    rm ${ENV_EXPORT_SCRIPT}
    exit
    ;;
esac

# This is a developer function use to select testing repo.
if [ ! $@ == "test-env" ];then
    echo "source devtools/devstartup.sh" >> $ENV_EXPORT_SCRIPT
fi

# get scripts from github
# REPO_URL=`cat conf/repository.conf`
# REPO_DIR="./scriptspoll/`./lzs repo sign $REPO_URL`"
# git clone "$REPO_URL" "$REPO_DIR"

# check the path of desktop dir
XDG_USER_DIRS=~/.config/user-dirs.dirs
if [ -f "$XDG_USER_DIRS" ]; then
    . ~/.config/user-dirs.dirs
fi

if [ -z "$XDG_DESKTOP_DIR" ]; then
    export DESKTOP_DIR=$HOME/Desktop

else
    export DESKTOP_DIR=$XDG_DESKTOP_DIR
fi
                                        
# Ensure there is a desktop dir, if this doesn't exist, that's a bug of ubuntu.
if [ ! -e "$DESKTOP_DIR" ]; then
    mkdir -p  "$DESKTOP_DIR"
fi
                                                        
# symlink desktop dir to ~/Desktop for compatibility
if [ "$DESKTOP_DIR" != "$HOME/Desktop"  -a  ! -e "$HOME/Desktop" ]; then
    ln -s "$DESKTOP_DIR" "$HOME/Desktop"
fi
                                                                            
# Preserve the user name
export REAL_USER="$USER"
export REAL_HOME="$HOME"
echo "export REAL_USER=\"$USER\"" >> $ENV_EXPORT_SCRIPT
echo "export REAL_HOME=\"$HOME\"" >> $ENV_EXPORT_SCRIPT
                                                                   
# wget command used to download files
export WGET="wget --tries=2 --timeout=120 -c"
echo "export WGET=\"wget --tries=2 --timeout=120 -c\"" >> $ENV_EXPORT_SCRIPT

# a blank line
echo >> $ENV_EXPORT_SCRIPT

# FIXME: export-env just using to pass envirnoment variables, please don't use any command in it.

if [ $@ == "test-env" ];then
    echo "export PS1=\"\h: \w\$\"" >> $ENV_EXPORT_SCRIPT
    echo "/bin/bash" >> $ENV_EXPORT_SCRIPT
else

    echo './lzs $@'  >> $ENV_EXPORT_SCRIPT
fi
