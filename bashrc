###
### This Bash configuration is intended for macOS
### It will not work without installed Homebrew: https://brew.sh
### The best way is to use the bash from Homebrew.
###

### set the PATH
export PATH=/usr/local/bin:$HOME/.pyenv/shims:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin

### check for some commands

# Node.js
if ! command -v npm &> /dev/null
then
    echo "npm not found. I install it via Homebrew"
    brew install npm
fi

# Azure CLI
if ! command -v az &> /dev/null
then
    echo "Azure CLI not found. I install it via Homebrew"
    brew install azure-cli
fi

# Emacs
if ! command -v emacs &> /dev/null
then
    echo "Emacs not found. I install it via Homebrew"
    brew install emacs
fi
export EDITOR=emacs

# Python3
if ! command -v python3 &> /dev/null
then
    echo "Python3 not found. I install it via Homebrew"
    brew install python3
fi

# Tiny-Fugue MUD client
if ! command -v tf &> /dev/null
then
    echo "TinyFugue not found. I install it via Homebrew"
    brew install tinyfugue
fi

# Homebrew has a newer curl than macOS
CURLBIN=/usr/local/opt/curl/bin/curl
if ! [ -f "$CURLBIN" ]; then
    brew install curl
fi
export PATH=/usr/local/opt/curl/bin:$PATH

### history control ###

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# setting history length
HISTSIZE=1000
HISTFILESIZE=2000

# python 3
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
alias pip=/usr/local/bin/pip3

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# if an aliases file exists, load it
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# a fancy prompt
prompt_color='\[\033[;94m\]'
info_color='\[\033[1;34m\]'
prompt_symbol=💀
PS1=$prompt_color'\u@\h) \[\033[0;1m\][\w] $(parse_git_branch)\n'$prompt_color'└─'$info_color'\[\033[0;1m\]'$prompt_symbol' '
export PS1

# for GPG
export GPG_TTY=`tty`

# some aliases
alias ls='ls -a'
alias grep='grep --color=auto'
SYNERGYFILE=/Library/LaunchAgents/com.symless.synergy.synergy-service.plist
if ! test -f "$SYNERGYFILE"; then
    alias synergy-stop="launchctl unload /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"
    alias synergy-start="launchctl load /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"
fi
alias bl='tf bl.mud.at 5678'

export GEM_HOME=$HOME/Software/ruby

export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"

# stuff we don't want to publish goes to ~/.bash.private
PRIVFILE=~/.bash.private
if ! [ -f "$PRIVFILE" ]; then
    touch $PRIVFILE
fi
source $PRIVFILE
