#!/bin/sh

SKETCHBAR_BIN="sketchybar"

STATE=$(blueutil -p)
if [ $STATE = 0 ]; then
  LABEL=
else
  LABEL=
fi

# CONNECTED=$(/opt/homebrew/bin/blueutil --connected | wc -l | sed -e 's/^[[:space:]]*//')

$SKETCHBAR_BIN --set $NAME label="$LABEL"
