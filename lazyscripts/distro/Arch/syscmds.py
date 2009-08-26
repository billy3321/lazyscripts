#!/usr/bin/env python
"""
Here store the command which only in Debian
"""
import os

detect_pack = "pacman --noconfirm -Qs "
install_cmd = "pacman --noconfirm -S --needed"
remove_cmd = "pacman --noconfirm -R "
refresh_cmd = "pacman --noconfirm -Syy"

win_mgr = ""
win_mgr = os.getenv('WIN_MGR')
if win_mgr == 'Gnome':
    network_config = ""
    repo_config = ""
elif win_mgr == 'KDE':
    network_config = "systemsetting"
    repo_config = ""
else:
    network_config = ""
    repo_config = ""



if __name__ == "__main__" :
    print detect_pack
    print remove_cmd
    print install_cmd
    print refresh_cmd
    print network_config
    print repo_config

