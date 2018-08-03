#!/bin/bash

cd "$HOME"
while true; do
    c ".bin/rbin/src/dwmstatus.c -lX11 `pkg-config --cflags --libs libnotify`"
    sleep 1
done
