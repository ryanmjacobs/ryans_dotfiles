#!/bin/bash

cd "$HOME"
while true; do
    c '.bin/rbin/src/dwmstatus.c -lX11'
    sleep 1
done
