#!/usr/bin/env python
# -*- encoding=utf8 -*-
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

class UnknownWindowManager(Exception): 
    def __repr__(self):
        return 'Lazyscripts can\'t distinguish your window manager.'

class UnknownDistribution(Exception):
    def __repr__(self):
        return 'Lazyscripts can\'t distinguish your Linux distribution.'


def wm_desktop_session():
    """
    Check the DESKTOP_SESSION variable to distinguish window manager.
    """
    wm_value = getenv('DESKTOP_SESSION') 
    if wm_value in ('gnome','kde','lxde','LXDE','wmaker'):
        return wm_value.lower()
    elif wm_value in ('xfce.desktop','xfce'):
        return 'xfce'
    else:
        return wm_var_check()


def wm_var_check():
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
    elif getoutput('pstree | grep WindowMaker'):
        return 'wmaker'
    else:
        from lazyscripts.gui import user_choice
        return user_choice()

def suse_windowmanager():
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
        return wm_desktop_session()

#def user_choice():
#    """
#    Use zenity and radio dialog to make user choice.
#    """
#    wm_value = getoutput('zenity --list --title="Choice your window manager" --radiolist --column "" --column "Linux Distribution Version" FALSE "Gnome" FALSE "KDE" False "LXDE" False "Xfce"')
##   Use kdialog
##   wm_value = getoutput('kdialog --list --title="Choice your window manager" --radiolist "Choice your window manager" Gnome Gnome off KDE KDE off LXDE LXDE off Xfce Xfce off')
#    if not wm_value:
#        raise UnknownWindowManager()
#    else:
#        return wm_value.lower()

def get_wminfo(distro):
    """
    return gnome|kde|lxde|xfce
    """
    if distro in ('debian','Ubuntu','fedora','centos','mandriva','mandrake','redhat','arch','LinuxMint'):
        return wm_desktop_session()
    elif distro == 'SuSE':
        return suse_windowmanager()
    elif distro == 'opensolaris':
        return wm_var_check()
    else:
        return 'unknown'

def make_guisudocmd(distro,wm,cmd,msg='""'):
    """
    return full guisudo command for running.
    """
    if distro in ('debian','Ubuntu','arch','LinuxMint','fedora'):
        if wm in ('gnome','xfce','lxde','wmaker','unknown'):
            return 'gksu --message %s "%s"' % (msg, cmd)
        elif wm == 'kde':
            if path.exists('/usr/bin/kdesudo'):
                return 'kdesudo -c "%s"' % (cmd)
            else:
                return 'kdesu -c "%s"' % (cmd)
    elif distro == 'SuSE':
        if wm == 'gnome':
            return 'gnomesu --command="%s"' % (cmd)
        elif wm == 'kde':
            return 'kdesu -c "%s"' % (cmd)
        elif wm in ('xfce','lxde'):
            return 'xdg-su -c "%s"' % (cmd)
    elif distro in ('mandrake','mandriva','opensolaris','redhat','centos'):
        return 'gksu --message %s "%s"' % (msg, cmd)
    else:
        raise UnknownDistribution()




#END
