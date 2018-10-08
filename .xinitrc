#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# March 18, 2014 -> File creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

# Dual monitors
#if ! $(xrandr --output HDMI1 | grep "not found"); then
    # 1280x1024 HDMI Screen
   #xrandr --output HDMI1 --mode 1280x1024 --pos 1366x0 --rotate normal\
   #       --output LVDS1 --mode 1366x768 --pos 0x256 --rotate normal\
   #       --output VIRTUAL1 --off\
   #       --output DP1 --off

    # 1080p HDMI Screen
   #xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --output LVDS1 --mode 1366x768 --pos 0x1080 --rotate normal --output VIRTUAL1 --off --output DP1 --off --output VGA1 --off
#fi

xrdb $HOME/.Xresources

# Disable double-tap = click on touchpad
#synclient TapButton1=0 TapButton2=0 TapButton3=0

# Dwm Statusbar
dwmstatus.sh &

# Dunst Notification Daemon
dunst &

# Keep the colors pleasing
#redshift &
redshift -l 38:-121 &

# nice java windows
wmname LG3D

# start compositor
compton -CG -D 0 &

# Set the background wallpaper
#feh --bg-scale $HOME/.bin/wallpapers/Sea_Fury.jpg &
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# Allow the Super (windows/command keys) to be used as Alt
xmodmap -e "remove mod4 = Super_L"
xmodmap -e "remove mod4 = Super_R"
xmodmap -e "add mod1 = Super_L"
xmodmap -e "add mod1 = Super_R"

# Start the WM
#exec twm
exec dwm
#exec icewm
