#!/usr/bin/env python
# -*- encoding=utf8 -*-
#
# Copyright © 2010 Hsin Yi Chen
#
# Lazyscripts is a free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This software is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this software; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA 02111-1307 USA
import os
import locale

from lazyscripts import config
from lazyscripts import pool
from lazyscripts import template
from lazyscripts import utils

"A directory for caching objects are generated by running lazyscript"
DEFAULT_RUNTIME_ROOT_DIR = '/tmp/lzs_root'

"A file for storaging enviroment variables before sudo"
DEFAULT_STORAGED_ENV_FILE = 'lzs_storagedenv'

#{{{def get_realhome():
def get_realhome():
    "@FIXME ugly way..."
    path = os.path.join(DEFAULT_RUNTIME_ROOT_DIR, DEFAULT_STORAGED_ENV_FILE)
    if not os.path.exists(path):    return os.getenv('HOME')
    lines = open(path, 'r').readlines()
    return ''.join(lines[2][17:]).replace('\n','')
#}}}

#{{{def get_local():
def get_local():
    loc = locale.getlocale (locale.LC_ALL)
    if loc:
        return loc[0]
    return None
#}}}

class Register:

    #{{{desc
    """ A python singleton

    the idea is from :http://code.activestate.com/recipes/52558/
    """
    #}}}

    #{{{attrs
    class __impl:
        """ Implementation of the singleton interface """

        workspace = os.path.join(get_realhome(),'.lazyscripts')

    # storage for the instance reference
    __instance = None
    #}}}

    #{{{def __init__(self):
    def __init__(self):
        """ Create singleton instance """
        # Check whether we already have an instance
        if Register.__instance is None:
            # Create and remember instance
            Register.__instance = Register.__impl()

        # Store instance reference as the only member in the handle
        self.__dict__['_Register__instance'] = Register.__instance
    #}}}

    #{{{def __getattr__(self, attr):
    def __getattr__(self, attr):
        """ Delegate access to implementation """
        return getattr(self.__instance, attr)
    #}}}

    #{{{def __setattr__(self, attr, value):
    def __setattr__(self, attr, value):
        """ Delegate access to implementation """
        return setattr(self.__instance, attr, value)
    #}}}
pass

#{{{def register_workspace(path=None):
def register_workspace(path=None):
    if path:
        Register().workspace = path

    if not os.path.isdir(Register().workspace):
        template.init_workspace(Register().workspace)
#}}}

#{{{def resource_name(query):
def resource_name(query=None):
    ret = Register().workspace
    if query:
        ret = os.path.join(ret, query)
    return ret
#}}}

#{{{def resource(query):
def resource(query):
    conf = config.Configuration(resource_name('config'))
    if query == 'config':   return conf

    if query == 'pool':
        poolpath = os.path.join(resource_name('pools'),
                            conf.get_default('pool'))
        return pool.GitScriptsPool(poolpath)
    raise Exception("QuerryError")
#}}}

#{{{def prepare_runtimeenv():
def prepare_runtimeenv():
    "prepare runtime enviroment which caches objects is generated."
    if not os.path.exists(DEFAULT_RUNTIME_ROOT_DIR):
        return os.mkdir(DEFAULT_RUNTIME_ROOT_DIR, 0755)
#}}}

#{{{def storageenv(path=None):
def storageenv(path=None):
    "Save Bash Shell enviroment variabe."
    mkexport = lambda val: "export REAL_%s=%s" % \
                    (val.upper(),os.getenv(val.upper()))
    contents = [
    '#!/bin/bash',
    mkexport('USER'),
    mkexport('HOME'),
    mkexport('LANG')
    ]
    if not path:
        path = DEFAULT_RUNTIME_ROOT_DIR
    path = os.path.join(path, 'lzs_storagedenv')
    utils.create_executablefile(path, contents)
    return path
#}}}
