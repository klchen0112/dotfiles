#!/usr/bin/env zsh

UPDOWN=$(ifstat-legacy -i "en0" -b 0.1 1 | tail -n1)
DOWN=$(echo "$UPDOWN" | awk '{ print $1 }' | cut -f1 -d ".")
UP=$(echo "$UPDOWN" | awk '{ print $2 }' | cut -f1 -d ".")

DOWN_FORMAT=""
if [ "$DOWN" -gt "7999" ]; then
  DOWN_FORMAT=$(echo "$DOWN / 8000" | bc -l | awk '{ printf "%.1f MBps", $1 }') # Convert to MBps
else
  DOWN_FORMAT=$(echo "$DOWN / 8" | bc -l | awk '{ printf "%.1f KBps", $1 }') # Convert to KBps
fi

UP_FORMAT=""
if [ "$UP" -gt "7999" ]; then
  UP_FORMAT=$(echo "$UP / 8000" | bc -l | awk '{ printf "%.1f MBps", $1 }') # Convert to MBps
else
  UP_FORMAT=$(echo "$UP / 8" | bc -l | awk '{ printf "%.1f KBps", $1 }') # Convert to KBps
fi

sketchybar -m --set network.down label="$DOWN_FORMAT" icon.highlight="$(if [ "$DOWN" -gt "0" ]; then echo "on"; else echo "off"; fi)" \
              --set network.up label="$UP_FORMAT" icon.highlight="$(if [ "$UP" -gt "0" ]; then echo "on"; else echo "off"; fi)"
