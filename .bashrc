#!/bin/bashrc

source ~/.rd/basic.bashrc
source ~/.rd/.bash_functions

alias tb="thunderbird &"
alias lq="vncviewer -QualityLevel 0 -CompressLevel 6 -CustomCompressLevel -AutoSelect=0 -LowColorLevel=1 -FullColor=0 localhost:1234"
alias ff="firefox -private"
alias firefox="firefox -private"
alias brave="brave --incognito"
alias b="brave"

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

alias gi=git-infect

em() {
    mkdir -p ~/_enc
    encfs --extpass "pass encfs-$HOSTNAME" ~/.encfs ~/_enc
}
