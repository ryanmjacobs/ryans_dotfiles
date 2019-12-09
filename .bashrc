# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# enable terminal colors
export TERM=xterm-256color

# bash completion
[ -r /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion

# Colorize with .dir_colors or /etc/DIR_COLORS
if [ -f "$HOME/.dir_colors" ]; then
    eval `dircolors "$HOME/.dir_colors"`
else
    eval `dircolors /etc/DIR_COLORS`
fi

# Colorize the prompt, green for user and red for root
if [ "$(id -u)" -ne 0 ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
elif [ "$(id -u)" -eq 0 ]; then
    PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

export EDITOR=vim
export BROWSER=firefox
export GPG_TTY=$(tty) # enable tty for GPG and pinentry-curses
export BUNDLE_PATH="$HOME/.bundle/install"

shopt -s globstar     # recursive globbing
shopt -s histappend   # keep history when BASH exits
shopt -s checkwinsize # resize window after each command

HISTSIZE=10000000
HISTFILESIZE=500000000
HISTCONTROL="ignorespace"
HISTTIMEFORMAT="%-m/%d/%y, %r -- "

################################################################################
# Aliases
################################################################################

# General aliases
alias def="sdcv"
hash nvim &>/dev/null && alias vim="nvim"

hash mdcat && alias cat=mdcat
alias bat="bat --paging=never"

# Colorize ls, grep, and watch
alias ls="ls --color=auto --quoting-style=literal"
alias grep="grep --colour=auto"
alias egrep="egrep --colour=auto"
alias watch="watch --color"

# Don't send the 'Erase is backspace.' message on XTerm when reset.
alias reset="reset -Q"

# Basic Bash prompt
alias basic_prompt='PS1="\e[01;34m$ \e[00m"'

# Allows sl (joke train program) to be interrupted with ^C
alias sl="sl -e"
alias LS="LS -e"

# Resize images to fit in feh
alias feh="feh -."

# Launch irssi with the Jellybeans theme
alias irssi="xterm -name jellybeans -e 'irssi' & exit"

alias diff="diff --color=auto"

# quick torrenting (for linux ISOs
alias torrent="transmission-cli -w ."

################################################################################
# Useful Functions
################################################################################

# Set the terminal title
xtitle() {
    unset PROMPT_COMMAND
    echo -ne "\033]0;${@}\007"
}

# Create a C file template, compatible with Doxygen
doxc() {
    # Global Variables
    AUTHOR="Ryan Jacobs <ryan.mjacobs@gmail.com>"

    if [ $# == 0 ]; then
        printf "Creates C files in a Doxygen compatible format.\n"
        printf "Usage: %s <file1> [file2] [file3]\n" $FUNCNAME
        return 1
    fi

    for file in "$@"; do
        filename=$(basename "$file")
        extension="${filename##*.}"

        printf "File: %s\n" "$file"

        if [ -f "$file" ]; then
            printf "\tFile already exists! Skipping.\n"
        elif [ "$extension" == "h" ]; then
            touch "$file"
            header_name=$(echo "$(basename $file)" | tr "." "_" | tr "[:lower:]" "[:upper:]")
            printf "/**\n"                                         >> "$file"
            printf " * @file    %s\n" "$filename"                  >> "$file"
            printf " * @brief   Brief description of the file.\n"  >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @detail\n"                                  >> "$file"
            printf " *          Detailed description goes here,\n" >> "$file"
            printf " *          and can extend down here.\n"       >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @author  %s\n" "$AUTHOR"                    >> "$file"
            printf " * @date    %s\n" "$(date '+%B %d, %Y')"       >> "$file"
            printf " */\n"                                         >> "$file"
            printf "\n"                                            >> "$file"
            printf "#ifndef %s\n" "$header_name"                   >> "$file"
            printf "#define %s\n" "$header_name"                   >> "$file"
            printf "\n"                                            >> "$file"
            printf "#endif /* %s */\n" "$header_name"              >> "$file"
            printf "\tFile created successfully!\n"
        else
            touch "$file"
            printf "/**\n"                                         >> "$file"
            printf " * @file    %s\n" "$file"                      >> "$file"
            printf " * @brief   Brief description of the file.\n"  >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @detail\n"                                  >> "$file"
            printf " *          Detailed description goes here,\n" >> "$file"
            printf " *          and can extend down here.\n"       >> "$file"
            printf " *\n"                                          >> "$file"
            printf " * @author  %s\n" "$AUTHOR"                    >> "$file"
            printf " * @date    %s\n" "$(date '+%B %d, %Y')"       >> "$file"
            printf " */\n"                                         >> "$file"
            printf "\tFile created successfully!\n"
        fi
    done
}

# Create a default Makefile for C projects
defmake() {
    if [ $# -ne 1 ]; then
        echo "Create a Makefile for C projects."
        echo "Usage: $FUNCNAME <executable_name>"
        return 1
    fi

    exe="$1"
    [ ! -d src ] && mkdir src

     >Makefile echo -e "CC=gcc"
    >>Makefile echo -e "CFLAGS=-c -Wall"
    >>Makefile echo -e "LDFLAGS="
    >>Makefile echo -e "SOURCES=\$(shell find src/ -type f -name '*.c')"
    >>Makefile echo -e "OBJECTS=\$(SOURCES:.c=.o)"
    >>Makefile echo -e "EXECUTABLE=$exe\n"

    >>Makefile echo -e "all: \$(SOURCES) \$(EXECUTABLE)\n"

    >>Makefile echo -e "\$(EXECUTABLE): \$(OBJECTS)"
    >>Makefile echo -e "\t\$(CC) \$(OBJECTS) \$(LDFLAGS) -o \$@\n"

    >>Makefile echo -e ".c.o:"
    >>Makefile echo -e "\t\$(CC) \$(CPPFLAGS) \$(CFLAGS) \$< -o \$@\n"

    >>Makefile echo -e "clean:"
    >>Makefile echo -e "\trm -f \$(EXECUTABLE)"
	>>Makefile echo -e "\t@find src/ -type f -name '*.o' -exec rm -vf {} \\;\n"

    >>Makefile echo -e ".PHONY: clean"
}

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /home/ryan/.npm-packages/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /home/ryan/.npm-packages/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /home/ryan/.npm-packages/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /home/ryan/.npm-packages/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash

[ -e /etc/profile.d/vte.sh ] && source /etc/profile.d/vte.sh

# https://medium.com/@pczarkowski/easily-install-uninstall-helm-on-rbac-kubernetes-8c3c0e22d0d7
helmins() {
    kubectl -n kube-system create serviceaccount tiller
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    helm init --service-account=tiller
}

helmdel() {
    kubectl -n kube-system delete deployment tiller-deploy
    kubectl delete clusterrolebinding tiller
    kubectl -n kube-system delete serviceaccount tiller
}

PATH="$HOME/webfpga-cli:$PATH"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer

PATH="$PATH:/usr/lib/emscripten"

# highlights the provided string via stdin
h() {
    str="$1"
    [ -z "$str" ] && { >&2 echo "usage: ${FUNCNAME[0]} <string>"; return 1; }
    </dev/stdin grep --color -E "$str"'|'
}

# 'git commit -m' with all arguments concatted
# e.g. 'cm one two three'
cm() {
    git commit -m "$*"
}
alias cma="git commit --amend"
alias gp="git push"
alias ga="git add ."
alias gip="git pull"
alias gpi="git pull"
alias gat="git status"
alias gpt="git push --tags"
gc() {
    git clone --depth=1 "$1" && cd "$(basename "$1")"
}
_gc() {
    git clone "$1" && cd "$(basename "$1")"
}
gcr() {
    _gc git@github.com:ryanmjacobs/"$1"
}

# custom bash-completion
for f in ~/.bin/rbin/bash-completions/*.bash; do
    [ -e "$f" ] && source "$f"
done

alias kt=kubectx
alias kc=kubectl
alias kcn="kubectl -n kube-system"
alias kd="kubectl describe"
alias kdn="kubectl describe -n kube-system"
alias kca="kc get all"
alias kcna="kcn get all"
alias dka='docker kill `docker ps -q`'
kce() {
    kubectl exec -it "$1" bash
}

reload_kt() {
    KUBECONFIG=""
    for f in "$HOME"/.kube/*.yaml; do
        KUBECONFIG+="$f:"
    done
    export KUBECONFIG
}
reload_kt

alias eth="nc mir.rmj.us 3293"
alias ff="firefox -private"
alias firefox="firefox -private"

alias rb=reboot
alias br=reboot

de() { date --date=@"$1";}


git config --global alias.dad '!curl https://icanhazdadjoke.com/ && echo && git add'

alias eb="ssh -i $HOME/eternalist/backend/deploy/id_rsa -o StrictHostKeyChecking=no core@db.eternalist.io"
alias be="ssh -i $HOME/eternalist/backend/deploy/id_rsa -o StrictHostKeyChecking=no core@db.eternalist.io"
alias yt=youtube-dl
alias ty=yt
alias sx=startx
alias xs=sx
alias l="light -S"
alias e=exit

sf() {
    host="$1"
    port="$2"

    if [ -z "$host" ] || [ -z "$port" ]; then
        echo "error: host/port must be defined"
        echo "usage: $0 <host> <port>"
        return 1
    fi

    echo "host=$host, port=$port"
    ssh -nNT -L "$port:localhost:$port" "$host"
}
