#!/bin/bash
# Warn and exit if something is already listening on port 1555.
if [ `netstat -a | fgrep 1555 | fgrep -c LISTEN` == 1 ]; then
  echo Something is already listening on port 1555.
  echo Please stop whatever it is, and then try $0 again.
  exit
fi
# Start Xvfb as X-server display #1. If it's already been started, no harm done.
# This works in conjunction with the pathway-tools script which needs to have:
#   setenv DISPLAY localhost:1
#Xvfb :1 > & /dev/null &
Xvfb :99 & 
export DISPLAY=:99
# Start GNU screen (hit Ctrl-A Ctrl-D to detach). Within it, start Pathway Tools.
# screen -m -d /home/aic-export/pathway-tools/ptools/[version]/pathway-tools -www -www-publish all  #(for version 10.0 or later)
