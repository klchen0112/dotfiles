{pkgs, ...}: {
  services.aerospace = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };

  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [jq];
    ## config from https://github.com/Kainoa-h/aerospace-sketchybar/tree/main
    config = let
      plugin_dir = ./plugins;
    in ''
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

      ##### Changing Defaults #####
      # We now change some default values, which are applied to all further items.
      # For a full list of all available item properties see:
      # https://felixkratz.github.io/SketchyBar/config/items


      sketchybar --default  padding_left=5 \
                            padding_right=5 \
                            icon.font="Hack Nerd Font:Bold:16.0" \
                            label.font="SF Pro:Semibold:16.0" \
                            icon.color=0xBB352f36 \
                            label.color=0xBB352f36 \
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

      # This only works for single monitor configs!
      for sid in $(aerospace list-workspaces --monitor focused); do
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change \
          --set space.$sid \
          drawing=off \
          background.color=0x44ffffff \#0xAAFF00FF \
          background.corner_radius=5 \
          background.drawing=on \
          background.border_color=0xAAFFFFFF \
          background.border_width=1 \
          background.height=23 \
          background.padding_right=5 \
          background.padding_left=5 \
          icon="$sid" \
          icon.shadow.drawing=off \
          icon.padding_left=10 \
          label.font="sketchybar-app-font:Regular:16.0" \
          label.padding_right=20 \
          label.padding_left=0 \
          label.y_offset=-1 \
          label.shadow.drawing=off \
          click_script="aerospace workspace $sid" \
          script="$PLUGIN_DIR/aerospace.sh $sid"
      done

      # Load Icons on startup
      for sid in $(aerospace list-workspaces --monitor focused --empty no); do
        apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

        sketchybar --set space.$sid drawing=on

        icon_strip=" "
        if [ $apps != "" ]; then
          while read -r app; do
            icon_strip+=" $($PLUGIN_DIR/icon_map_fn.sh "$app")"
          done <<<$apps
        else
          icon_strip=""
        fi
        sketchybar --set space.$sid label="$icon_strip"
      done

      sketchybar --add item hahamarginleftRight left --set hahamarginleftRight padding_right=0 padding_left=0 width=0 margin_right=0 margin_left=0

      # Front app!!
      # sketchybar --add item front_app q\
      #   --set front_app icon.drawing=off \
      #   label.padding_left=0 \
      #   label.margin_left=0 \
      #   script="$PLUGIN_DIR/front_app.sh" \
      #   --subscribe front_app front_app_switched

      sketchybar --add item space_separator \
        --set space_separator icon="💩" \
        icon.padding_left=20 \
        icon.padding_right=0 \
        icon.margin_right=0 \
        label.drawing=off \
        label.padding_left=0 \
        label.margin_left=0 \
        background.drawing=off \
        script="$PLUGIN_DIR/space_windows.sh" \
        --subscribe space_separator aerospace_workspace_change

      ##### Adding Right Items #####
      # In the same way as the left items we can add items to the right side.
      # Additional position (e.g. center) are available, see:
      # https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

      # Some items refresh on a fixed cycle, e.g. the clock runs its script once
      # every 10s. Other gititems respond to events they subscribe to, e.g. the
      # volume.sh script is only executed once an actual change in system audio
      # volume is registered. More info about the event system can be found here:
      # https://felixkratz.github.io/SketchyBar/config/events

      sketchybar --add item hahamarginrirrght right --set hahamarginrirrght margin_left=0

      sketchybar --add item clock right \
        --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh"

      sketchybar  --add item volume right \
        --set volume script="$PLUGIN_DIR/volume.sh"
        --subscribe volume volume_change

      sketchybar --add item battery right \
        --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
        --subscribe battery system_woke power_source_change

      sketchybar --add item wifi right \
        --set wifi update_freq=20 script="$PLUGIN_DIR/wifi.sh" icon.padding_right=0 label.padding_left=0 label.font="SF Pro:Italic:12.0" label.y_offset=-3

      # sketchybar  --add item swap e \
      #     --set swap update_freq=20 script="$PLUGIN_DIR/memswap.sh"\
      #     icon="" \
      #     label.font="Hack Nerd Font:Italic:14.0" \
      #     icon.color=0x44FFFFFF \
      #     label.color=0x44FFFFFF

      #### Groups !!! ####
      sketchybar --add bracket spaces '/space\..*/' hahamarginleft hahamarginleftRight \
        --set spaces background.color=0xDAfef3c7 \
        background.corner_radius=10 \
        background.height=30

      sketchybar --add bracket rightItems clock volume battery wifi \
        --set rightItems background.color=0xDAfef3c7 \
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
    active_color = "0xCFFF69B4";
    inactive_color = "0x55FFFFFF";
  };
}
