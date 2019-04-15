#!/bin/bash
set -e

tmp="$(mktemp -d)"
trap "rm -rvf $tmp" EXIT INT TERM

git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp" && cd "$tmp"
makepkg -si --noconfirm
