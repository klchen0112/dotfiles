{
  pkgs,
  lib,
  config,
  ...
}:
{
  stylix.targets.waybar = {
    enable = true;
    enableLeftBackColors = true;
    enableRightBackColors = true;
    enableCenterBackColors = true;
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
          "image"
          "wlr/taskbar"
          "niri/window"
        ];
        modules-center = [
          "niri/workspaces"
        ];
        modules-right = [
          "clock"
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
        "image" = {
          path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          on-click = "niri msg action toggle-overview";
          size = 22;
          tooltip = false;
        };
        "wlr/taskbar" = {
          all-outputs = false;
          format = "{icon}";
          icon-size = 16;
          tooltip = true;
          tooltip-format = "{title}";
          active-first = true;
          on-click = "activate";
        };
        "niri/window" = {
          max-length = 50;
          format = "{app_id}";
          separate-outputs = true;
          on-click = "walker --modules windows";
          icon = true;
          icon-size = 18;
        };
        "niri/workspaces" = {
          all-outputs = false;
          on-click = "activate";
          current-only = false;
          disable-scroll = false;
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

      };
    };

  };
}
