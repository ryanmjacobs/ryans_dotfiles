#!/bin/bash

unset MAILCHECK
source ~/.rd/basic.bashrc
source ~/.rd/.bash_functions

alias k1="kill %1"
alias sss="sudo systemctl"
alias rbin="cd ~/.rd/rbin"
alias os="cat /etc/os-release"
alias g=gnumeric

alias cw='cd "$PWD"'
alias calc=node
alias ct="column -t"

alias ms="mosh --predict=experimental newcastle.red"

# zfs
alias zl="zfs list"
alias zlo="zfs list -o space"
alias zla="zfs list -t all"
alias zls="zfs list -t snapshot -o name,used,refer,creation"
alias zlm="sudo zfs mount"
alias zd="sudo zfs destroy"
alias zp="zpool status -Td"
alias zpl="zpool list"
alias zlp="zpool list"
alias zpi="zpool iostat -yn 1"

# make
alias mt="make test"
alias ma="make all"
alias mc="make clean"

alias ee="exec bash"
alias et="exec bash -c 'tmux new'"
alias c3="cal -3"
alias pp="pavucontrol &"
alias agi="ag -i" # case insensitive
alias agu="ag -u" # hidden files
alias agq="ag -Q" # no regex

alias tb="(thunderbird &)"
alias ll="ls -lh"
alias vm="virt-manager"
alias lq="vncviewer -QualityLevel 0 -CompressLevel 6 -CustomCompressLevel -AutoSelect=0 -LowColorLevel=1 -FullColor=0 -passwd ~/.vncp localhost:1234"
alias lqe="lq&exit"
alias ff="firefox -private"
alias firefox="firefox -private"
alias brave="brave --incognito"
alias chrom="chromium --incognito"
alias b="brave"
alias x="(xterm &)"
alias sshr="ssh-keygen -R"
alias k="killall"
alias fu="journalctl -fu"
alias k=killall

# qemu/libvirt
alias vari="cd /var/lib/libvirt/images"
alias vv="virsh -c qemu:///system"
alias vvn="vv net-dhcp-leases default"
alias vt="cd /var/tmp"
alias vc="cd /var/cache"
alias tt="pushd /tmp"

# apt
alias au="sudo apt update"
alias auu="sudo apt update && sudo apt upgrade -y"
alias ai="sudo apt install -y"
alias aq="apt search"
alias aar="sudo apt autoremove -y"
alias apr="sudo apt purge -y"

# pacman
alias pq="pacman -Ss"
alias syu="sudo pacman -Syu"
alias pi="sudo pacman -S --noconfirm"
alias pr="sudo pacman -Rns"
alias yq="yay -Ss"
alias yi="yay -S"

# yum/dnf
alias dq="dnf search"
alias di="sudo dnf install -y"
alias dr="sudo dnf remove -y"
alias duu="sudo dnf update -y"

# xbps
alias xq="xbps-query -Rs"
alias xr="sudo  /bin/xbps-remove -R"
alias xi="sudo  /bin/xbps-install -y"
alias xis="sudo /bin/xbps-install -Suv"
alias xs="sudo  /bin/xbps-install -Suv"
alias xii="/usr/bin/xi"
alias zzz="sudo zzz"

# vspm
alias   v="vpsm"
alias  vi="v i"
alias vss="v ss"

# ip
alias ipl="ip --brief --color link"
alias ipr="ip --brief --color route"
alias ipa="ip --brief --color address"
alias ipl6="ip -6 --brief --color link"
alias ipr6="ip -6 --brief --color route"
alias ipa6="ip -6 --brief --color address"

# sql
alias lc=litecli

# logs
alias np="date +%s | tee -a ~/private/np"
alias meds="date +%s | tee -a ~/private/meds.txt"

_gforth() {
    gforth "$@" -e bye
}
alias 4=_gforth
alias f=_gforth

#[ -f ~/read_only_cred ] && source ~/read_only_cred

otp() {
    # otp to clipboard
    pass otp -c otp/"$1"
}
oo() {
    # otp printout (no clipboard)
    pass otp otp/"$1"
}
alias p="pass -c"
pe() {
    pass -c encfs-"$1"
}

alias ginf=git-infect
alias inf=git-infect
alias gs="git show"
alias gr="git remote update"
alias infe="git-infect & exit"

em() {
    mkdir -p ~/_enc
    encfs --extpass "pass encfs-$HOSTNAME" ~/.encfs ~/_enc
}
emp() {
    mkdir -p ~/_enc
    encfs ~/.encfs ~/_enc
}

rot13() {
    tr "A-Za-z" "N-ZA-Mn-za-m"
}

# ll
alias lnt="yarn lint --cache --fix"
alias jt="time yarn just-test"
alias tc="time yarn type_check"
alias cdc="yarn circular_dependency_check"
alias nhs="npx http-server"

PATH=$PATH:~/.npm/bin

us() {
    [ ! -e "$1" ] && { echo "usage: us <executable>"; return 1; }
    sudo chown root "$1"
    sudo chmod +x "$1"
    sudo chmod u+s "$1"
}

unset http_proxy
unset https_proxy
