# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#PS1="\n\e[30;1m\u@\h ( \e[0m\e[33;1m\w\e[0m\e[30;1m )\e[0m\e[33;33m\n$ \e[0m"


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

#[ -e /usr/bin/tracker-control ] && [ -x /usr/bin/tracker-control ] && /usr/bin/tracker-control -r > /dev/null
export MOZILLA_FIVE_HOME=/usr/lib/mozilla

# export TERM="gnome-terminal"
#PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'

export PATH=/home/adrian/npm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
export NODE_PATH=:/home/adrian/npm/lib/node_modules

source /etc/bash_completion.d/virtualenvwrapper

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# Tmux with italics support
alias tmux="env TERM=xterm-it tmux -2"

alias v="mux dev"

export EDITOR='vim'

source ~/.bin/tmuxinator.bash

. ~/.bash_prompt

# Auto rename window title on ssh logins
ssh() {
  tmux rename-window "$*"
  command ssh "$@"
  echo "Counting to 60"
  sleep 60 && exit
  tmux rename-window "bash (exited ssh)"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
