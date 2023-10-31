{ inputs, pkgs, lib, config, ... }:
{

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      # target = "graphical-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "mpd"
        ];

        "custom/launcher" = {
          "format" = " ";
          "on-click" = "bash $HOME/.config/hypr/scripts/menu";
          "tooltip" = false;
        };

        "temperature" = {
          #"critical-threshold"= 80;
          "tooltip" = false;
          "format" = " {temperatureC}°C";
        };
        "hyprland/workspaces" = {
          "format" = "{name}";
          "on-click" = "activate";
          # "on-scroll-up" = "hyprctl dispatch workspace e+1";
          # "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };

        modules-center = [
          "clock"
        ];

        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          /* "tooltip-format"= "{=%A; %d %B %Y}\n<tt>{calendar}</tt>" */
          # "tooltip-format" = "上午：高数\n下午：Ps\n晚上：Golang\n<tt>{calendar}</tt>";
        };

        modules-right = [
          "pulseaudio"
          "backlight"
          "memory"
          "cpu"
          "network"
          # "custom/powermenu"
          "tray"
        ];
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "pamixer -t";
          "tooltip" = false;
        };
        "backlight" = {
          "device" = "intel_backlight";
          "on-scroll-up" = "light -A 5";
          "on-scroll-down" = "light -U 5";
          "format" = "{icon} {percent}%";
          "format-icons" = [ "󰃝" "󰃞" "󰃟" "󰃠" ];
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰍛 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰻠 {usage}%";
        };
        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰀂 {ifname} ({ipaddr})";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩 {essid}";
          "interval" = 1;
          "tooltip" = false;
        };
        # "custom/powermenu" = {
        #   "format" = "";
        #   # "on-click" = "pkill rofi || ~/.config/rofi/powermenu.sh";
        #   "tooltip" = false;
        # };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };

      };

    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
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
      .warning, .critical, .urgent {
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
      #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
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
      color: rgb(192, 202, 245);
      font-style: italic;
      }
      #mpd.stopped {
      background: transparent;
      }
      #mpd {
      color: #E4E8EF;

      /* color: #c0caf5; */
      }
      #custom-cava-internal{
        font-family: "Hack Nerd Font" ;
      }
    '';
  };
}
