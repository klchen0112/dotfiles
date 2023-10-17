space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$yabai_mode" in
    bsp)
    $SKETCHBAR_BIN -m --set yabai_mode icon=""
    ;;
    stack)
    $SKETCHBAR_BIN -m --set yabai_mode icon="﯅"
    ;;
    float)
    $SKETCHBAR_BIN -m --set yabai_mode icon=""
    ;;
esac
