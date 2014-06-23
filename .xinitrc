#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
# March 18, 2014 -> Initial creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

# Load .Xresources file
xrdb $HOME/.Xresources

# Disable double-tap = click on touchpad
synclient TapButton1=0 TapButton2=0 TapButton3=0

# Set the background wallpaper
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# Dwm Statusbar
$HOME/.bin/dwm_statusbar.sh &

# Start the WM
#exec twm
exec dwm
