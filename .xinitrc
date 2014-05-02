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

# Start the DE, WM, and File Manager
exec cinnamon-session
