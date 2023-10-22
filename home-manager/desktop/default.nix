{ inputs, pkgs, lib, config, ... }:
{

  home.packages = with pkgs; [
    wofi
    swaybg
    wlsunset
    wl-clipboard
    hyprland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    # plugins=[];
    xwayland.enable = true;
    systemdIntegration = true;
    extraConfig = ''
      $mod = SUPER

      env = _JAVA_AWT_WM_NONREPARENTING,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = WLR_DRM_NO_ATOMIC,1

      # set cursor for HL itself

      exec-once = systemctl --user start clight
      exec-once = eww open bar
      exec-once = eww open osd

      # use this instead of hidpi patches
      xwayland {
        force_zero_scaling = true
      }

      misc {
        # disable auto polling for config file changes
        disable_autoreload = true

        force_default_wallpaper = 0

        # disable dragging animation
        animate_mouse_windowdragging = false

        # enable variable refresh rate (effective depending on hardware)
        vrr = 1
      }

      # touchpad gestures
      gestures {
        workspace_swipe = true
        workspace_swipe_forever = true
      }

      group {
        groupbar {
          font_size = 16
          gradients = false
        }

      }

      input {
        kb_layout = ro

        # focus change on cursor move
        follow_mouse = 1
        accel_profile = flat
        touchpad {
          scroll_factor = 0.3
        }
      }

      device:MSFT0001:00 04F3:31EB Touchpad {
        accel_profile = adaptive
        natural_scroll = true
        sensitivity = 0.1
      }
      device:elan1200:00-04f3:3090-touchpad {
        accel_profile = adaptive
        natural_scroll = true
        sensitivity = 0.1
      }

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 1
        col.active_border = rgba(88888888)
        col.inactive_border = rgba(00000088)

        allow_tearing = true
      }

      decoration {
        rounding = 16
        blur {
          enabled = true
          size = 10
          passes = 3
          new_optimizations = true
          brightness = 1.0
          contrast = 1.0
          noise = 0.02
        }

        drop_shadow = true
        shadow_ignore_window = true
        shadow_offset = 0 2
        shadow_range = 20
        shadow_render_power = 3
        col.shadow = rgba(00000055)
      }

      animations {
        enabled = true
        animation = border, 1, 2, default
        animation = fade, 1, 4, default
        animation = windows, 1, 3, default, popin 80%
        animation = workspaces, 1, 2, default, slide
      }

      dwindle {
        # keep floating dimentions while tiling
        pseudotile = true
        preserve_split = true
      }

      plugin {
        csgo-vulkan-fix {
          res_w = 1280
          res_h = 800
        }
      }

      # telegram media viewer
      windowrulev2 = float, title:^(Media viewer)$

      # allow tearing in games
      windowrulev2 = immediate, class:^(osu\!|cs2)$

      # make Firefox PiP window floating and sticky
      windowrulev2 = float, title:^(Picture-in-Picture)$
      windowrulev2 = pin, title:^(Picture-in-Picture)$

      # throw sharing indicators away
      windowrulev2 = workspace special silent, title:^(Firefox — Sharing Indicator)$
      windowrulev2 = workspace special silent, title:^(.*is sharing (your screen|a window)\.)$

      # start spotify tiled in ws9
      windowrulev2 = tile, title:^(Spotify)$
      windowrulev2 = workspace 9 silent, title:^(Spotify)$

      # start Discord/WebCord in ws2
      windowrulev2 = workspace 2, title:^(.*(Disc|WebC)ord.*)$

      # idle inhibit while watching videos
      windowrulev2 = idleinhibit focus, class:^(mpv|.+exe)$
      windowrulev2 = idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$
      windowrulev2 = idleinhibit fullscreen, class:^(firefox)$

      windowrulev2 = dimaround, class:^(gcr-prompter)$

      # fix xwayland apps
      windowrulev2 = rounding 0, xwayland:1, floating:1
      windowrulev2 = center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$
      windowrulev2 = size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$

      $layers = ^(eww-.+|bar|system-menu|anyrun|gtk-layer-shell)$
      layerrule = blur, $layers
      layerrule = ignorealpha 0, $layers
      layerrule = ignorealpha 0.5, ^(eww-music)$

      layerrule = xray 1, ^(bar|gtk-layer-shell)$

      # mouse movements
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
      bindm = $mod ALT, mouse:272, resizewindow

      # compositor commands
      bind = $mod SHIFT, E, exec, pkill Hyprland
      bind = $mod, Q, killactive,
      bind = $mod, F, fullscreen,
      bind = $mod, G, togglegroup,
      bind = $mod SHIFT, N, changegroupactive, f
      bind = $mod SHIFT, P, changegroupactive, b
      bind = $mod, R, togglesplit,
      bind = $mod, T, togglefloating,
      bind = $mod, P, pseudo,
      bind = $mod ALT, ,resizeactive,
      # toggle "monocle" (no_gaps_when_only)
      $kw = dwindle:no_gaps_when_only
      bind = $mod, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))
    '';
  };


  fonts.fontconfig.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainbar = {
      layer = "top";
      position = "top";
      };
    };
    # style = {

    # };
    systemd.enable = true;

  };
}
