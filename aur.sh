#!/bin/bash
set -e

# install yay
if ! hash yay; then
    tmp="$(mktemp -d)"
    trap "rm -rf $tmp" EXIT INT TERM
    git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp" && cd "$tmp"
    makepkg -si --noconfirm
fi

# install peervpn
yay -S peervpn --noconfirm
