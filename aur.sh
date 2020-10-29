#!/bin/bash
set -e

# install yay
if ! hash yay; then
    tmp="$(mktemp -d)"
    trap "rm -rf $tmp" EXIT INT TERM
    git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp" && cd "$tmp"
    makepkg -si --noconfirm
fi

# install peervpn (unless directed not to)
if [ "$1" != "no-peervpn" ]; then
    yay -S peervpn --noconfirm
fi
