# Attach to tmux first so bashrc isn't run twice
alias ta="tmux attach || tmux new"

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi

# Source Facebook definitions
if [ -f ~/.fbrc ]; then
    . ~/.fbrc
fi

#
# Bash
#
export HISTSIZE=999999999
export HISTFILESIZE=9999999999
export PATH=$PATH:~/bin/

alias c="clear; tmux clear-history;"
alias r="clear; tmux clear-history; settitle bash"

# Use colors
export TERM="xterm-256color"

alias now="date +%s"


#
# Emacs
#
alias emacs='emacsclient -t'

function eclean {
  for file in $(find . | egrep "(\.#|#.*#|~$)"); do
    echo removing: $file
    rm $file
  done
}

function e {
    nargs=$#
    if [ $nargs -eq 1 ]; then
        # emacsclient -n $@
        emacsclient -t $@
    else
        emacsclient -t
    fi
}

alias remacs="killall -9 emacs;"

export EDITOR="emacsclient -t"
export ALTERNATE_EDITOR=""


#
# Tmux
#
function getwindow() {
    echo $TMUX_PANE
}

function settitle() {
  tmux rename-window -t $TMUX_PANE "$@"
  # echo -e "\033k$1\033\\"
}

function setwindowstatus() {
  tmux set-window-option -t $TMUX_PANE window-status-style "$@"
}

function tmuxcolors() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
    done
}

function settitlew() {
  window=$1
  shift
  tmux rename-window -t $window "$@"
}


#
# Grepping / Finding
#
alias grep="grep --color=auto"
alias grepc="grep --color=always"
alias less="less -R"
alias lh="ls -lh"

function grep_recursive {
    args="$@"
    grep -ri "$args"
}
function grep_recursive_here {
    args="$@"
    echo "$args"
    grep -ri "$args" .
}
alias grh=grep_recursive_here
alias gr=grep_recursive

function find_grep {
    find . | grep -v \.git | grep -i $@
}
alias gf=find_grep

# Processes
function ps_grep {
    ps -e | grep $@
}
alias gp=ps_grep

# History
function history_grep {
    history | grep -i $@
}
alias gh=history_grep


#
# Notes
#
alias todo='e ~/notes/todo.org'

function note {
    NOTES=~/notes/
    DATE=$(python <<EOF
from datetime import datetime, timedelta
today = datetime.now()
week_start = today - timedelta(days=today.weekday())
week_end = week_start + timedelta(days=7)
print(week_start.strftime('%Y-%m-%d') + "-" + week_end.strftime('%Y-%m-%d'))
EOF
)
    FILE=$NOTES/$DATE.org
    e $FILE
}

# Prompt
export PS1='$(timeout 5 prompt.py)'
