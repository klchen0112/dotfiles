#!/usr/bin/env bash

SKETCHBAR_BIN="sketchybar"

used_memory_percentage=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }')

$SKETCHBAR_BIN --set $NAME label="$used_memory_percentage%"
