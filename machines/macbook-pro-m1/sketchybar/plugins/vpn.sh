#!/bin/sh

SKETCHBAR_BIN="sketchybar"

if scutil --nc list | grep "^\*" | grep Connected >> /dev/null; then
  LABEL=
else
  LABEL=
fi

$SKETCHBAR_BIN --set $NAME label=$LABEL
