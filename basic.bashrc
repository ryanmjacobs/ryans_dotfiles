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

# VTE support (mainly for ctrl-shift-t on termite)
[ -e /etc/profile.d/vte.sh ] && source /etc/profile.d/vte.sh

# History
HISTSIZE=10000000
HISTFILESIZE=500000000
HISTCONTROL="ignorespace"
HISTTIMEFORMAT="%-m/%d/%y, %r -- "

# BASH
shopt -s histappend   # keep history when BASH exits
shopt -s checkwinsize # resize window after each command
[ "$HOSTNAME" != mm ] && shopt -s globstar # recursive globbing
[ -r /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion

# Colorize the prompt, green for user and red for root
if [ "$(id -u)" -ne 0 ]; then
    PS1='\[\033[01;32m\]\u@\H\[\033[01;34m\] \w \$\[\033[00m\] '
else
    PS1='\[\033[01;31m\]\u@\H\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# Colorize commands by default
alias watch="watch --color"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
[ "$HOSTNAME" != mm ] &&\
    alias ls="ls --color=auto --quoting-style=literal"

# `ls` colors
if [ "$HOSTNAME" != mm ]; then
    [ -r /etc/DIR_COLORS ] && eval `dircolors --sh /etc/DIR_COLORS`
    [ -r ~/.dir_colors ]   && eval `dircolors --sh ~/.dir_colors`
fi

# create ssh-agent instance if dne
ssh_agent() {
    if hash ssh-agent; then
        [ ! -f ~/.agent ] && ssh-agent > ~/.agent
        { source ~/.agent; } >/dev/null
        kill -0 "$SSH_AGENT_PID" || { ssh-agent > ~/.agent; source ~/.agent; }
    fi
}
ssh_agent &>/dev/null

# Default applications
export EDITOR=vim
export BROWSER=firefox

# Application-specific configuration
alias feh="feh -."
export SWEETHOME3D_JAVA3D=1.5
export GPG_TTY="$(tty)" # enable tty for GPG and pinentry-curses

export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.bin/rbin:$PATH"
export PATH="$HOME/radious/bin:$PATH"
export PATH="$HOME/.npm-packges/bin:$PATH"
export BUNDLE_PATH="$HOME/.bundle/install"
export XBPS_DISTDIR="$HOME/.void-packages"

alias ut="date +%s"
