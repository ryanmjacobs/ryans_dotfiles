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

# Disable double-tap = click on touchpad
#synclient TapButton1=0 TapButton2=0 TapButton3=0

# Load .Xresources file
xrdb $HOME/.Xresources

# Dwm Statusbar
dwmstatus &

# Dunst Notification Daemon
dunst &

# Keep the colors pleasing
redshift &

# nice java windows
wmname LG3D

# start compositor
#compton -CG &

# Set the background wallpaper
#feh --bg-scale $HOME/.bin/wallpapers/Sea_Fury.jpg &
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# Start the WM
#exec twm
exec dwm
