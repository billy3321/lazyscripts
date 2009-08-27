#!/usr/bin/env python
"""
Here store the command which only in Debian
"""
import os

detect_pack = "dpkg -l "
install_cmd = "apt-get -y --force-yes install "
remove_cmd = "apt-get -y --force-yes --purge remove "
refresh_cmd = "apt-get update"

if os.getenvp['WIN_MGR']:
    win_mgr = os.getenv('WIN_MGR')
else:
    win_mgr = ""

if win_mgr == 'Gnome':
    network_config = "/usr/bin/nm-connection-editor"
    repo_config = "software-properties-gtk"
elif win_mgr == 'KDE':
    network_config = "kcmshell kcm_knetworkconfmodule"
    repo_config = "kpackage"
else:
    network_config = "/usr/bin/nm-connection-editor"
    repo_config = "software-properties-gtk"



if __name__ == "__main__" :
    print detect_pack
    print remove_cmd
    print install_cmd
    print refresh_cmd
    print network_config
    print repo_config

