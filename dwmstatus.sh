#!/bin/bash

while true; do
    c "$HOME/.bin/rbin/src/dwmstatus.c -lX11 `pkg-config --cflags --libs libnotify`"
    sleep 1
done
