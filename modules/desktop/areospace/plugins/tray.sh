#!/usr/bin/env sh

if sketchybar --query default_menu_items | grep "$NAME" >> /dev/null; then
  sketchybar --set "$NAME" alias.scale=1
else
  sketchybar --set "$NAME" alias.scale=0
fi
