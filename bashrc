###
### This Bash configuration is intended for macOS on Intel
### on M1 some paths from Heombrew may be different
### It will not work without installed Homebrew: https://brew.sh
### The best way is to use the bash from Homebrew.
###

### set the PATH
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/.pyenv/shims:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin

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

# the best MUD of the world... trutru! (only in german, sorry!)
alias bl='tf bl.mud.at 5678'

# Homebrew has a newer curl than macOS
CURLBIN=/usr/local/opt/curl/bin/curl
if ! [ -f "$CURLBIN" ]; then
    brew install curl
fi
export PATH=/usr/local/opt/curl/bin:$PATH

# make GNU coreutils available
if ! [ -f "/usr/local/opt/coreutils/libexec/gnubin/ls" ]; then
    brew install coreutils
fi
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

# if GNU coreutils are available we can use a nice dracula-themed output for ls
if [ -f "/usr/local/opt/coreutils/libexec/gnubin/ls" ]; then
    export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
    alias ls='/usr/local/opt/coreutils/libexec/gnubin/ls -a --color'
fi

# colored outbut for grep and tree
alias grep='grep --color=auto'
alias tree='tree -C'

### history control ###

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# setting history length
HISTSIZE=1000
HISTFILESIZE=2000

# python via pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# if an aliases file exists, load it
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export CLICOLOR=1

# a nice and fancy prompt that shows the currently used python and nodejs version
# if the current directory contains a git repository, the current branch is displayed
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
get_time() {
    date +%H:%M
}
get_python() {
    python --version 2>&1 |awk '{print $2}'
}
get_nodejs() {
    node --version 2>&1
}
prompt_symbol=💀
export PS1='\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h \[\033[33;1m\][\w] \[\033[0;35m\]$(parse_git_branch)\n├[Python $(get_python)]\n├[Node.js $(get_nodejs)]\n\[\033[;94m\]└─\[\033[1;33m\]$(get_time)\[\033[;0m\] $prompt_symbol  '

# for GPG
export GPG_TTY=`tty`

export GEM_HOME=$HOME/Software/ruby

export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"

# auto-complete for kubectl
if [ -f "/usr/local/bin/kubectl" ]; then
    source <(kubectl completion bash)
    alias k=kubectl
    complete -F __start_kubectl k
fi

# stuff we don't want to publish goes to ~/.bash.private
PRIVFILE=~/.bash.private
if ! [ -f "$PRIVFILE" ]; then
    touch $PRIVFILE
fi
source $PRIVFILE
eval "$(pyenv init -)"

# we want to have normal Docker output
export DOCKER_BUILDKIT=0
export LC_ALL=C

#eval $(docker-machine env default)

# ensure we have all completions loaded
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# show all kubernetes resources, not only the limited output from 'kubectl get all'
function kubectlgetall {
    for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
        echo "Resource:" $i
        kubectl -n ${1} get --ignore-not-found ${i}
    done
}

_ssh()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)
  COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
  return 0
}
complete -F _ssh ssh
