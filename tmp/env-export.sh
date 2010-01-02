#!/bin/bash
set -o xtrace
export DISTRO_CODENAME=helena
export DISTRO_VERSION=8
export DISTRO_ID=LinuxMint
export PLAT_NAME="i386"
export WIN_MGR="Gnome"
source bin/LinuxMint/install_require_packages.sh 
source devtools/devstartup.sh
export REAL_USER="billy3321"
export REAL_HOME="/home/billy3321"
export WGET="wget --tries=2 --timeout=120 -c"

./lzs $@
