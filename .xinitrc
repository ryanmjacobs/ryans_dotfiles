#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# March 18, 2014 -> File creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

# Load .Xresources file
xrdb $HOME/.Xresources

# Disable double-tap = click on touchpad
synclient TapButton1=0 TapButton2=0 TapButton3=0

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
