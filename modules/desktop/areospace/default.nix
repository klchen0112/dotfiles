{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  services.aerospace = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };

  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [jq];
    ## config from https://github.com/Kainoa-h/aerospace-sketchybar/tree/main
    config = let
      plugins_path = ./plugins;
    in ''
        # A simple sketchybar config for aerospace users to get started with
      # Not too different from the base starting config!

      PLUGIN_DIR="${plugins_path}"

      ##### Bar Appearance #####
      # Configuring the general appearance of the bar.
      # These are only some of the options available. For all options see:
      # https://felixkratz.github.io/SketchyBar/config/bar
      # If you are looking for other colors, see the color picker:
      # https://felixkratz.github.io/SketchyBar/config/tricks#color-picker

      sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000

      ##### Changing Defaults #####
      # We now change some default values, which are applied to all further items.
      # For a full list of all available item properties see:
      # https://felixkratz.github.io/SketchyBar/config/items

      sketchybar --default padding_left=5 \
                            padding_right=5 \
                            icon.font="Hack Nerd Font:Bold:16.0" \
                            label.font="SF Pro:Semibold:16.0" \
                            icon.color=0xffffffff \
                            label.color=0xffffffff \
                            icon.padding_left=4 \
                            icon.padding_right=4 \
                            label.padding_left=4 \
                            label.padding_right=4 \
                            updates=on

      ##### Adding aeropsace layouts #####

      # Add the aerospace_workspace_change event we specified in aerospace.toml
      sketchybar --add event aerospace_workspace_change

      # This only works for single monitor configs!
      for sid in $(aerospace list-workspaces --monitor 1); do
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change \
          --set space.$sid \
          drawing=off \
          background.color=0x44ffffff \
          background.corner_radius=5 \
          background.drawing=on \
          background.border_color=0xAAFFFFFF \
          background.border_width=0 \
          background.height=25 \
          icon="$sid" \
          icon.padding_left=10 \
          icon.shadow.distance=4 \
          icon.shadow.color=0xA0000000 \
          label.font="sketchybar-app-font:Regular:16.0" \
          label.padding_right=20 \
          label.padding_left=0 \
          label.y_offset=-1 \
          label.shadow.drawing=off \
          label.shadow.color=0xA0000000 \
          label.shadow.distance=4 \
          click_script="aerospace workspace $sid" \
          script="$CONFIG_DIR/plugins/aerospace.sh $sid"
      done

      # Load Icons on startup
      for sid in $(aerospace list-workspaces --monitor 1 --empty no); do
        apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

        sketchybar --set space.$sid drawing=on

        icon_strip=" "
        if [ "$apps" != "" ]; then
          while read -r app; do
            icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
          done <<<"$apps"
        else
          icon_strip=""
        fi
        sketchybar --set space.$sid label="$icon_strip"
      done

      sketchybar --add item space_separator left \
        --set space_separator icon="💩" \
        icon.padding_left=4 \
        label.drawing=off \
        background.drawing=off \
        script="$PLUGIN_DIR/space_windows.sh" \
        --subscribe space_separator aerospace_workspace_change

      # Front app!!
      sketchybar --add item front_app left \
        --set front_app icon.drawing=off \
        script="$PLUGIN_DIR/front_app.sh" \
        --subscribe front_app front_app_switched

      ##### Adding Right Items #####
      # In the same way as the left items we can add items to the right side.
      # Additional position (e.g. center) are available, see:
      # https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

      # Some items refresh on a fixed cycle, e.g. the clock runs its script once
      # every 10s. Other gititems respond to events they subscribe to, e.g. the
      # volume.sh script is only executed once an actual change in system audio
      # volume is registered. More info about the event system can be found here:
      # https://felixkratz.github.io/SketchyBar/config/events

      sketchybar --add item clock right \
        --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh" \
        --add item volume right \
        --set volume script="$PLUGIN_DIR/volume.sh" \
        --subscribe volume volume_change \
        --add item battery right \
        --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
        --subscribe battery system_woke power_source_change \
        --add item swap e \
        --set swap update_freq=20 script="$PLUGIN_DIR/memswap.sh" \
        icon="" \
        label.font="Hack Nerd Font:Italic:13.0" \
        icon.color=0x44FFFFFF \
        label.color=0x44FFFFFF

        ##### Force all scripts to run the first time (never do this in a script) #####
        sketchybar --update

    '';
  };
  services.jankyborders = {
    enable = true;
    width = 6.0;
    hidpi = true;
    active_color = "0xCFFF69B4";
    inactive_color = "0x55FFFFFF";
  };
}
