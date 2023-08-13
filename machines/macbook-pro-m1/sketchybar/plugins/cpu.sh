#!/usr/bin/env sh

SKETCHBAR_BIN="sketchybar"

TOPPROC=$(top -l  2 | grep -E "^CPU" | tail -1 | awk '{ print $3 + $5"%" }' | cut -d "." -f1)

$SKETCHBAR_BIN --set $NAME label="$TOPPROC%"
