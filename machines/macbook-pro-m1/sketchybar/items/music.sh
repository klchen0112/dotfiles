$SKETCHBAR_BIN --add alias 'PlexAmp' right                               \
               --set 'PlexAmp'                                          \
                     label.color=0xfff6768e                                \
                     alias.color=0xfff6768e                                \
                     background.padding_right=0                            \
                     background.padding_left=4                             \
                     background.color=$BACKGROUND_COLOR                    \
                     background.height=$BACKGROUND_HEIGHT                  \
                     background.corner_radius=$BACKGROUND_CORNER_RADIUS    \
                     script="$PLUGIN_DIR/music.sh"                         \
                     click_script="open -a /Applications/NeteaseMusic.app" \
