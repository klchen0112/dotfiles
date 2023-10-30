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
          "on-click" = "wofi --allow-images --hide-scroll --insensitive --no-actions --show drun";
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
          "custom/powermenu"
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
        "custom/powermenu" = {
          "format" = "";
          # "on-click" = "pkill rofi || ~/.config/rofi/powermenu.sh";
          "tooltip" = false;
        };
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
        border-radius: 0px;
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
      background-color: #3b4252;
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
      color:#D8DEE9;
      }
      #workspaces button.active {
      background-color: rgb(181, 232, 224);
      color: rgb(26, 24, 38);
      }
      #workspaces button.urgent {
      color: rgb(26, 24, 38);
      }
      #workspaces button:hover {
      background-color: #B38DAC;
      color: rgb(26, 24, 38);
      }
      tooltip {
      /* background: rgb(250, 244, 252); */
      background: #3b4253;
      }
      tooltip label {
      color: #E4E8EF;
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
      color: #8EBBBA;
      }
      #cpu {
      color: #B38DAC;
      }
      #clock {
      color: #E4E8EF;
      }
      #custom-wall {
      color: #B38DAC;
      }
      #temperature {
      color: #80A0C0;
      }
      #backlight {
      color: #A2BD8B;
      }
      #pulseaudio {
      color: #E9C98A;
      }
      #network {
      color: #99CC99;
      }

      #network.disconnected {
      color: #CCCCCC;
      }
      #battery.charging, #battery.full, #battery.discharging {
      color: #CF876F;
      }
      #battery.critical:not(.charging) {
      color: #D6DCE7;
      }
      #custom-powermenu {
      color: #BD6069;
      }
      #tray {
      padding-right: 8px;
      padding-left: 10px;
      }
      #tray menu {
      background: #3b4252;
      color: #DEE2EA;
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
