#!/usr/bin/env python
"""
Here store the command which only in CentOS
"""

detect_pack = "rpm -q "
install_cmd = "yum -y install "
remove_cmd = "yum -y remove "
refresh_cmd = "yum check-update"
network_config = "system-control-network"
repo_config = "python /usr/lib/python2.4/site-packages/pirut/RepoSelector.py"


if __name__ == "__main__" :
    print detect_pack
    print install_cmd
    print remove_cmd
    print refresh_cmd
    print network_config
    print repo_config

