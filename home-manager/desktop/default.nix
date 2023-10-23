{ inputs, pkgs, lib, config, ... }:
{

  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
  ];

  # app lanchuer


  programs.anyrun = {
    enable = false;
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
    enable = false;
  };

  # locking the screen
  programs.swaylock = {
    enable = false;
  };

  home.packages = with pkgs; [
    # swaybg # the wallpaper
    # wl-clipboard # logout menu
    # mako # notif
  ];

  programs.wlogout.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # package = pkgs.hyprland;
    # plugins=[];
    xwayland.enable = true;
    extraConfig =
    let scripts = ./hypr;
    in
    ''
      source=${scripts}/monitors.conf
      source=${scripts}/settings.conf
      source=${scripts}/rules.conf
      source=${scripts}/binds.conf
      source=${scripts}/theme.conf
      source=${scripts}/exec.conf
    '';
  };

  # home.file.".config/hypr/themes".source = "${inputs.catppuccin-hyprland}/themes";

  fonts.fontconfig.enable = true;

  programs.waybar = {
    enable = false;
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
