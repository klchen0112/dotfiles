#!/bin/sh
apps=$(aerospace list-windows --focused | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
WINDOW_TITLE=$(aerospace list-windows --focused | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $3}')
if [ -z "$apps" ]; then
  icon_strip=""
else
  icon_strip=""
  while read -r app
  do
    icon_result=$($PLUGIN_DIR/icon_map_fn.sh "$app")
    icon_strip+=" ${icon_result}"
  done <<< "${apps}"
fi

if [[ ${#WINDOW_TITLE} -gt 50 ]]; then
  WINDOW_TITLE="$(echo "$WINDOW_TITLE" | cut -c 1-50 | iconv -c)"
fi

sketchybar --set window_title label="$WINDOW_TITLE"
sketchybar --set window_title icon="$icon_strip"
