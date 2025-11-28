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

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"

# Tmux with italics support
#alias tmux="env TERM=xterm-it tmux -2"
export TERM="xterm-256color"
alias nv="mux dev"

export EDITOR='nvim'

# Auto rename window title on ssh logins
#ssh() {
  #tmux rename-window "$*"
  #command ssh "$@"
  #echo "Counting to 60"
  #sleep 60 && exit
  #tmux rename-window "bash (exited ssh)"
#}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export VAGRANT_DEFAULT_PROVIDER=virtualbox

function homestead() {
    ( cd ~/.homestead && vagrant $* )
}

export PATH="/home/adrian/.opencode/bin:$PATH"
