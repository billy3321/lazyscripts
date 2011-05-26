#!/usr/bin/env python
# -*- encoding=utf-8 -*-
#
# Copyright © 2010 Zhe-Wei Lin
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

from os import getenv, path
from commands import getoutput
from lazyscripts import distro

class UnknownWindowManager(Exception):
    def __str__(self):
        return 'Lazyscripts can\'t distinguish your window manager.'

class UnknownDistribution(Exception):
    def __str__(self):
        return 'Lazyscripts can\'t distinguish your Linux distribution.'

class WindowManager(object):
    def __init__(self, dist=None):
        if not dist:
            dist = distro.Distribution().name
        self.distro = dist
        if self.is_under_X():
            self.name = self.get_wminfo()
            if self.distro == 'ubuntu' and \
               distro.Distribution().version == '11.04' and \
               self.name == 'gnome':
                self.unity_check()

            self.version = self.get_version()
        else:
            self.name = 'console'
            self.version = None

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.__str__()

    def wm_desktop_session(self):
        """
        Check the DESKTOP_SESSION variable to distinguish window manager.
        """
        wm_value = getenv('DESKTOP_SESSION')
        if wm_value in ('gnome','kde','lxde','LXDE','wmaker'):
            return wm_value.lower()
        elif wm_value in ('xfce.desktop','xfce'):
            return 'xfce'
        else:
            return self.wm_var_check()


    def wm_var_check(self):
        """
        Check the existence of window manager unique variable.
        """
        if getenv('GNOME_DESKTOP_SESSION_ID'):
            return 'gnome'
        elif getenv('KDE_FULL_SESSION'):
            return 'kde'
        elif getenv('_LXSESSION_PID'):
            return 'lxde'
        elif getoutput('pstree | grep xfwm4'):
            return 'xfce'
        elif getenv('DESKTOP') == 'Enlightenment-0.17.0' or getoutput('pstree | grep enlightenment'):
            return 'enlightenment'
        elif getoutput('pstree | grep WindowMaker') or getoutput ('pstree | grep wmaker'):
            return 'wmaker'
        elif getoutput('pstree | grep fluxbox'):
            return 'fluxbox'
        elif getoutput('pstree | grep blackbox'):
            return 'blackbox'
        elif getoutput('pstree | grep wmii'):
            return 'wmii'
        elif getoutput('pstree | grep fvwm2'):
            return 'fvwm2'
        elif getoutput('pstree | grep icewm'):
            return 'icewm'
        elif getoutput('pstree | grep twm'):
            return 'twm'
        elif getoutput('pstree | grep jwm'):
            return 'jwm'
        else:
            from lazyscripts.gui.gtklib import user_choice
            return user_choice()

    def suse_windowmanager(self):
        """
        Check the WINDOWMANAGER enviroment variable to distinguish window manager.
        WINDOWMANAGER variable only exist in SuSE Linux.
        """
        wm_value = getenv('WINDOWMANAGER')
        if wm_value == '/usr/bin/gnome':
            return 'gnome'
        elif wm_value == '/usr/bin/startkde':
            return 'kde'
        elif wm_value == '/usr/bin/startxfce4':
            return 'xfce'
        else:
            return self.wm_desktop_session()

    def get_wminfo(self):
        """
        return gnome|kde|lxde|xfce
        """
        if self.distro in ('debian','ubuntu','fedora','centos','mandriva','mandrake','redhat','arch','linuxmint','pclinuxos','gos','gentoo','sabayon','redflag','turbolinux'):
            return self.wm_desktop_session()
        elif self.distro in ('opensuse','suse'):
            return self.suse_windowmanager()
        elif self.distro == 'opensolaris':
            return self.wm_var_check()
        else:
            return None 

    def make_guisudocmd(self, cmd, msg='""'):
        """
        return full guisudo command for running.
        """
        if self.distro in ('debian','ubuntu','arch','linuxmint','fedora','pclinuxos','gos','gentoo','sabayon','redflag','turbolinux'):
            if self.name in ('gnome','xfce','lxde','wmaker','enlightenment','unknown'):
                return 'gksu --message %s "%s"' % (msg, cmd)
            elif self.name == 'kde':
                if path.exists('/usr/bin/kdesudo'):
                    return 'kdesudo -d -c "%s"' % (cmd)
                else:
                    return 'kdesu -d -c "%s"' % (cmd)
        elif self.distro in ('opensuse','suse'):
            if self.name == 'gnome':
                return 'gnomesu --command="%s"' % (cmd)
            elif self.name == 'kde':
                return 'kdesu -d -c "%s"' % (cmd)
            elif self.name in ('xfce','lxde'):
                return 'xdg-su -c "%s"' % (cmd)
        elif self.distro in ('mandrake','mandriva','opensolaris','redhat','centos'):
            return 'gksu --message %s "%s"' % (msg, cmd)
        elif self.distro in ('slackware'):
            return 'kdesu -c "%s"' % (cmd)
        else:
            raise UnknownDistribution()

    def get_version(self):
        if self.name in ('gnome', 'unity'):
            return self.get_gnome_version()
        elif self.name in ('kde'):
            return self.get_kde_version()
        else:
            return 'unknown'

    def get_gnome_version(self):
        ver = getoutput('gnome-session --version').split()[1]
        main_ver = ver.split('.')[0]
        return main_ver

    def get_kde_version(self):
        ver = getenv('KDE_SESSION_VERSION')
        return ver

    def unity_check(self):
        session = getenv('DESKTOP_SESSION').lower()
        if session in ('gnome', 'unity-2d'):
            self.name = 'unity'
        elif session in ('gnome-2d', 'gnome-classic'):
            self.name = 'gnome'
        elif session in ('kde-plasma'):
            self.name = 'kde'

    def is_under_X(self):
        display = getenv('DISPLAY')
        if display:
            return True
        else:
            return False


#END
