#!/bin/bash
# -*- coding: UTF-8 -*-
# This is a startup file for Debian

source /etc/profile >> $ENV_EXPORT_SCRIPT

echo "bin/${DISTRO_ID}/install_require_packages.sh " >> $ENV_EXPORT_SCRIPT
