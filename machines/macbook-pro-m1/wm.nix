{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}: {

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {

      layout = "bsp";
      external_bar = "all:50:0";

      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 5;

      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      window_topmost = "off";

      # active_window_border_color = color.focused;
      # normal_window_border_color = color.normal;
      # insert_feedback_color = color.preselect;
      window_zoom_persist = "off";
      window_placement = "second_child";
      window_shadow = "float";

      window_border = "on";
      window_border_radius = 10;
      window_border_width = 2;
      window_border_blur = "off";
      window_animation_duration = 0.0;

      window_opacity = "off";
      window_opacity_duration = 0.0;
      active_window_opacity = 1.0;
      normal_window_opacity = 0.90;
      split_ratio = 0.50;

      auto_balance = "off";

      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig =
      let yabai_script = ./yabai;
      in
      ''
        #!/usr/bin/env sh

        # Unload the macOS WindowManager process

        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
        yabai -m signal --add event=display_added action="sleep 2 && ${yabai_script}/create_spaces.sh"
        yabai -m signal --add event=display_removed action="sleep 1 && ${yabai_script}/yabai/create_spaces.sh"
        yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
        yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
        ## auto create Display and move to window
        ${yabai_script}/create_spaces.sh


        # ===== Rules ==================================


        # code
        yabai -m rule --add app="WezTerm" space=^1
        yabai -m rule --add label="emacs" subrole!="^(AXFloatingWindow)$" app="^Emacs$" manage=on
        yabai -m rule --add app="Dash" manage=off

        # browser
        yabai -m rule --add app="Google Chrome"
        # chat
        yabai -m rule --add app="^(Spark)$" --toggle float space=3 manage=on
        yabai -m rule --add app="^(微信|WeChat)$" --toggle float space=3 manage=off
        yabai -m rule --add app="^(QQ)$" --toggle float space=3 manage=off

        yabai -m rule --add app="^(Telegram)$" --toggle float space=3 manage=off
        yabai -m rule --add app="^(Discord)$"--toggle float space=3 manage=off

        # work
        yabai -m rule --add app="^(钉钉|DingTalk)$"--toggle float space=4 manage=off
        yabai -m rule --add app="飞书" space=^4 manage=off

        # mail
        yabai -m rule --add app="Spark" space=^4 manage=off

        # music
        yabai -m rule --add app="Plexamp" space=^6 manage=off

        # video
        yabai -m rule --add label="mpv" app="^mpv$" manage=off space=^8

        # system
        yabai -m rule --add label="Finder" app="^(Finder|访达)$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
        yabai -m rule --add label="macfeh" app="^macfeh$" manage=off
        yabai -m rule --add label="System Settings" app="^(System Settings|系统偏好设置)$" title=".*" manage=off
        yabai -m rule --add label="Calendar" app="^(Calendar|日历)$" title=".*" manage=off
        yabai -m rule --add label="App Store" app="^App Store$" manage=off
        yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
        yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
        yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
        yabai -m rule --add label="Software Update" title="Software Update" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off

        yabai -m rule --add app="Raycast" manage=off
        yabai -m rule --add app="Bitwarden" manage=off
      '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      alt - b [
        *      : yabai -m window --focus west ; or yabai -m display --focus west
        "Emacs" ~
      ]

      alt - f  [
        *      : yabai -m window --focus east ; or yabai -m display --focus east
        "Emacs" ~
      ]

      alt - p  [
        *      : yabai -m window --focus north ; or yabai -m display --focus north
        "Emacs" ~
      ]

      alt - n  [
        *      : yabai -m window --focus south ; or yabai -m display --focus south
        "Emacs" ~
      ]

      shift + alt - b [
        *      : yabai -m window --warp west; or yabai -m window --display west  ; and yabai -m display --focus west
        "Emacs" ~
      ]

      shift + alt - f  [
        *      : yabai -m window --warp east ; or yabai -m window --display east ; and yabai -m display --focus east
        "Emacs" ~
      ]

      shift + alt - p  [
        *      : yabai -m window --warp north ; or yabai -m window --display north ; and yabai -m display --focus north
        "Emacs" ~
      ]

      shift + alt - n  [
        *      : yabai -m window --warp south  ; or yabai -m window --display south  ; and yabai -m display --focus south
        "Emacs" ~
      ]

      shift + alt - x  [
        *      : yabai -m space --mirror x-axis
        "Emacs" ~
      ]

      shift + alt - y  [
        *      : yabai -m space --mirror y-axis
        "Emacs" ~
      ]

      shift + alt - r  [
        *      :  yabai -m space --rotate 90
        "Emacs" ~
      ]

      shift + alt - 1  [
        *      :  yabai -m window --space 1; yabai -m space --focus 1;
        "Emacs" ~
      ]

      shift + alt - 2  [
        *      :  yabai -m window --space 2; yabai -m space --focus 2;
        "Emacs" ~
      ]

      shift + alt - 3  [
        *      :  yabai -m window --space 3; yabai -m space --focus 3;
        "Emacs" ~
      ]

      shift + alt - 4  [
        *      :  yabai -m window --space 4; yabai -m space --focus 4;
        "Emacs" ~
      ]

      shift + alt - 5  [
        *      :  yabai -m window --space 5; yabai -m space --focus 5;
        "Emacs" ~
      ]

      shift + alt - 6  [
        *      :  yabai -m window --space 6; yabai -m space --focus 6;
        "Emacs" ~
      ]

      shift + alt - 7  [
        *      :  yabai -m window --space 7; yabai -m space --focus 7;
        "Emacs" ~
      ]

      shift + alt - 8  [
        *      :  yabai -m window --space 8; yabai -m space --focus 8;
        "Emacs" ~
      ]

      shift + alt - 9  [
        *      :  yabai -m window --space 9; yabai -m space --focus 9;
        "Emacs" ~
      ]

      shift + alt - 0 [
        *      :  yabai -m window --space 10; yabai -m space --focus ;
        "Emacs" ~
      ]

      shift + alt - space [
        *      :  yabai -m window --toggle float
        "Emacs" ~
      ]

      # maximize

      alt - m [
        *      :  yabai -m window --toggle zoom-fullscreen
        "Emacs" ~
      ]

      shift + alt - m [
        *      :  yabai -m window --toggle native-fullscreen
        "Emacs" ~
      ]

      # resize
      lctrl + alt - b [
        *      : yabai -m window --resize left:-50:0; \
                    yabai -m window --resize right:-50:0
        "Emacs" ~
      ]

      lctrl + alt - f  [
        *      : yabai -m window --resize right:50:0; \
                    yabai -m window --resize left:50:0
        "Emacs" ~
      ]

      lctrl + alt - p  [
        *      : yabai -m window --resize top:0:-50; \
                    yabai -m window --resize bottom:0:-50
        "Emacs" ~
      ]

      lctrl + alt - n  [
        *      : yabai -m window --resize bottom:0:50; \
                    yabai -m window --resize top:0:50
        "Emacs" ~
      ]

      lctrl + alt - e  [
        *      : yabai -m space --balance
        "Emacs" ~
      ]

    '';
  };
  #TODO fix plexamp and cava email
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.jq ];
    # this code from https://github.com/ColaMint/config.git
    config =
      let
        sketchybar_scripts = ./sketchybar;
      in
      ''
        #!/usr/bin/env sh
        LABEL_FONT_FAMILY="PingFang SC"
        LABEL_FONT_STYLE="Medium"
        LABEL_FONT_SIZE="14"
        LABEL_COLOR=0xffdfe1ea
        ICON_FONT_FAMILY="Hack Nerd Font"
        ICON_FONT_STYLE="Regular"
        ICON_FONT_SIZE="16"
        BAR_COLOR=0xee1a1c26
        LABEL_COLOR=0xffdfe1ea
        BACKGROUND_COLOR=0xff252731
        BACKGROUND_HEIGHT=33
        BACKGROUND_CORNER_RADIUS=16
        PADDINGS=3

        sketchybar  --bar height=40                                                     \
                              corner_radius=16                                              \
                              border_width=0                                                \
                              margin=5                                                      \
                              blur_radius=0                                                 \
                              position=top                                                  \
                              padding_left=0                                                \
                              padding_right=0                                               \
                              color=$BAR_COLOR                                              \
                              topmost=off                                                   \
                              sticky=on                                                     \
                              font_smoothing=off                                            \
                              y_offset=5                                                    \
                              notch_width=0                                                 \
                              --default drawing=on                                          \
                              updates=when_shown                                            \
                              label.font.family="$LABEL_FONT_FAMILY"                        \
                              label.font.style=$LABEL_FONT_STYLE                            \
                              label.font.size=$LABEL_FONT_SIZE                              \
                              label.padding_left=$PADDINGS                                  \
                              label.padding_right=$PADDINGS                                 \
                              icon.font.family="$ICON_FONT_FAMILY"                          \
                              icon.font.style=$ICON_FONT_STYLE                              \
                              icon.font.size=$ICON_FONT_SIZE                                \
                              icon.padding_left=$PADDINGS                                   \
                              icon.padding_right=$PADDINGS                                  \
                              background.padding_right=$PADDINGS                            \
                              background.padding_left=$PADDINGS

        sketchybar --add event window_focus
        sketchybar --add event title_change

        # for yabai_mode
        sketchybar --add event space_change

        sketchybar --add item arch left                                                         \
                   --set arch icon="󰀵"                                                              \
                              icon.font.size=20                                                     \
                              icon.color=0xff7aa1f7                                                 \
                              icon.y_offset=1                                                       \
                              background.drawing=on                                                 \
                              background.padding_left=13                                            \
                              background.padding_right=12                                           \
                              click_script="open -a Launchpad"

        sketchybar -m --add item yabai_mode left \
              --set yabai_mode update_freq=3 \
              --set yabai_mode icon="" \
              --set yabai_mode background.padding_right=12 \
              --set yabai_mode script="${sketchybar_scripts}/yabai_mode.sh" \
              --set yabai_mode click_script="${sketchybar_scripts}/yabai_mode_click.sh" \
              --subscribe yabai_mode space_change

        SPACE_CLICK_SCRIPT="yabai -m space --focus \$SID 2>/dev/null"
        sketchybar --add   space          space_template left                                  \
               --set   space_template icon.color=0xff583794                                  \
                                      icon.highlight_color=0xffe0af68                        \
                                      icon.font.size=20                                          \
                                      label.drawing=off                                      \
                                      drawing=on                                             \
                                      updates=on                                             \
                                      associated_display=1                                   \
                                      icon.padding_left=0                                    \
                                      icon.padding_right=48                                  \
                                      icon.font.size=18                                      \
                                      background.color=0xff252630                            \
                                      background.height=$BACKGROUND_HEIGHT                   \
                                      background.corner_radius=$BACKGROUND_CORNER_RADIUS     \
                                      background.padding_right=-16                           \
                                      background.padding_left=-16                           \
                                      click_script="$SPACE_CLICK_SCRIPT"                     \
                                      ignore_association=on                                  \
                                                                                             \
               --clone spaces.1       space_template                                         \
               --set   spaces.1       associated_space=1                                     \
                                      icon=                                                 \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                      icon.padding_left=4                                   \
                                                                                             \
               --clone spaces.2       space_template                                         \
               --set   spaces.2       associated_space=2                                     \
                                      icon=󰨞                                                \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.3       space_template                                         \
               --set   spaces.3       associated_space=3                                     \
                                      icon=                                               \
                                      drawing=on                                             \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.4       space_template                                         \
               --set   spaces.4       associated_space=4                                     \
                                      icon=󰆼                                                 \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.5       space_template                                         \
               --set   spaces.5       associated_space=5                                     \
                                      icon=󰇮                                                 \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.6       space_template                                         \
               --set   spaces.6       associated_space=6                                     \
                                      icon=󰈙                                                \                                               \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.7       space_template                                         \
               --set   spaces.7       associated_space=7                                     \
                                      icon=                                                 \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.8       space_template                                         \
               --set   spaces.8       associated_space=8                                     \
                                      icon=                                                \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.9       space_template                                         \
               --set   spaces.9       associated_space=9                                     \
                                      icon=󰎆                                                 \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                                                                             \
               --clone spaces.10      space_template                                         \
               --set   spaces.10      associated_space=10                                    \
                                      icon=󰘑                                                \
                                      script="${sketchybar_scripts}/space.sh"                          \
                                      icon.padding_right=16                                   \
                                                                                             \
               --add   bracket        spaces                                                 \
                                      spaces.1                                               \
                                      spaces.2                                               \
                                      spaces.3                                               \
                                      spaces.4                                               \
                                      spaces.5                                               \
                                      spaces.6                                               \
                                      spaces.7                                               \
                                      spaces.8                                               \
                                      spaces.9                                               \
                                      spaces.10                                              \



        #. "$ITEM_DIR/cava.sh"
        # . "$ITEM_DIR/feishu.sh"
        #. "$ITEM_DIR/wechat.sh"
        #. "$ITEM_DIR/email.sh"



        # . "$ITEM_DIR/window_title.sh"

        # add right right to left
        #. "$ITEM_DIR/tray.sh"
        #. "$ITEM_DIR/time.sh"
        #. "$ITEM_DIR/system.sh"
        #. "$ITEM_DIR/wifi.sh"
        #. "$ITEM_DIR/battery.sh"

        #. "$ITEM_DIR/mic.sh"
        #. "$ITEM_DIR/sound.sh"
        # . "$ITEM_DIR/music.sh"

        #. "$ITEM_DIR/bluetooth.sh"
        # . "$ITEM_DIR/vpn.sh"

        sketchybar --update


      '';
  };
}
