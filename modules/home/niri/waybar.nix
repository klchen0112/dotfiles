{
  pkgs,
  lib,
  config,
  ...
}:
{
  stylix.targets.waybar.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = lib.mkAfter "
    @define-color text           #${config.lib.stylix.colors.base05};
    @define-color red            #${config.lib.stylix.colors.base08};
    @define-color orange         #${config.lib.stylix.colors.base09};
    @define-color yellow         #${config.lib.stylix.colors.base0A};
    @define-color green          #${config.lib.stylix.colors.base0B};
    @define-color cyan           #${config.lib.stylix.colors.base0C};
    @define-color blue           #${config.lib.stylix.colors.base0D};
    @define-color magenta        #${config.lib.stylix.colors.base0E};
    @define-color brown          #${config.lib.stylix.colors.base0F};
    @define-color bright-red     #${config.lib.stylix.colors.base12};
    @define-color bright-yellow  #${config.lib.stylix.colors.base0A};
    @define-color bright-green   #${config.lib.stylix.colors.base0B};
    @define-color bright-cyan    #${config.lib.stylix.colors.base0C};
    @define-color bright-blue    #${config.lib.stylix.colors.base0D};
    @define-color bright-magenta #${config.lib.stylix.colors.base0E};
    #waybar {
      /* background: rgba(17, 17, 17, 0.5); */
      background: transparent;
      color: @text;
      border-radius: 0px 5px 5px 18px;
    }

    ";
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
