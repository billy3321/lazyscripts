#!/usr/bin/env python
"""
Here store the command which only in Fedora
"""

detect_pack = "rpm -q "
install_cmd = "yum -y install "
remove_cmd = "yum -y remove "
refresh_cmd = "yum check-update"
network_config = ""
repo_config = ""


if __name__ == "__main__" :
    print detect_pack
    print install_cmd
    print remove_cmd
    print refresh_cmd
    print network_config
    print repo_config

