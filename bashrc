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
#TIME=$(date +%H:%M)
#FILES=$(ls -1|wc -l|tr -d "[:blank:]")
#PS1="\! \[\033[01;31m\]\\u\[\033[01;33m\]@\[\033[01;32m\]\H\[\033[01;33m\]:\w [$TIME] [$FILES] \e[0m\n\[\033[01;35m\]\$\[\033[00m\] "
#export PS1
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

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    if ! IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)); then
      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    if ! IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)); then

      local ret=$?
      IFS="$si"
      return $ret
    fi
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

# completions for Azure CLI
_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                     COMP_LINE="$COMP_LINE" \
                     COMP_POINT="$COMP_POINT" \
                     COMP_TYPE="$COMP_TYPE" \
                     _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                     _ARGCOMPLETE=1 \
                     _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                     "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "$COMPREPLY" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}
complete -o nospace -o default -o bashdefault -F _python_argcomplete "az"

# stuff we don't want to publish goes to ~/.bash.private
PRIVFILE=~/.bash.private
if ! [ -f "$PRIVFILE" ]; then
    touch $PRIVFILE
fi
source $PRIVFILE
