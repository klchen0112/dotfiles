{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
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

      };
    };

  };
}
