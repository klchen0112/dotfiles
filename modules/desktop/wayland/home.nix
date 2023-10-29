{ inputs, pkgs, lib, config, ... }:
{

  imports = [
    inputs.hyprland.homeManagerModules.default
    ./launcher/home.nix
    ./notice/home.nix # hyprland notification manager
    ./statusBar/home.nix
    ./wallpap
  ];




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


}
