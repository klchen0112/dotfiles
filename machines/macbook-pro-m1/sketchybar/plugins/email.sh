#!/bin/sh

SKETCHBAR_BIN="sketchybar"

UNREAD=$(osascript -e 'tell application "Spark" to return the unread count of inbox')

$SKETCHBAR_BIN --set $NAME label=$UNREAD
