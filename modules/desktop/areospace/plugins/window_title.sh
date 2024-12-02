#!/usr/bin/env bash

APP=$(aerospace list-windows --focused | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
WINDOW_TITLE=$(aerospace list-windows --focused | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $3}')

PLUGIN_DIR=/Users/klchen/my/dotfiles/modules/desktop/areospace/plugins
if [ "${APP}" != "" ]; then
  while read -r app
  do
    icon_strip+="$($PLUGIN_DIR/icon_map_fn.sh "$app") "
  done <<< "${APP}"
else
  icon_strip=""
fi

if [[ ${#WINDOW_TITLE} -gt 50 ]]; then
  WINDOW_TITLE="$(echo "$WINDOW_TITLE" | cut -c 1-50 | iconv -c)..."
fi

sketchybar --set window_title label="$WINDOW_TITLE" icon="$icon_strip"
