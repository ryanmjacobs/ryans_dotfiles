#!/usr/bin/env python2
################################################################################
# play_any_song.py
#
# Uses the Exfm REST API to play song, (basically scours Tumblr for an
# audio file matching a query).
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com?
#
# December 20, 2014 -> Creation date.
# March 18, 2014    -> Changed from MPlayer to MPV.
# April 29, 2014    -> Added --vo=null option to MPV to prevent video pop-ups.
################################################################################

import os          # to call reset at the end
import sys         # arguments
import json        # json parsing
import urllib2     # url parsing and downloading
import subprocess  # call linux commands

if not len(sys.argv) > 1:
	print('Usage: ' + sys.argv[0] + ' <search term>')
	exit(1)

json_url    = urllib2.urlopen("http://ex.fm/api/v3/song/search/%s"% "+".join(sys.argv[1:]))
parsed_json = json.loads(json_url.read())
song_url    = parsed_json["songs"][0]["url"]

subprocess.call(["mpv","--vo=null","--cache=16384","--cache-min=1",song_url])

# Reset the terminal to fix the broken state
os.system('reset')
