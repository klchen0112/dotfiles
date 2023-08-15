#!/bin/sh

SKETCHBAR_BIN="sketchybar"

APP=$(yabai -m query --windows --window | jq -r '.app')
WINDOW_TITLE=$(yabai -m query --windows --window | jq -r '.title')

if [[ $WINDOW_TITLE = "" ]]; then
  WINDOW_TITLE=$(yabai -m query --windows --window | jq -r '.app')
fi

if [[ ${#WINDOW_TITLE} -gt 50 ]]; then
  WINDOW_TITLE="$(echo "$WINDOW_TITLE" | cut -c 1-50 | iconv -c)..."
fi

$SKETCHBAR_BIN --set $NAME label="$APP $WINDOW_TITLE"
