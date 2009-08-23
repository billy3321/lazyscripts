#!/usr/bin/env python
"""
Here store the command which only in Ubuntu
"""
import os

detect_pack = "dpkg -l "
install_cmd = "apt-get -y --force-yes install "
remove_cmd = "apt-get -y --force-yes --purge remove "
refresh_cmd = "apt-get update"
network_config = "/usr/bin/nm-connection-editor"
win_mgr = ""
win_mgr = os.getenv('WIN_MGR')
if win_mgr == 'Gnome':
    repo_config = "software-properties-gtk"
elif win_mgr == 'KDE':
    repo_config = "software-properties-kde"
else:
    repo_config = "software-properties-gtk"


if __name__ == "__main__" :
    print detect_pack
    print remove_cmd
    print install_cmd
    print refresh_cmd
    print network_config
    print repo_config

