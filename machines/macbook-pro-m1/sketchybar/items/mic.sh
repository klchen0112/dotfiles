MIC_CLICK_SCRIPT="open /System/Library/PreferencePanes/Sound.prefPane"

$SKETCHBAR_BIN --add item mic right                                               \
           --set mic update_freq=5                                               \
                       icon.padding_left=0                                      \
                       icon.padding_right=4                                      \
                       icon.color=0xff6c77bb                                     \
                       icon.y_offset=0                                           \
                       label.padding_right=3                                    \
                       background.color=$BACKGROUND_COLOR                        \
                       background.height=$BACKGROUND_HEIGHT                      \
                       background.corner_radius=$BACKGROUND_CORNER_RADIUS        \
                       background.padding_left=8                                 \
                       background.padding_right=3                                \
                       script="$PLUGIN_DIR/mic.sh"                               \
                       click_script="$MIC_CLICK_SCRIPT"                          \
