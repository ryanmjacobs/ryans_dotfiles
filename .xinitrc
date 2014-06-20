#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
# March 18, 2014 -> Initial creation.
# April 16, 2014 -> Disable terminal bell.
#  June 15, 2014 -> Remove dwm and touchpad stuff to support Raspberry Pi.
################################################################################

# Merge in the user .Xresources file
xrdb -merge $HOME/.Xresources

# Set the background wallpaper
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# Start the WM
exec twm
