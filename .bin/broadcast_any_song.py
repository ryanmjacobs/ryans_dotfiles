#!/usr/bin/env python2
################################################################################
# broadcast_any_song.py
#
# Uses the Exfm REST API to broadcast a song, (basically scours Tumblr for an
# audio file matching a query then sends it to PiFM.)
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# May 18, 2014 -> Creation date.
################################################################################

# Global Variables
NC_HOST="gamma"
NC_PORT=1234

import os          # to execute shell commands
import sys         # arguments
import json        # json parsing
import urllib2     # url parsing and downloading

if not len(sys.argv) > 1:
	print('Usage: ' + sys.argv[0] + ' <search term>')
	exit(1)

json_url    = urllib2.urlopen("http://ex.fm/api/v3/song/search/%s"% "+".join(sys.argv[1:]))
parsed_json = json.loads(json_url.read())
song_url    = parsed_json["songs"][0]["url"]

os.system("wget -O - " + song_url + " | nc " + str(NC_HOST) + " " + str(NC_PORT))
