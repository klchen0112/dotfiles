#!/bin/bash

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$yabai_mode" in
    bsp)
    yabai -m space --layout stack && sketchybar -m --set yabai_mode icon="󱏒"
    ;;
    stack)
    yabai -m space --layout float && sketchybar -m --set yabai_mode icon=""
    ;;
    float)
    yabai -m space --layout bsp && sketchybar -m --set yabai_mode icon=""
    ;;
esac
