#!/usr/bin/env python
"""
Here store the command which only in OpenSolaris
"""

detect_pack = "pkg search -l "
install_cmd = "pkg install "
remove_cmd = "pkg uninstall "
refresh_cmd = "pkg refresh"
network_config = "network-admin"
repo_config = "packagemanager"


if __name__ == "__main__" :
    print detect_pack
    print install_cmd
    print remove_cmd
    print refresh_cmd
    print network_config
    print repo_config

