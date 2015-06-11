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
if ! $(xrandr --output HDMI1 | grep "not found"); then
    xrandr --output HDMI1 --mode 1280x1024 --pos 1366x0 --rotate normal\
           --output LVDS1 --mode 1366x768 --pos 0x256 --rotate normal\
           --output VIRTUAL1 --off\
           --output DP1 --off\
           --output VGA1 --off
fi

# Disable double-tap = click on touchpad
synclient TapButton1=0 TapButton2=0 TapButton3=0

# Load .Xresources file
xrdb $HOME/.Xresources

# Set the background wallpaper
#feh --bg-scale $HOME/.bin/wallpapers/Sea_Fury.jpg &
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# Dwm Statusbar
$HOME/.bin/dwmstatus &

# Dunst Notification Daemon
dunst &

# Keep the colors pleasing
redshift &

# Start the WM
#exec twm
exec dwm
