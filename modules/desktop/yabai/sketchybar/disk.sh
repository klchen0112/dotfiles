#!/usr/bin/env sh

used_disk_percentage=$(df -H | grep -E '^(/dev/disk3s5).' | awk '{ printf ("%s\n", $5) }')

sketchybar --set {NAME} label="$used_disk_percentage"
