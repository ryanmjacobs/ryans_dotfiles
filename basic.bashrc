#!/bin/bash
# if not running interactively, don't do anything
#[[ $- != *i* ]] && return

# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Terminal colors
export CLICOLOR=true
export TERM=xterm-256color

# History
HISTSIZE=10000000
HISTFILESIZE=500000000
HISTCONTROL="ignorespace"
HISTTIMEFORMAT="%-m/%d/%y, %r -- "

# BASH
shopt -s globstar     # recursive globbing
shopt -s histappend   # keep history when BASH exits
shopt -s checkwinsize # resize window after each command
[ -r /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion

# Colorize the prompt, green for user and red for root
if [ "$(id -u)" -ne 0 ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
else
    PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# Colorize commands by default
alias watch="watch --color"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ls="ls --color=auto --quoting-style=literal"

# `ls` colors
[ -r /etc/DIR_COLORS ] && eval `dircolors /etc/DIR_COLORS`
[ -r ~/.dir_colors ]   && eval `dircolors ~/.dir_colors`

# create ssh-agent instance if dne
if hash ssh-agent; then
    [ ! -f ~/.agent ] && ssh-agent > ~/.agent
    source ~/.agent
    kill -0 "$SSH_AGENT_PID" || { ssh-agent > ~/.agent; source ~/.agent; }
fi

# Default applications
export EDITOR=vim
export BROWSER="firefox -private"

# Application-specific configuration
alias feh="feh -."
export SWEETHOME3D_JAVA3D=1.5
export GPG_TTY="$(tty)" # enable tty for GPG and pinentry-curses

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.bin/rbin:$PATH"
export PATH="$HOME/.npm-packges/bin:$PATH"
export BUNDLE_PATH="$HOME/.bundle/install"
