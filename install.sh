#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function do_link() {
  src=$1
  dst=$2

  if [ ! -e $dst ]; then
    echo "linking: $2 -> $1"
    ln -s $src $dst
  else
    echo "warning: $2 already exists"
  fi
}

mkdir -p ~/bin/
mkdir -p ~/notes/

do_link $DIR/.bash_profile ~/.bash_profile
do_link $DIR/.bashrc ~/.bashrc
do_link $DIR/.tmux.conf ~/.tmux.conf
do_link $DIR/.config ~/.config
do_link $DIR/.emacs.d ~/.emacs.d
do_link $DIR/bin/prompt.py ~/bin/prompt.py
