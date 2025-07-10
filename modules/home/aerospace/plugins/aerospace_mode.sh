#!/usr/bin/env bash

CURRENT_MODE=$(aerospace list-modes --current)

if [ "$CURRENT_MODE" == "main" ]; then
    sketchybar --set "$NAME" drawing=off label=""
else
    sketchybar --set "$NAME" drawing=on label="$CURRENT_MODE"
fi
