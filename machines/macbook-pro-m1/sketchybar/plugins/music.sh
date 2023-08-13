#!/usr/bin/env sh

SKETCHBAR_BIN="sketchybar"

if $SKETCHBAR_BIN --query default_menu_items | grep "$NAME" >> /dev/null; then
  $SKETCHBAR_BIN --set "$NAME" alias.scale=1 label="" label.padding_right=0
else
  $SKETCHBAR_BIN --set "$NAME" alias.scale=0 label="网易云音乐" label.padding_right=16
fi
