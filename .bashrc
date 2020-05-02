#!/bin/bashrc

source ~/.rd/basic.bashrc
source ~/.rd/.bash_functions

export TERMINAL=termite

alias tb="(thunderbird &)"
alias lq="vncviewer -QualityLevel 0 -CompressLevel 6 -CustomCompressLevel -AutoSelect=0 -LowColorLevel=1 -FullColor=0 -passwd ~/.vncp localhost:1234"
alias lqe="lq&exit"
alias ff="firefox -private"
alias firefox="firefox -private"
alias brave="brave --incognito"
alias b="brave"
alias x="(xterm &)"

# xbps
alias  v="vpsm"
alias xq="xbps-query -Rs"
alias xr="sudo xbps-remove -R"
alias xi="sudo xbps-install"
alias xs="sudo xbps-install -Suv"
alias xii="/usr/bin/xi"

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

[ -f ~/read_only_cred ] && source ~/read_only_cred

otp() {
    pass otp -c otp/"$1"
}

alias ginf=git-infect
alias inf=git-infect
alias infe="git-infect & exit"

em() {
    mkdir -p ~/_enc
    encfs --extpass "pass encfs-$HOSTNAME" ~/.encfs ~/_enc
}

rot13() {
    tr "A-Za-z" "N-ZA-Mn-za-m"
}

alias sd=spacedtime
alias asd="spacedtime recall"
