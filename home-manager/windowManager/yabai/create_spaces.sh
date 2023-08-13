#!/bin/sh

function setup_space {
  local idx="$1"
  local name="$2"
  local space=

  space=$(yabai -m query --spaces --space "$idx")
  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  yabai -m space "$idx" --label "$name"
}

setup_space 1 code
setup_space 2 browser
setup_space 3 chat
setup_space 4 work
setup_space 5 mail
setup_space 6 music
setup_space 7 game
setup_space 8 video
setup_space 9 database
setup_space 10 document
