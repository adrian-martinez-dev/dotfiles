export DEFAULT_USER="user"
export EDITOR="nvim"
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="gnzh"
# ZSH_THEME="bira"
# ZSH_THEME="nanotech"
# ZSH_THEME="fox"
#ZSH_THEME="jonathan"
#ZSH_THEME="juanghurtado"
#ZSH_THEME="mortalscumbag"
#ZSH_THEME="steeef"
#ZSH_THEME="wezm"
#ZSH_THEME="darkblood"
# ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git python tmux tmuxinator virtualenvwrapper)
plugins=(git python docker tmux tmuxinator)

source $ZSH/oh-my-zsh.sh


#El autocompletado esta roto!
#source ~/.bin/tmuxinator.zsh

#export PROJECT_HOME=$HOME/Proyectos

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# So as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon

export NO_AT_BRIDGE=1

export TERM="xterm-256color"
export PATH="$PATH:$HOME/.config/composer/vendor/bin"
# export NVIM_GTK_PREFER_DARK_THEME=1
# export NVIM_GTK_NO_HEADERBAR=1
export NVIM_QT_RUNTIME_PATH="~/neovim-qt/src/gui/runtime"
# added by Anaconda3 installer
export PATH="/home/adrian/anaconda3/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias gtypist=gtypist esp.typ

function homestead() {
    ( cd ~/Homestead && vagrant $* )
  }

prompt_dir() {
  prompt_segment white black '%2/'
}

function set-title-precmd() {
  printf "\e]2;%s\a" "${PWD/#$HOME/~}"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
export BACKEND_URL="http://127.0.0.1:8000/"
export API_URI="http://localhost:8000/graphql/" 
export API_MOUNT_URI="/dashboard/" 

export ANDROID_HOME=$HOME/Android/Sdk
if [ "$(uname 2> /dev/null)" != "Linux" ]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
fi

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export REACT_EDITOR=gedit
export REACT_TERMINAL=gnome-terminal
export HOSTNAME=$(hostname)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export COMPOSE_MENU=false
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/adrian/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

. "$HOME/.local/bin/env"

# opencode
export PATH=/home/adrian/.opencode/bin:$PATH
