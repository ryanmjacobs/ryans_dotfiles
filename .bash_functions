#!/bin/bash

# highlights the provided string via stdin
h() {
    str="$1"
    [ -z "$str" ] && { >&2 echo "usage: ${FUNCNAME[0]} <string>"; return 1; }
    </dev/stdin grep --color -E "$str"'|'
}

# Kubernetes
alias kt=kubectx
alias kc=kubectl
alias kcn="kubectl -n kube-system"
alias kd="kubectl describe"
alias kdn="kubectl describe -n kube-system"
alias kca="kc get all"
alias kcna="kcn get all"
alias dka='docker kill `docker ps -q`; docker system prune -af'
alias dk='docker kill'
alias ds='docker service'
alias dsl='docker service list'
dkr() {
    docker kill "$1"
    docker rm "$1"
}
kce() {
    kubectl exec -it "$1" bash
}
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

reload_kt() {
    KUBECONFIG=""
    for f in "$HOME"/.kube/*.yaml; do
        KUBECONFIG+="$f:"
    done
    export KUBECONFIG
}
reload_kt


# Git
alias cma="git commit --amend"
alias gp="git push"
alias gpu='git push --set-upstream origin $(git symbolic-ref --short -q HEAD)'
alias wip="git add .; git commit -m wip; git push & exit"
alias ga="git add ."
alias gip="git pull"
alias gpp="git pull --no-edit && git push"
alias gii="git pull --no-edit"
alias gpi="git pull"
alias gg="git status"
alias gst="git status"
alias gck="git checkout ."
alias gpt="git push --tags"
alias gd="git checkout --detach"
alias gdh="git diff HEAD"
cm() {
    # 'git commit -m' with all arguments concatenated
    # e.g. 'cm one two three'
    git commit -m "$*"
}
cmv() {
    git commit --no-verify -m "$*"
}
acm() {
    git add .
    git commit -m "$*"
}
gpe() {
    {   git push
        notify-send "git push : ret=$?"
    } & exit
}
gc() {
    git clone --depth=1 "$1" && cd "$(basename "$1")"
}
_gc() {
    git clone "$1" && cd "$(basename "$1")"
}
gcr() {
    _gc git@github.com:ryanmjacobs/"$1"
}
gcn() {
    git clone nas:git/"$1" && cd "$1"
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

# neat looping utilities
# examples:
#   $ 2x echo hello  $ x2 echo hello  $ x3 echo -n world
#   hello            hello            world world world
#   hello            hello
xx() { while true; do "$@"; done }
for n in {2..20}; do
    eval "${n}x() { for n in `seq -s' ' $n`; do" '$@; done }'
    eval "x${n}() { for n in `seq -s' ' $n`; do" '$@; done }'
done

# do something every 5 minutes
5m() {
    while true; do
        "$@"
        sleep 5m
    done
}

kdd() {
    docker stop "$1"
    docker rm "$1"
}
