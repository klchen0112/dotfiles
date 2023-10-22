{ inputs, pkgs, lib, config, ... }:
{

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      primary = {
        mode = "dock";
        # layer = "top";
        height = 40;
        margin = "6";
        # position = "top";
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" "custom/hello-from-waybar" ];
        modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
      };


    };
    style = ''
      * {
            border: none;
            border-radius: 0;
            font-family: Source Code Pro;
          }
          window#waybar {
            background: #16191C;
            color: #AAB2BF;
          }
          #workspaces button {
            padding: 0 5px;
          }
    '';


  };
}

