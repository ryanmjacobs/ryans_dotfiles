#!/bin/bashrc

source ~/.rd/basic.bashrc
source ~/.rd/.bash_functions

#export TERMINAL=termite

alias t="tb"
alias tb="(thunderbird &)"
alias vm="virt-manager"
alias lq="vncviewer -QualityLevel 0 -CompressLevel 6 -CustomCompressLevel -AutoSelect=0 -LowColorLevel=1 -FullColor=0 -passwd ~/.vncp localhost:1234"
alias lqe="lq&exit"
alias ff="firefox -private"
alias firefox="firefox -private"
alias brave="brave --incognito"
alias chrom="chromium --incognito"
alias b="brave"
alias x="(xterm &)"
alias dr="docker run -it --rm"
alias sshr="ssh-keygen -R"
alias k="killall"
alias fu="journalctl -fu"
alias k=killall

# qemu/libvirt
alias  qas='virsh -c qemu:///system list --name | while read domain; do virsh -c qemu:///system autostart "$domain"; done'
alias qras='virsh -c qemu:///system list --name --inactive | while read domain; do virsh -c qemu:///system autostart "$domain" --disable; done'

# yum/dnf
alias dq="dnf search"
alias di="sudo dnf install -y"

# xbps
alias xq="xbps-query -Rs"
alias xr="sudo xbps-remove -R"
alias xi="sudo xbps-install"
alias xis="sudo xbps-install -Suv"
alias xs="sudo xbps-install -Suv"
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

# minio
alias mc=mcli

_gforth() {
    gforth "$@" -e bye
}
alias 4=_gforth
alias f=_gforth

#[ -f ~/read_only_cred ] && source ~/read_only_cred

otp() {
    pass otp -c otp/"$1"
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

PATH=$PATH:~/.npm/bin

us() {
    [ ! -e "$1" ] && { echo "usage: us <executable>"; return 1; }
    sudo chown root "$1"
    sudo chmod +x "$1"
    sudo chmod u+s "$1"
}
