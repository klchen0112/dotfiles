{ inputs, pkgs, lib, config, ... }:
{

  imports = [

    # inputs.hyprland.homeManagerModules.default
    ./launcher/home.nix
    ./notice/home.nix # hyprland notification manager
    ./statusBar/home.nix
    ./wallpaper/home.nix
  ];




  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    plugins = [ inputs.hycov.packages.${pkgs.system}.hycov ];
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 2; # 0|1|2|3
        float_switch_override_focus = 2;
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };
      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 3;
        # col = {
        #   active_border = "rgb(ffc0cb)";
        #   inactive_border = "rgba(595959aa)";
        # };
        layout = "dwindle"; # master|dwindle
      };
      dwindle = {
        no_gaps_when_only = false;
        force_split = 0;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
        special_scale_factor = 0.8;
        no_gaps_when_only = false;
      };
      # cursor_inactive_timeout = 0
      decoration = {
        # multisample_edges = true;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        rounding = 0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        # blur_size = 3;
        # blur_passes = 1;
        # blur_new_optimizations = true;
        # blur_xray = true;
        # blur_ignore_opacity = false;

        drop_shadow = false;
        shadow_range = 4;
        shadow_render_power = 3;
        shadow_ignore_window = true;
        # col.shadow =
        # col.shadow_inactive
        # shadow_offset
        dim_inactive = false;
        # dim_strength = #0.0 ~ 1.0
        # col_shadow = "rgba(1a1a1aee)";
      };


      animations = {
        enabled = true;
        bezier = "overshot, 0.13, 0.99, 0.29, 1.1";
        animation = [
          "windows, 1, 4, overshot, slide"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 5, default"
          "fade, 1, 8, default"
          "workspaces, 1, 6, overshot, slidevert"
        ];
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 4;
        workspace_swipe_distance = 250;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 15;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = false;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
      };
      monitor = [
        "HDMI-A-1, 3840x2160, 0x0, 1"
      ];
      workspace = [
        "HDMI-A-1,10"
      ];

      plugin = {
        hycov = {
          overview_gappo = 24; # gas width from screen
          overview_gappi = 18; # gas width from clients
          hotarea_size = 10; # hotarea size in bottom left,10x10
          enable_hotarea = 1; # move cursor to bottom-left can toggle overview
        };
      };
      "$mainMod" = "ALT";
      bind = [
        "$mainMod      , Return, exec          , alacritty"
        "$mainMod      , Space, exec          , wofi --allow-images --hide-scroll --insensitive --no-actions --show drun"
        "$mainMod SHIFT, P     , killactive    ,"
        "$mainMod SHIFT, Q     , exit          ,"
        "$mainMod SHIFT, Space , togglefloating,"
        "$mainMod SHIFT, F     , fullscreen    ,"
        "$mainMod      , P     , pseudo    ,"
        "$mainMod      , J     , togglesplit    ,"
        # -- App Launcher --
        "$mainMod SUPER, F     ,exec            ,firefox"

        # Focus
        "$mainMod,b,movefocus,l"
        "$mainMod,f,movefocus,r"
        "$mainMod,p,movefocus,u"
        "$mainMod,n,movefocus,d"

        # Move
        "$mainMod SHIFT,b,movewindow,l"
        "$mainMod SHIFT,f,movewindow,r"
        "$mainMod SHIFT,p,movewindow,u"
        "$mainMod SHIFT,n,movewindow,d"
      ];

    };

  };

  # home.file.".config/hypr/themes".source = "${inputs.catppuccin-hyprland}/themes";

  fonts.fontconfig.enable = true;

}
