#!/bin/bash
#set -e
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
dwmstatus &

# Dunst Notification Daemon
dunst &

# Keep the colors pleasing
redshift -l 39:-121 & # Newcastle

# nice java windows
wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1

# start compositor
picom -CG -D 0 &

# Set the background wallpaper
#feh --bg-scale $HOME/.bin/wallpapers/Sea_Fury.jpg &
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# continuosly set bg in case resolution ever changes
while true; do
    feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg
    sleep 60
done &

if [ "$HOSTNAME" == "mu2" ]; then
    :
    #disable_trackpoint.sh
    #calibrate_sticky_trackpoint.sh
fi

# Start the WM
exec dwm
#exec startlxde
#exec twm
