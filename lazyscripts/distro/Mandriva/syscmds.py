#!/usr/bin/env python
"""
Here store the command which only in Fedora
"""

detect_pack = "rpm -q "
install_cmd = "urpmi --auto "
remove_cmd = "urpme --auto "
refresh_cmd = "urpmi.update --update"
network_config = "draknetcenter"
repo_config = "drakrpm-edit-media"


if __name__ == "__main__" :
    print detect_pack
    print install_cmd
    print remove_cmd
    print refresh_cmd
    print network_config
    print repo_config

