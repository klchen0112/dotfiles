{
  den.aspects.waybar.waybar =
    {
      pkgs,
      ...
    }:
    {
      stylix.targets.waybar = {
        enable = true;
        enableLeftBackColors = true;
        enableRightBackColors = true;
        enableCenterBackColors = true;
        addCss = true;
      };
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            mod = "dock";
            margin-left = 15;
            margin-right = 15;
            margin-top = 4;
            margin-bottom = 4;
            reload_style_on_change = true;
            spacing = 0;
            modules-left = [
              # "custom/spacer"
              "image"
              "wlr/taskbar"
              "niri/window"
              "custom/window-icon"
              "mpris"
              "custom/mpris-icon"
            ];
            modules-center = [
              "niri/workspaces"
            ];
            modules-right = [
              "custom/clock-icon"
              "clock"
              "custom/tray-icon"
              "memory"
              "cpu"
              "backlight"
              "battery"
              "battery#bat2"
              "network"
              "idle_inhibitor"
              "pulseaudio"
              "tray"
            ];

            # Module configuration: Left
            "custom/spacer" = {
              format = "   ";
              on-click = "niri msg action toggle-overview";
            };
            "image" = {
              path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
              on-click = "niri msg action toggle-overview";
              size = 22;
              tooltip = false;
            };
            "hyprland/workspaces" = {
              disable-scroll = false;
              all-outputs = false;
              active-only = false;
              format = "<span><b>{icon}</b></span>";
              format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "6" = "6";
                "7" = "7";
                "8" = "8";
                "9" = "9";
                urgent = " ";
              };
            };
            "niri/workspaces" = {
              all-outputs = false;
              on-click = "activate";
              current-only = false;
              disable-scroll = false;
              icon-theme = "Papirus-Dark";
              format = "<span><b>{icon}</b></span>";
              format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "6" = "6";
                "7" = "7";
                "8" = "8";
                "9" = "9";
              };
            };
            "wlr/taskbar" = {
              all-outputs = false;
              format = "{icon}";
              icon-theme = "Papirus-Dark";
              icon-size = 16;
              tooltip = true;
              tooltip-format = "{title}";
              active-first = true;
              on-click = "activate";
            };
            "hyprland/window" = {
              max-length = 50;
              format = "<i>{title}</i>";
              separate-outputs = true;
              icon = true;
              icon-size = 13;
            };
            "niri/window" = {
              max-length = 50;
              format = "{app_id}";
              separate-outputs = true;
              on-click = "walker --modules windows";
              # icon = true;
              # icon-size = 18;
              rewrite = {
                "" = " Niri";
                " " = " Niri";
                # terminals
                "com.mitchellh.ghostty" = "󰊠 Ghostty";
                "kitty" = "󰄛 Kitty";
                # code
                "code" = "󰨞 Code";
                "Cursor" = "󰨞 Cursor";
                # browsers
                "brave-browser" = " Brave";
                "Vivaldi-stable" = " Vivaldi";
                "firefox" = " Firefox";
                "zen" = " Zen";
                # gnome/gtk
                "org.gnome.Nautilus" = "󰪶 Files";
                # misc
                "spotify" = " Spotify";
                "Slack" = " Slack";
                "signal" = "󰭹 Signal";
                # Productivity
                "Morgen" = " Morgen";
                "org.kde.okular" = " Okular";
                "tana" = "󰠮 Tana";
                "obsidian" = "󰠮 Obsdian";
                "Zotero" = "󰬡 Zotero";
                "org.pulseaudio.pavucontrol" = " Pavucontrol";
                # Everything else
                "(.*)" = "$1";
              };
            };

            # Module configuration: Center
            clock = {
              format = "<b>{:%a %b[%m] %d ▒ %I:%M %p}</b>";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%H:%M %Y-%m-%d}";
            };

            # Module configuration: Right
            pulseaudio = {
              format = "{icon}";
              format-bluetooth = "󰂰";
              format-muted = "";
              tooltip-format = "{name} {volume}%";
              format-icons = {
                "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
                "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                phone-muted = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                ];
              };
              scroll-step = 1;
              on-click = "pavucontrol";
            };
            network = {
              format-wifi = " ";
              format-ethernet = " ";
              tooltip-format = "{essid} ({signalStrength}%)";
              format-linked = "{ifname} (No IP)";
              format-disconnected = "󰅛 ";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };
            memory = {
              interval = 1;
              rotate = 270;
              format = "{icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              max-length = 10;
            };
            cpu = {
              interval = 1;
              format = "{icon}";
              rotate = 270;
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
            };
            backlight = {
              format = "{icon}";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
            };
            battery = {
              states = {
                # good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{icon}";
              format-charging = "";
              format-plugged = "";
              format-alt = "{capacity}% {icon}";
              # format-icons = ["" "" "" "" "" "" "" ""];
              format-icons = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              tooltip-format = "{capacity}% {time}";
              tooltip = true;
            };
            "battery#bat2" = {
              bat = "BAT2";
            };
            tray = {
              icon-size = 18;
              spacing = 10;
            };
            "idle_inhibitor" = {
              format = "<i>{icon}</i>";
              start-activated = false;
              format-icons = {
                activated = " ";
                deactivated = " ";
              };
              tooltip-format-activated = "Swayidle inactive";
              tooltip-format-deactivated = "Swayidle active";
            };
            mpris = {
              interval = 2;
              format = "{player_icon}{dynamic}{status_icon}";
              format-paused = "{player_icon}{dynamic}{status_icon}";
              tooltip = true;
              tooltip-format = "{dynamic}";
              on-click = "playerctl play-pause";
              on-click-middle = "playerctl previous";
              on-click-right = "playerctl next";
              scroll-step = 5.0;
              smooth-scrolling-threshold = 1;
              dynamic-len = 30;
              player-icons = {
                chromium = " ";
                brave-browser = " ";
                default = " ";
                firefox = " ";
                kdeconnect = " ";
                mopidy = " ";
                mpv = "󰐹 ";
                spotify = " ";
                vlc = "󰕼 ";
              };
              status-icons = {
                playing = "";
                paused = "";
                stopped = "";
              };
            };
            # Custom icons
            "custom/toggl-icon" = {
              format = "󱎫";
            };
            "custom/audio-icon" = {
              format = "";
            };
            "custom/network-icon" = {
              format = "󰖩";
            };
            "custom/backlight-icon" = {
              format = "󰌵";
            };
            "custom/battery-icon" = {
              format = "󰁹";
            };
            "custom/clock-icon" = {
              format = "";
            };
            "custom/mpris-icon" = {
              format = " ";
            };
            "custom/idle-icon" = {
              format = " ";
            };
            "custom/tray-icon" = {
              format = "󱊖";
              on-click = "swaync-client -t";
              tooltip = "Notification center";
            };
            "custom/window-icon" = {
              format = " ";
              on-click = "walker --modules windows";
              tooltip = "Window list";
            };
          };
        };
      };
    };
}
