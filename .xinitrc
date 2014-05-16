#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
# March 18, 2014 -> Original Creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

# Merge in the user .Xresources file
xrdb -merge $HOME/.Xresources

# Disable terminal bell
xset b off

# Disable double-tap = click on touchpad
synclient TapButton1=0 TapButton2=0 TapButton3=0

# Dwm Statusbar
$HOME/.bin/dwm_statusbar.sh

# Start the DM and/or WM and/or Background
#exec cinnamon-session
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &
exec dwm
