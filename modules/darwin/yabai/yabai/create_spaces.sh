#!/bin/sh

DESIRED_SPACES_PER_DISPLAY=5
CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"

DELTA=0
while read -r line
do
  LAST_SPACE="$(echo "${line##* }")"
  LAST_SPACE=$(($LAST_SPACE+$DELTA))
  EXISTING_SPACE_COUNT="$(echo "$line" | wc -w)"
  MISSING_SPACES=$(($DESIRED_SPACES_PER_DISPLAY - $EXISTING_SPACE_COUNT))
  if [ "$MISSING_SPACES" -gt 0 ]; then
    for i in $(seq 1 $MISSING_SPACES)
    do
      yabai -m space --create "$LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE+1))
    done
  elif [ "$MISSING_SPACES" -lt 0 ]; then
    for i in $(seq 1 $((-$MISSING_SPACES)))
    do
      yabai -m space --destroy "$LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE-1))
    done
  fi
  DELTA=$(($DELTA+$MISSING_SPACES))
done <<< "$CURRENT_SPACES"

yabai -m space 1  --label code
yabai -m space 2  --label browser
yabai -m space 3  --label chat
yabai -m space 4  --label work
yabai -m space 5  --label mail
yabai -m space 6  --label music
yabai -m space 7  --label game
yabai -m space 8  --label video
yabai -m space 9  --label database
yabai -m space 10 --label document
