#!/bin/sh
if [ "$SENDER" == "aerospace_workspace_change" ]; then
  prevapps=$(aerospace list-windows --workspace "$PREV_WORKSPACE" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  if [ "${prevapps}" != "" ]; then
    sketchybar --set space.$PREV_WORKSPACE drawing=on
    icon_strip=""
    while read -r app
    do
      icon_strip+=" $($PLUGIN_DIR/icon_map_fn.sh "$app")"
    done <<< "${prevapps}"
    sketchybar --set space.$PREV_WORKSPACE label="$icon_strip" drawing=on background.color=0x44ffffff
  else
    sketchybar --set space.$PREV_WORKSPACE drawing=off background.color=0x44ffffff
  fi
  apps=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}'| sort -u )

  sketchybar --set space.$FOCUSED_WORKSPACE drawing=on
  icon_strip=""
  if [ -z "$apps" ]; then
      icon_strip=""
  else
    while read -r app
    do
      icon_strip+=" $($PLUGIN_DIR/icon_map_fn.sh "$app")"
    done <<< "${apps}"
  fi


  sketchybar --set space.$FOCUSED_WORKSPACE label="$icon_strip" background.color=0xAAFF00FF drawing=on
fi

if [ "$SENDER" == "space_windows_change" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
  apps=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}' | sort -u)
  icon_strip=""
  if [ -z "$apps" ]; then
      icon_strip=""
  else
    while read -r app
    do
      icon_strip+=" $($PLUGIN_DIR/icon_map_fn.sh "$app")"
    done <<< "${apps}"
  fi

  sketchybar --set space.$FOCUSED_WORKSPACE label="$icon_strip" background.color=0xAAFF00FF drawing=on

fi

