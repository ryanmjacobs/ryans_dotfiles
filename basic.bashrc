# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# terminal colors
export TERM=xterm-256color

# history
HISTCONTROL="ignorespace"
HISTFILESIZE=50000000
HISTSIZE=1000000

# colorize the prompt, green for user and red for root
if [ "$(id -u)" -ne 0 ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
elif [ "$(id -u)" -eq 0 ]; then
    PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

alias ls="ls --color=auto --quoting-style=literal"
alias grep="grep --color=auto"
[ -r /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion

if [ -r /etc/DIR_COLORS ]; then
    eval `dircolors /etc/DIR_COLORS`
elif [ -r .dir_colors ]; then
    eval `dircolors .dir_colors`
fi

EDITOR=vim
PATH="$HOME/.bin:$PATH"
PATH="$HOME/.bin/rbin:$PATH"
PATH="$HOME/.npm-packges/bin:$PATH"
