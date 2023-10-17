#!/usr/bin/env sh

SKETCHBAR_BIN="sketchybar"

if $SKETCHBAR_BIN --query default_menu_items | grep "$NAME" >> /dev/null; then
  $SKETCHBAR_BIN --set "$NAME" alias.scale=1
else
  $SKETCHBAR_BIN --set "$NAME" alias.scale=0
fi
