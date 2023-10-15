


$SKETCHBAR_BIN -m --add item yabai_mode left \
              --set yabai_mode update_freq=3 \
              --set yabai_mode icon="" \
              --set yabai_mode background.padding_right=12 \ 
              --set yabai_mode script="$PLUGIN_DIR/yabai_mode.sh" \
              --set yabai_mode click_script="$PLUGIN_DIR/yabai_mode_click.sh" \
              --subscribe yabai_mode space_change
