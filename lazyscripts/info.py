#!/usr/bin/env python
# -*- encoding=utf8 -*-
# @author '2009 Hsin Yi Chen (陳信屹) <ossug.hychen@gmail.com>'
from commands import getoutput
import os

def get_distro():
    """
    get distrobution name and version code.

    @return tuple (distrobution name, distrobution version code)
    """
    if os.path.isfile('/usr/bin/lsb_release') or os.path.isfile('/bin/lsb_release'):
        cmd = 'lsb_release'
        name = getoutput(cmd+' -is')
        if name in ('Debian','Ubuntu') :
            code = getoutput(cmd+' -cs')
        else :
            code = getoutput(cmd+' -rs')
    
        if name == 'SUSE LINUX' and code in ('11.0','11.1','11.2') :
            name = 'openSUSE'
        elif name == 'MandrivaLinux' :
            name = 'Mandriva'
    else:
        name = os.getenv('DISTRO_ID')
        code = os.getenv('DISTRO_VERSION')
    return (name,code)

def get_distro_name():
    """
    get distrobution name only.
    """
    (name, code) = get_distro()
    return name

