#!/usr/bin/env python

from __future__ import print_function
from __future__ import unicode_literals

import getpass
import os
import platform
import subprocess

GIT = 'git'
HG = 'hg'

colors = {
    'normal': '\033[00m',
    'red': '\033[01;31m',
    'green': '\033[01;32m',
    'yellow': '\033[01;33m',
    'magenta': '\033[01;35m',
    'blue': '\033[01;34m',
    'cyan': '\033[01;36m'
}

def color(c, s):
    return '\x01' + colors[c] + '\x02' + s + '\x01' + colors['normal'] + '\x02'
def green(s):
    return color('green', s)
def red(s):
    return color('red', s)
def blue(s):
    return color('blue', s)
def purple(s):
    return color('magenta', s)

def user():
    return getpass.getuser()

def host():
    return platform.node().split('.')[0]

def repo_info():
    path = os.getcwd()

    HG_REPOS = [
        '/data/users/mstarr/fbsource/fbcode',
        '/data/users/mstarr/configerator',
        '/data/users/mstarr/www-hg',
    ]
    for repo in HG_REPOS:
        if path.startswith(repo):
            return HG, path
    return None, None

    # Below: too slow!

    # NFS expensive => break out early
    if path.startswith('/mnt/'):
        return None, None

    while path != '/':
        if os.path.exists(os.path.join(path, '.git')):
            return GIT, path
        elif os.path.exists(os.path.join(path, '.hg')):
            return HG, path
        path = os.path.dirname(path)
    return None, None

def repo_name(path):
    return os.path.basename(path)

cwd = os.getcwd()

repo_type, repo_root = repo_info()

def cmd(argv):
    p = subprocess.Popen(
        argv,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, stderr = p.communicate()
    if p.returncode:
        raise RuntimeError(p.returncode)
    return stdout.strip()

if repo_type:
    repo_name = repo_name(repo_root)
    if cwd != repo_root:
        repo_path = os.path.relpath(cwd, repo_root)
    else:
        repo_path = ''

    if repo_type == GIT:
        try:
            branch = cmd(['git', 'symbolic-ref', '--short', 'HEAD'])
        except RuntimeError:
            branch = 'None'
    elif repo_type == HG:
        bookmark = os.path.join(repo_root, '.hg', 'bookmarks.current')
        if os.path.exists(bookmark):
            branch = open(bookmark).read().strip()
        else:
            branch = None
    else:
        branch = None
    prompt = (
        green(user() + '@' + host())
        + ' ' + blue(os.path.join(repo_name, repo_path))
        + ((' ' + red('(' + branch + ')')) if branch else '')
        + '\n'
        + purple('$ ')
    )
else:
    prompt = (
        green(user() + '@' + host())
        + ' ' + blue(cwd)
        + '\n'
        + purple('$ ')
    )
print(prompt, end='')
