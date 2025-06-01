{ config, pkgs, ... }:
{
  services.aerospace = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.hack
  ];
  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [ jq ];
    ## config from https://github.com/Kainoa-h/aerospace-sketchybar/tree/main
    config =
      let
        plugin_dir = ./plugins;
      in
      ''
        #!/usr/bin/env bash
        # A simple sketchybar config for aerospace users to get started with
        # Not too different from the base starting config!

        PLUGIN_DIR=${plugin_dir}
        ##### Bar Appearance #####
        # Configuring the general appearance of the bar.
        # These are only some of the options available. For all options see:
        # https://felixkratz.github.io/SketchyBar/config/bar
        # If you are looking for other colors, see the color picker:
        # https://felixkratz.github.io/SketchyBar/config/tricks#color-picker

        sketchybar --bar position=top height=40 blur_radius=30 color=0x00000000

        # sketchybar --add event window_focus
        # sketchybar --add event title_change
        # sketchybar --add event front_app_switched
        # sketchybar --add event space_windows_change

        ##### Changing Defaults #####
        # We now change some default values, which are applied to all further items.
        # For a full list of all available item properties see:
        # https://felixkratz.github.io/SketchyBar/config/items


        sketchybar --default  padding_left=5 \
                              padding_right=5 \
                              icon.font="Hack Nerd Font:Bold:16.0" \
                              label.font="SF Pro:Semibold:16.0" \
                              icon.color=0xff${config.lib.stylix.colors.base04} \
                              label.color=0xff${config.lib.stylix.colors.base04} \
                              icon.padding_left=4 \
                              icon.padding_right=4 \
                              label.padding_left=4 \
                              label.padding_right=4 \
                              updates=on \
                              y_offset=-3

        sketchybar --add item hamarginleft left --set hahamarginleft padding_right=0 padding_left=0 width=5

        sketchybar --add item hahamarginleft left --set hahamarginleft padding_right=0 padding_left=0 width=15

        ##### Adding aeropsace layouts #####
        # Add the aerospace_workspace_change event we specified in aerospace.toml
        sketchybar --add event aerospace_workspace_change

        focused_workspace=$(aerospace list-workspaces --focused)

        # This only works for single monitor configs!
        for sid in $(aerospace list-workspaces --all); do
          sketchybar --add item space.$sid left \
            --subscribe space.$sid aerospace_workspace_change \
            --set space.$sid \
            drawing=off \
            background.color=0xff${config.lib.stylix.colors.base00} \
            background.corner_radius=5 \
            background.drawing=on \
            background.border_color=0xff${config.lib.stylix.colors.base03} \
            background.border_width=1 \
            background.height=23 \
            background.padding_right=5 \
            background.padding_left=5 \
            icon="$sid" \
            icon.shadow.drawing=off \
            icon.padding_left=10 \
            icon.highlight_color=0xff${config.lib.stylix.colors.base05} \
            label.font="sketchybar-app-font:Regular:16.0" \
            label.padding_right=20 \
            label.padding_left=0 \
            label.highlight_color=0xff${config.lib.stylix.colors.base05} \
            label.y_offset=-1 \
            label.shadow.drawing=off \
            click_script="aerospace workspace $sid" \
            script="$PLUGIN_DIR/space_windows.sh"
        done

        # Load Icons on startup
        for sid in $(aerospace list-workspaces --all); do
            apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}' | sort -u)
            if [ -z "$apps" ]; then
                continue  # 跳过当前循环的剩余部分，继续下一次循环
            fi

            icon_strip=" "
            while read -r app; do
                icon_strip+=" $($PLUGIN_DIR/icon_map_fn.sh "$app")"
            done <<<$apps

            sketchybar --set space.$sid label="$icon_strip" drawing=on
        done


        sketchybar --add item hahamarginleftRight left --set hahamarginleftRight padding_right=0 padding_left=0 width=0 margin_right=0 margin_left=0

        sketchybar  --add item window_title center\
                    --set window_title icon="" \
                    --set window_title label="" \
                    icon.font="sketchybar-app-font:Regular:16.0" \
                    icon.padding_left=20 \
                    icon.padding_right=0 \
                    icon.margin_right=20 \
                    icon.drawing=on \
                    label.drawing=on \
                    label.padding_left=0 \
                    label.margin_left=0 \
                    drawing=on \
                    script="$PLUGIN_DIR/window_title.sh" \
                    --subscribe window_title front_app_switched                       \
                    --subscribe window_title window_focus                             \
                    --subscribe window_title title_change

        ##### Adding Right Items #####
        # In the same way as the left items we can add items to the right side.
        # Additional position (e.g. center) are available, see:
        # https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

        # Some items refresh on a fixed cycle, e.g. the clock runs its script once
        # every 10s. Other gititems respond to events they subscribe to, e.g. the
        # volume.sh script is only executed once an actual change in system audio
        # volume is registered. More info about the event system can be found here:
        # https://felixkratz.github.io/SketchyBar/config/events

        sketchybar  --add item hahamarginrirrght right --set hahamarginrirrght margin_left=0

        sketchybar  --add alias 'TextInputMenuAgent' right \
                    --set 'TextInputMenuAgent'  update_freq=3  script="${plugin_dir}/tray.sh"  \
                    --add item clock right \
                    --set clock update_freq=10 script="${plugin_dir}/clock.sh" \
                    --add item volume right \
                    --set volume script="${plugin_dir}/volume.sh" \
                    --subscribe volume volume_change \
                    --add item battery right \
                    --set battery update_freq=120 script="${plugin_dir}/battery.sh" \
                    --subscribe battery system_woke power_source_change \
                    --add item network_down right\
                    --set network_down icon=󰇚 update_freq=1 script="${plugin_dir}/speed.sh" icon.highlight_color=0xff${config.lib.stylix.colors.base05}\
                    --add item network_up right\
                    --set network_up icon=󰕒  icon.highlight_color=0xff${config.lib.stylix.colors.base04}\
                    label.font="Hack Nerd Font:Italic:14.0" \
                    icon.font="Hack Nerd Font:Heavy:16.0"




        #### Groups !!! ####
        sketchybar  --add bracket spaces '/space\..*/' hahamarginleft hahamarginleftRight \
                    --set spaces background.color=0xff${config.lib.stylix.colors.base01} \
                          background.corner_radius=10 \
                          background.height=30



        ##### Force all scripts to run the first time (never do this in a script) #####
        sketchybar --update

      '';
  };
  services.jankyborders = {
    enable = true;
    width = 6.0;
    hidpi = true;
    active_color = "${config.lib.stylix.colors.base03}";
    inactive_color = "${config.lib.stylix.colors.base01}";
  };
}
