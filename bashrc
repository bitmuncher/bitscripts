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
alias bl='tf bl.mud.at 5678'

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

# python
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

# if we're in a git repo, show the current branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# what time is it?
get_time() {
    date +%H:%M
}
# I use pyenv to switch between different python versions;
# this shows me the currently active version in my prompt
get_python() {
    python --version 2>&1 |awk '{print $2}'
}
# sometimes it's useful to know what node.js version is currently active
get_nodejs() {
    node --version 2>&1
}
# bring death to the world ;) 
prompt_symbol=💀
export PS1='\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h \[\033[33;1m\][\w] \[\033[0;35m\]$(parse_git_branch)\n├[Python $(get_python)]\n├[Node.js $(get_nodejs)]\n\[\033[;94m\]└─\[\033[1;33m\]$(get_time)\[\033[;0m\] $prompt_symbol '

# for GPG
export GPG_TTY=`tty`

# if GNU coreutils are available we use dracula-style colors for ls
if [ -f "/usr/local/opt/coreutils/libexec/gnubin/ls" ]; then
    export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
    alias ls='/usr/local/opt/coreutils/libexec/gnubin/ls -a --color'
fi

# some aliases
SYNERGYFILE=/Library/LaunchAgents/com.symless.synergy.synergy-service.plist
if ! test -f "$SYNERGYFILE"; then
    alias synergy-stop="launchctl unload /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"
    alias synergy-start="launchctl load /Library/LaunchAgents/com.symless.synergy.synergy-service.plist"
fi

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
