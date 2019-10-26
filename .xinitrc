#!/bin/bash
set -e
################################################################################
# Personal .xinitrc file
#
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# March 18, 2014 -> File creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

# Disable double-tap = click on touchpad
#synclient TapButton1=0 TapButton2=0 TapButton3=0

# Dwm Statusbar
dwmstatus.sh &

# Dunst Notification Daemon
dunst &

# Keep the colors pleasing
redshift -l 39:-121 & # Newcastle

# nice java windows
wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1

# start compositor
compton -CG -D 0 &

xrandr --output HDMI-1 --scale 1.5x1.5
xrandr --output USB-C-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-5 --off --output DP-4 --mode 3840x2160 --pos 2880x0 --rotate normal --output DP-3 --off --output DP-2 --off --output DP-1 --off --output DP-0 --off
xrandr --output HDMI-0 --scale 1.5x1.5

# Set the background wallpaper
#feh --bg-scale $HOME/.bin/wallpapers/Sea_Fury.jpg &
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# continuosly set bg in case resolution ever changes
while true; do
    feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg
    sleep 60
done &

# Allow the Super (windows/command keys) to be used as Alt
xmodmap -e "remove mod4 = Super_L"
xmodmap -e "remove mod4 = Super_R"
xmodmap -e "add mod1 = Super_L"
xmodmap -e "add mod1 = Super_R"

# Edge-scrolling instead of two-finger
#xinput set-prop 13 297 1, 1, 1 # edge-srolling
#xinput set-prop 13 298 0, 0    # two-finger scrolling

# Start the WM
exec dwm
