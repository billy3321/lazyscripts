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
"""Script Module.
"""

import ConfigParser
import os
import platform

from lazyscripts import utils

class DirectoryIsScriptDirError(Exception):
    "Raise exception when target direcoty is script dir already."

class ScriptNotSupportSystemLang(Exception):
    pass

#{{{def create_scriptdesc(path, name, author):
def create_scriptdesc(path, name, authors):
    tpl = "\n".join([
        "[info]",
        "name[en_US] = %s" % name,
        "desc[en_US] = long description",
        "name[zh_TW] = %s" % name,
        "desc[zh_TW] = long description",
        "",
        "license     = ",
        "maintainers = %s" % ','.join(authors),
        "authors     = %s" % ','.join(authors),
        "",
        "[attrs]",
        "hide        = False",
        "interact    = False",
        "debian      = False",
        "ubuntu      = False",
        "linuxmint   = False",
        "fedora      = False",
        "centos      = False",
        "redhat      = False",
        "arch        = False",
        "opensuse    = False",
        "mandriva    = False",
        "opensolaris = False",
        "i386        = False",
        "amd64       = False",
        "arm         = False",
        ''
    ])
    #with open(os.path.join(path,'desc.ini'),'w') as f:
    #    f.write(tpl)
    f = open(os.path.join(path,'desc.ini'),'w')
    f.write(tpl)
    f.close()
#}}}

#{{{def create_scriptpkgdesc(dir):
def create_scriptpkgdesc(dir):
    from lazyscripts.env import get_distro_name
    dir = os.path.join(dir, get_distro_name()+'_def')
    os.mkdir(dir)
    for e in ('install','remove'):
        filepath = os.path.join(dir, '%s.txt' % e)
        #with open(filepath, 'w') as f:
        #    f.write("#pkg %s list\n" % e)
        f = open(filepath, 'w')
        f.write("#pkg %s list\n" % e)
        f.close()
#}}}

#{{{def is_scriptdir(path):
def is_scriptdir(path):
    parser = ConfigParser.ConfigParser()
    parser.read(os.path.join(path,'desc.ini'))
    #@XXX check desc.ini is script desc.init, not good way here.
    if os.path.isdir(path) and \
        parser.has_section('attrs'):
            return True
    del(parser)
    return False
#}}}

class Script(object):
    #{{{desc
    """Script Data Object.

    Every script is a directory, here is a sample and file disription.

    script_dir/            - directory name is script id.
        |- debian/         - the settings of spefic distribution, here
        |   |                is Debian, you can add another directory as
        |   |                new distribution.
        |   |- source.txt  - unofficail source definitions.
        |   |- install.txt - install these packages before excuting
        |   |                       script if distribution is Debian.
        |   |- remove.txt  - remove these packages before excuting
        |                           script if distribution is Debian.
        |
        |- desc.ini        - defines information, attributes of script.
        |- options.ini     - the options be supported by this script.
        |- script          - excutable file as a script.
    """
    #}}}

    #{{{attrs
    "describe metadata of script."
    DESC_DEFFILE = 'desc.ini'

    "describe what options be supported."
    OPTS_DEFFILE = 'opts.ini'

    "describe what packages will be installed."
    INSTALL_PKGS_DEFFILE = 'install_pkgs.ini'

    "describe what packages will be removed."
    REMOVE_PKGS_DEFFILE = 'remove_pkgs.ini'

    "executeable script file name."
    EXECUTE_FILE = 'script'

    "default lang."
    lang = 'en_US'

    I18N_ATTRS = ('name','desc','warn')
    #}}}

    #{{{def __init__(self, path,lang=None):
    def __init__(self, path, lang=None):

        """
        @param str path
        @param str lang (optional)
        """
        if lang:
            self.lang = lang
        self.parser = ConfigParser.ConfigParser()
        self.parser.read(os.path.join(path, self.DESC_DEFFILE))

        self.selected = False
        self.path = path
        self.id = os.path.basename(path)
        self.category = 'root'
        self._init_info()
        self._init_attrs()
    #}}}

    #{{{def init_script(cls, path, name, author):
    @classmethod
    def init_script(cls, path, name, author, mkdir=False):
        if is_scriptdir(path):
            raise DirectoryIsScriptDirError("target direcotry is script already.")

        if mkdir:
            os.mkdir(path)

        create_scriptdesc(path, name, author)
        utils.create_executablefile(os.path.join(path, 'script'),
                                    ['# write your own script here.'])
        create_scriptpkgdesc(path)
        return cls(path)
    #}}}

    #{{{def _init_info(self):
    def _init_info(self):
        for optname in self.parser.options('info'):
            attrname = optname[0:4]

            if not optname[0:4] in self.I18N_ATTRS:
                attrname = optname
            # skip if lang of attribute value is not we wanted.
            elif optname[5:10] != self.lang.lower():  continue

            # skip if attribute has set already.
            if hasattr(self, attrname): continue

            if not attrname in ('maintainers','authors'):
                setattr(self, attrname, self.parser.get('info',optname))
            else:
                attrs = self.parser.get('info',optname).split('\n')
                if type(attrs) is list:
                    setattr(self, attrname, attrs)
                else:
                    setattr(self, attrname, attrs[0])
        if not hasattr(self, 'name') or not hasattr(self, 'desc'):
            raise ScriptNotSupportSystemLang
    #}}}

    #{{{def _init_attrs(self):
    def _init_attrs(self):
        for optname in self.parser.options('attrs'):
            setattr(self, optname, self.parser.getboolean('attrs',optname))
    #}}}

    #{{{def get_pkginfo(self):
    def get_pkginfo(self):
        def _read(query):
            from lazyscripts.env import get_distro_name
            distro = get_distro_name()
            if not distro:    return ''

            query = utils.ext_ospath_join(self.path, distro, query)
            if not os.path.isfile(query):   return []
            return [ e for e in open(query, 'r').read().split('\n') if not e.startswith('#') and e]

        ret =  {'install':_read('install.txt'),
                'remove':_read('remove.txt')}
        del(_read)
        return ret
    #}}}

    #{{{def is_avaliable(self, kwds)
    def is_avaliable(self, kwds):
        """checks script has right attributes we wanted.

        Assume there is a script such as below

            script.debian = True
            script.amd64 = True

        if we want to get debian only scripts.

            script.is_avaliable({'debian':True}) # True

        if web want to get debain only and amd64 only:

            script.is_avaliable({'debian':True, 'amd64':True})

        @param kwds
        @return Boolean
        """
        for attrname, assertval in kwds.items():
            attrname = attrname.lower()
            if not hasattr(self, attrname): return False
            if getattr(self, attrname) != assertval:    return False
        return True
    #}}}
pass
