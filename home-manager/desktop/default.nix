{ inputs, pkgs, lib, config, ... }:
{

  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
  ];

  # app lanchuer


  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        randr
        rink
        shell
        symbols
        translate
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    # custom css for anyrun, based on catppuccin-mocha
    extraCss = ''
      @define-color bg-col  rgba(30, 30, 46, 0.7);
      @define-color bg-col-light rgba(150, 220, 235, 0.7);
      @define-color border-col rgba(30, 30, 46, 0.7);
      @define-color selected-col rgba(150, 205, 251, 0.7);
      @define-color fg-col #D9E0EE;
      @define-color fg-col2 #F28FAD;

      * {
        transition: 200ms ease;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 1.3rem;
      }

      #window {
        background: transparent;
      }

      #plugin,
      #main {
        border: 3px solid @border-col;
        color: @fg-col;
        background-color: @bg-col;
      }
      /* anyrun's input window - Text */
      #entry {
        color: @fg-col;
        background-color: @bg-col;
      }

      /* anyrun's ouput matches entries - Base */
      #match {
        color: @fg-col;
        background: @bg-col;
      }

      /* anyrun's selected entry - Red */
      #match:selected {
        color: @fg-col2;
        background: @selected-col;
      }

      #match {
        padding: 3px;
        border-radius: 16px;
      }

      #entry, #plugin:hover {
        border-radius: 16px;
      }

      box#main {
        background: rgba(30, 30, 46, 0.7);
        border: 1px solid @border-col;
        border-radius: 15px;
        padding: 5px;
      }
    '';
  };




  # the idle timeout
  services.swayidle = {
    enable = true;
  };

  # locking the screen
  programs.swaylock = {
    enable = true;
  };

  home.packages = with pkgs; [
    swaybg # the wallpaper
    wl-clipboard # logout menu
    mako # notif
  ];

  programs.wlogout.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # package = pkgs.hyprland;
    # plugins=[];
    xwayland.enable = true;
    # systemd.enable = true;
    # settings = {

    # };
    extraConfig =
      let scripts = ./scripts;
      in ''
        #-- Output ----------------------------------------------------
        # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.

        # format:
        #    monitor=name,resolution,position,scale
        #  monitor=HDMI-A-2,3840x2160@60,0x0,1.6
        #workspace=HDMI-A-2,1


        #-- Input ----------------------------------------------------
        # Configure mouse and touchpad here.
        input {
          kb_layout=us
          kb_variant=
          kb_model=
          kb_options=
          kb_rules=
          follow_mouse=1
          natural_scroll=0
          force_no_accel=0
          # repeat_rate=
          # repeat_delay=
          numlock_by_default=1
        }


        #-- General ----------------------------------------------------
        # General settings like MOD key, Gaps, Colors, etc.
        general {
            sensitivity=2.0
          apply_sens_to_raw=0

            gaps_in=5
            gaps_out=10

            border_size=4
            col.active_border=0xFFB4A1DB
            col.inactive_border=0xFF343A40
        }


        #-- Decoration ----------------------------------------------------
        # Decoration settings like Rounded Corners, Opacity, Blur, etc.
        decoration {
            rounding=8       # Original: rounding=-1
            #multisample_edges=0

            active_opacity=1.0
            inactive_opacity=0.9
            fullscreen_opacity=1.0

            #blur=0
            #blur_size=3 			# minimum 1
            #blur_passes=1 			# minimum 1, more passes = more resource intensive.
            # blur_ignore_opacity=0

            # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
            # if you want heavy blur, you need to up the blur_passes.
            # the more passes, the more you can up the blur_size without noticing artifacts.
        }

        #-- Animations ----------------------------------------------------
        animations {
            enabled=1
            animation=windows,1,8,default,popin 80%
            animation=fadeOut,1,8,default
            animation=fadeIn,1,8,default
            animation=workspaces,1,8,default
            #animation=workspaces,1,6,overshot
        }

        #-- Dwindle ----------------------------------------------------
        dwindle {
            pseudotile=0 			# enable pseudotiling on dwindle
        }

        #-- Keybindings ----------------------------------------------------


        # -- Terminal --
        bind=SUPER,Return,exec,wezterm


        $app_launcher = ${scripts}/menu


        # -- App Launcher --
        bind=ALT,D,exec,$app_launcher

        # Focus
        bind=ALT,b,movefocus,l
        bind=ALT,f,movefocus,r
        bind=ALT,p,movefocus,u
        bind=ALT,n,movefocus,d

        # Move
        bind=ALTSHIFT,b,movewindow,l
        bind=ALTSHIFT,f,movewindow,r
        bind=ALTSHIFT,p,movewindow,u
        bind=ALTSHIFT,n,movewindow,d
      '';




  };

  home.file.".config/hypr/themes".source = "${inputs.catppuccin-hyprland}/themes";



  fonts.fontconfig.enable = true;

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "temperature"
          "wlr/workspaces"
        ];

        "temperature" = {
          "format" = "\uf2c9 {temperatureC}\u00b0C";
          "tooltip" = false;
        };

        "wlr/workspaces" = {
          "format" = "{icon}";
          "on-click" = "activate";
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "〇";
            "focused" = "";
            "default" = "";
          };
        };


        modules-right = [
          "memory"
          "cpu"
          "clock"
          "tray"
        ];


        memory = {
          "format" = "\udb83\udee0 {percentage}%";
          "interval" = 1;
          "states" = {
            "warning" = 85;
          };
        };

        cpu = {
          format = "\udb80\udf5b {usage}%";
          interval = 1;
        };


        clock = {
          "interval" = 60;
          "align" = 0;
          "rotate" = 0;
          "tooltip-format" = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          "format" = " {:%H:%M}";
          "format-alt" = " {:%a %b %d, %G}";
        };

        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
      };

    };
    style = ''
      * {
        font-family: "JetBrainsMono";
        font-size: 12pt;
        font-weight: bold;
        border-radius: 8px;
        transition-property: background-color;
        transition-duration: 0.5s;
      }
      @keyframes blink_red {
        to {
          background-color: rgb(242, 143, 173);
          color: rgb(26, 24, 38);
        }
      }
      .warning,
      .critical,
      .urgent {
        animation-name: blink_red;
        animation-duration: 1s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      window#waybar {
        background-color: transparent;
      }
      window > box {
        margin-left: 5px;
        margin-right: 5px;
        margin-top: 5px;
        background-color: #1e1e2a;
        padding: 3px;
        padding-left: 8px;
        border: 2px none #33ccff;
      }
      #workspaces {
        padding-left: 0px;
        padding-right: 4px;
      }
      #workspaces button {
        padding-top: 5px;
        padding-bottom: 5px;
        padding-left: 6px;
        padding-right: 6px;
      }
      #workspaces button.active {
        background-color: rgb(181, 232, 224);
        color: rgb(26, 24, 38);
      }
      #workspaces button.urgent {
        color: rgb(26, 24, 38);
      }
      #workspaces button:hover {
        background-color: rgb(248, 189, 150);
        color: rgb(26, 24, 38);
      }
      tooltip {
        background: rgb(48, 45, 65);
      }
      tooltip label {
        color: rgb(217, 224, 238);
      }
      #custom-launcher {
        font-size: 20px;
        padding-left: 8px;
        padding-right: 6px;
        color: #7ebae4;
      }
      #mode,
      #clock,
      #memory,
      #temperature,
      #cpu,
      #mpd,
      #custom-wall,
      #temperature,
      #backlight,
      #pulseaudio,
      #network,
      #battery,
      #custom-powermenu {
        padding-left: 10px;
        padding-right: 10px;
      }

      /* #mode { */
      /* 	margin-left: 10px; */
      /* 	background-color: rgb(248, 189, 150); */
      /*     color: rgb(26, 24, 38); */
      /* } */
      #memory {
        color: rgb(181, 232, 224);
      }
      #cpu {
        color: rgb(245, 194, 231);
      }
      #clock {
        color: rgb(217, 224, 238);
      }
      /* #idle_inhibitor {
                       color: rgb(221, 182, 242);
                     }*/
      #custom-wall {
        color: #33ccff;
      }
      #temperature {
        color: rgb(150, 205, 251);
      }
      #backlight {
        color: rgb(248, 189, 150);
      }
      #pulseaudio {
        color: rgb(245, 224, 220);
      }
      #network {
        color: #abe9b3;
      }
      #network.disconnected {
        color: rgb(255, 255, 255);
      }
      #custom-powermenu {
        color: rgb(242, 143, 173);
        padding-right: 8px;
      }
      #tray {
        padding-right: 8px;
        padding-left: 10px;
      }
      #mpd.paused {
        color: #414868;
        font-style: italic;
      }
      #mpd.stopped {
        background: transparent;
      }
      #mpd {
        color: #c0caf5;
      }


    '';
  };
}
