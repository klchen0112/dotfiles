EMAIL_CLICK_SCRIPT="open -a 'Spark'"

$SKETCHBAR_BIN --add item email left                                            \
               --set email update_freq=10                                        \
                          icon=󰇮                                                 \
                          icon.color=0xff7aa2f7                                  \
                          icon.font.size=20                                          \
                          icon.padding_left=16                                   \
                          icon.padding_right=4                                   \
                          label.padding_right=4                                  \
                          label.padding_right=8                                 \
                          background.color=$BACKGROUND_COLOR                     \
                          background.height=$BACKGROUND_HEIGHT                   \
                          background.corner_radius=$BACKGROUND_CORNER_RADIUS     \
                          background.padding_right=0                             \
                          script="$PLUGIN_DIR/app_status_label.sh"                          \
                          click_script="$EMAIL_CLICK_SCRIPT"                     \
