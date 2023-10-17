{ inputs, pkgs, lib, config, ... }:
{
  home.file.".config/hypr" = {
    source = ./hypr-conf;
    recursive = true;
  };
  home.packages = with pkgs; [
    # hyprland
    waybar # the status bar
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  fonts.fontconfig.enable = true;

  programs.waybar = {
    enable = true;
    # settings = ''
    # '';
    # style = ''
    # '';
    # settings = {
    #   layer = "top";
    # };

  };
}
